# ====================== 富集数据FDR批量校正工具 ======================
# 功能：自动批量处理BP/CC/MF/KEGG数据的FDR校正（所有FDR阈值<0.01）
# ===============================================================

# 1. 初始化设置 ---------------------------------------------------------
# 安装必要包（如果尚未安装）
required_packages <- c("readxl", "dplyr", "openxlsx")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

# 加载包
suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(openxlsx)
})

# 2. 定义FDR校正函数 ----------------------------------------------------
run_fdr_correction <- function(input_file) {
  # 设置输出文件名
  output_file <- sub("\\.xlsx$", "_FDR校正结果.xlsx", input_file)
  
  # 检查文件是否存在
  if (!file.exists(input_file)) {
    message("跳过：文件 ", input_file, " 不存在")
    return(invisible())
  }
  
  message("\n", rep("=", 50))
  message("开始处理文件: ", input_file)
  message(rep("=", 50))
  
  # 3. 读取Excel文件 ----------------------------------------------------
  # 读取Excel文件（自动修复重复列名）
  raw_data <- tryCatch({
    read_excel(input_file, .name_repair = "unique")
  }, error = function(e) {
    message("文件读取失败: ", e$message)
    return(invisible())
  })
  
  # 4. P值列处理 -------------------------------------------------------
  # 检查"P值"列是否存在
  if ("P值" %in% colnames(raw_data)) {
    message("使用'P值'列作为P值列")
  } else {
    # 尝试查找可能的P值列
    p_cols <- grep("p|值", colnames(raw_data), ignore.case = TRUE, value = TRUE)
    
    if (length(p_cols) == 0) {
      message("错误：未找到P值列！跳过此文件")
      return(invisible())
    }
    
    colnames(raw_data)[colnames(raw_data) %in% p_cols[1]] <- "P值"
    message("使用'", p_cols[1], "'列作为P值列")
  }
  
  # 5. 数据清洗与转换 ---------------------------------------------------
  # 创建处理副本
  processed_data <- raw_data
  
  # 重命名可能引起冲突的列
  colnames(processed_data) <- make.names(colnames(processed_data), unique = TRUE)
  
  # 添加P_Value列
  processed_data$P_Value <- suppressWarnings(as.numeric(processed_data$P值))
  
  # 统计有效/无效数据
  valid_rows <- sum(!is.na(processed_data$P_Value) & 
                      processed_data$P_Value >= 0 & 
                      processed_data$P_Value <= 1)
  invalid_rows <- nrow(processed_data) - valid_rows
  
  if (invalid_rows > 0) {
    message("注意：发现 ", invalid_rows, " 行无效P值（NA或超出[0,1]范围），将被排除")
  }
  
  # 过滤无效数据
  processed_data <- processed_data %>%
    filter(!is.na(P_Value),
           P_Value >= 0,
           P_Value <= 1)
  
  # 6. FDR校正计算 -----------------------------------------------------
  # 计算总检验数
  n_tests <- nrow(processed_data)
  message("有效P值数量: ", n_tests)
  
  if (n_tests == 0) {
    message("错误：没有有效的P值可用于分析，跳过此文件")
    return(invisible())
  }
  
  # 所有数据类型使用相同FDR阈值<0.01
  fdr_threshold <- 0.01
  message("使用FDR阈值: ", fdr_threshold)
  
  # 执行Benjamini-Hochberg校正
  processed_data <- processed_data %>%
    arrange(P_Value) %>%
    mutate(
      Rank = row_number(),
      FDR_BH = p.adjust(P_Value, method = "BH"),
      Significant = ifelse(FDR_BH < fdr_threshold, "Yes", "No")
    )
  
  # 7. 结果分析 --------------------------------------------------------
  # 统计显著结果
  significant_results <- processed_data %>% filter(Significant == "Yes")
  n_significant <- nrow(significant_results)
  significance_percent <- round(n_significant / n_tests * 100, 1)
  
  # 输出统计摘要
  message("\n校正结果摘要")
  message("总检验数: ", n_tests)
  message("显著结果(FDR<", fdr_threshold, "): ", n_significant, " (", significance_percent, "%)")
  message("最小原始P值: ", min(processed_data$P_Value))
  message("最小FDR值: ", min(processed_data$FDR_BH))
  
  # 8. 结果保存 --------------------------------------------------------
  # 创建带格式的Excel输出
  wb <- createWorkbook()
  
  # 添加完整结果表
  addWorksheet(wb, "FDR校正结果")
  writeData(wb, "FDR校正结果", processed_data)
  
  # 添加显著结果表（如果有显著结果）
  if (n_significant > 0) {
    addWorksheet(wb, paste0("显著结果(FDR<", fdr_threshold, ")"))
    writeData(wb, paste0("显著结果(FDR<", fdr_threshold, ")"), significant_results)
  }
  
  # 添加说明页
  addWorksheet(wb, "使用说明")
  instructions <- data.frame(
    参数 = c("数据来源", "FDR方法", "显著阈值", "处理日期", "有效数据", "显著结果"),
    值 = c(input_file, "Benjamini-Hochberg", paste0("FDR < ", fdr_threshold), 
          format(Sys.Date(), "%Y-%m-%d"), 
          paste(n_tests, "行"), 
          paste(n_significant, "行"))
  )
  writeData(wb, "使用说明", instructions)
  
  # 保存Excel文件
  saveWorkbook(wb, output_file, overwrite = TRUE)
  message("\n结果已保存至: ", output_file)
  
  # 9. 结果可视化 ------------------------------------------------------
  # 创建校正效果图
  plot_data <- processed_data %>%
    arrange(P_Value) %>%
    mutate(Index = row_number())
  
  # 创建散点图
  plot_file <- sub("\\.xlsx$", "_FDR校正图.png", input_file)
  png(plot_file, width = 800, height = 600)
  
  plot(plot_data$Index, -log10(plot_data$FDR_BH),
       col = ifelse(plot_data$FDR_BH < fdr_threshold, "red", "blue"),
       pch = 19, cex = 0.7,
       main = paste0("FDR校正结果可视化 (", input_file, ")"),
       xlab = "项目排序（按P值升序）",
       ylab = "-log10(FDR)")
  
  # 添加显著阈值线
  abline(h = -log10(fdr_threshold), col = "red", lty = 2)
  text(x = max(plot_data$Index)*0.8, y = -log10(fdr_threshold)+0.2, 
       paste0("FDR=", fdr_threshold, "阈值"), col = "red")
  
  # 添加图例
  legend("topleft", 
         legend = c(paste0("显著 (n=", n_significant, ")"), 
                    paste0("不显著 (n=", n_tests - n_significant, ")")),
         col = c("red", "blue"), pch = 19)
  
  dev.off()
  message("可视化图表已保存至: ", plot_file)
  
  # 10. 返回成功信息 ---------------------------------------------------
  return(list(
    input_file = input_file,
    output_file = output_file,
    n_tests = n_tests,
    n_significant = n_significant
  ))
}

