setwd("C:\\Users\\chenguoliang\\Desktop\\网络药理学\\核心靶点\\filter1")

in_file = "score1.txt"     # 原始评分数据
out_file = "score2.txt"    # 过滤后数据

# 读取输入数据（保留行名）
input_data = read.table(in_file, header = TRUE, sep = "\t", 
                        check.names = FALSE, row.names = 1)

# 确定过滤条件数量
num_filters = ncol(input_data)

# 创建二进制矩阵（1=超过该条件中位数）
binary_matrix = apply(input_data, 2, function(x) {
  median_val = median(x)
  cat("首次过滤条件", names(x)[1], "中位值:", median_val, "\n")
  as.integer(x > median_val)
})
rownames(binary_matrix) = rownames(input_data)

# 筛选全条件达标的基因
selected_genes = rownames(binary_matrix)[rowSums(binary_matrix) == num_filters]

# 输出过滤结果
filtered_data = input_data[selected_genes, ]
write.table(cbind(Gene = selected_genes, filtered_data), 
            file = out_file, sep = "\t", quote = FALSE, row.names = FALSE)
writeLines(selected_genes, "score2.gene11.txt")