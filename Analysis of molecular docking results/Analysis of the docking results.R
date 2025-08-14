# 1. 读取日志文件 - 输入：log.txt
log_content <- readLines("log.txt")

# 2. 定位结果起始位置 - 识别日志中的结果表格部分
header_line <- grep("mode \\|   affinity", log_content)
start_index <- header_line + 3  # 跳过表头和分隔线
end_index <- start_index + 19   # 共20行结果

# 3. 提取结果行
result_lines <- log_content[start_index:end_index]

# 4. 解析函数 - 处理每行数据
parse_docking_line <- function(line) {
  # 使用正则表达式提取四个数值
  matches <- regmatches(line, gregexpr("-?\\d+\\.?\\d*", line))[[1]]
  
  # 确保有4个值：模式、结合能、RMSD_LB、RMSD_UB
  if(length(matches) >= 4) {
    return(list(
      mode = as.integer(matches[1]),
      affinity = as.numeric(matches[2]),
      rmsd_lb = as.numeric(matches[3]),
      rmsd_ub = as.numeric(matches[4])
    ))
  } else {
    return(list(
      mode = NA,
      affinity = NA,
      rmsd_lb = NA,
      rmsd_ub = NA
    ))
  }
}

# 5. 创建数据框 - 预分配空间避免NA行
docking_results <- data.frame(
  Mode = integer(20),
  Affinity = numeric(20),
  RMSD_LB = numeric(20),
  RMSD_UB = numeric(20)
)

# 6. 填充数据框
for(i in 1:20) {
  parsed <- parse_docking_line(result_lines[i])
  docking_results[i, "Mode"] <- parsed$mode
  docking_results[i, "Affinity"] <- parsed$affinity
  docking_results[i, "RMSD_LB"] <- parsed$rmsd_lb
  docking_results[i, "RMSD_UB"] <- parsed$rmsd_ub
}

# 7. 移除可能的NA值
docking_results <- na.omit(docking_results)

# 8. 计算统计指标
affinities <- docking_results$Affinity
mean_affinity <- mean(affinities)
sd_affinity <- sd(affinities)
se_affinity <- sd_affinity / sqrt(length(affinities))
ci <- t.test(affinities)$conf.int

# 9. 生成统计摘要表
stats_summary <- data.frame(
  Metric = c("Mean Affinity", "Standard Deviation", 
             "Standard Error", "95% CI Lower", "95% CI Upper"),
  Value = c(mean_affinity, sd_affinity, se_affinity, ci[1], ci[2]),
  Unit = rep("kcal/mol", 5)
)

# 10. 保存结果文件

# 输出文件1：详细对接结果表
write.csv(docking_results, "Supplementary_Table_S1.csv", row.names = FALSE)

# 输出文件2：统计摘要表
write.csv(stats_summary, "Supplementary_Table_S2.csv", row.names = FALSE)

# 输出文件3：结合能分布图
png("docking_energy_distribution.png", width = 800, height = 600)
par(mar = c(5, 5, 4, 2))
hist(affinities, breaks = 10, col = "skyblue", 
     main = "分子对接结合能分布",
     xlab = "结合能 (kcal/mol)", ylab = "频率")
abline(v = mean_affinity, col = "red", lwd = 2)
legend("topright", 
       legend = c(sprintf("平均值 = %.2f", mean_affinity),
                  sprintf("标准差 = %.2f", sd_affinity)),
       col = c("red", "black"), lty = c(1, 0))
dev.off()

# 11. 控制台输出统计结果
cat("分子对接统计结果:\n")
cat(sprintf("平均结合能: %.2f ± %.2f kcal/mol (SD)\n", mean_affinity, sd_affinity))
cat(sprintf("95%%置信区间: [%.2f, %.2f]\n", ci[1], ci[2]))
cat("补充材料已生成:\n")
cat("  - Supplementary_Table_S1.csv (详细对接结果)\n")
cat("  - Supplementary_Table_S2.csv (统计摘要)\n")
cat("  - docking_energy_distribution.png (结合能分布图)\n")