# 3. 批量处理所有文件 --------------------------------------------------
# 定义需要处理的所有文件
file_list <- c(
  "BP数据.xlsx", 
  "CC数据.xlsx", 
  "MF数据.xlsx", 
  "KEGG数据.xlsx"
)

# 存储处理结果
results <- list()

# 循环处理每个文件
for (file in file_list) {
  result <- run_fdr_correction(file)
  if (!is.null(result)) {
    results[[file]] <- result
  }
}

# 4. 生成汇总报告 ------------------------------------------------------
if (length(results) > 0) {
  cat("\n\n", rep("=", 50), "\n")
  cat(" FDR校正批处理汇总报告 (所有FDR阈值<0.01)\n")
  cat(rep("=", 50), "\n")
  
  # 创建汇总数据框
  summary_df <- data.frame(
    文件 = character(),
    总项目数 = integer(),
    显著项目数 = integer(),
    输出文件 = character(),
    图表文件 = character(),
    stringsAsFactors = FALSE
  )
  
  # 填充汇总数据
  for (res in results) {
    summary_df <- rbind(summary_df, data.frame(
      文件 = res$input_file,
      总项目数 = res$n_tests,
      显著项目数 = res$n_significant,
      输出文件 = res$output_file,
      图表文件 = sub("\\.xlsx$", "_FDR校正图.png", res$input_file),
      stringsAsFactors = FALSE
    ))
  }
  
  # 打印汇总表
  print(summary_df)
  
  # 保存汇总报告
  summary_file <- "FDR校正_汇总报告.txt"
  sink(summary_file)
  cat(rep("=", 50), "\n")
  cat(" FDR校正批处理汇总报告 (所有FDR阈值<0.01)\n")
  cat(rep("=", 50), "\n\n")
  cat("处理时间: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")
  cat("所有数据类型使用FDR阈值: 0.01\n\n")
  print(summary_df)
  sink()
  
  cat("\n汇总报告已保存至: ", summary_file)
}

cat("\n\n所有文件处理完成！\n")