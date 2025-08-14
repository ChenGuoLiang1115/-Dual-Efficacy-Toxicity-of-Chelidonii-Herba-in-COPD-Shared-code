rm(list=ls())
setwd("C:\\Users\\chenguoliang\\Desktop\\分子对接\\热图\\打分热图\\白屈菜-COPD")
getwd()

library("pacman")
p_load(pheatmap, ggplot2)

yifeng <- read.table("biodate.txt", header=T, row.names=1, sep="\t")
yifeng = as.data.frame(yifeng)

pdf(file = "热图.pdf")
p <- pheatmap(yifeng, 
              border="white",
              cluster_cols = F,
              cluster_rows = F,
              fontsize_row = 10,
              fontsize_col = 10,
              cellwidth = 40, cellheight = 20,
              fontsize_number = 10, 
              display_numbers = T, 
              number_color="black",
              fontfamily_row = "sans",   # 使用系统默认无衬线字体
              fontfamily_col = "sans",   # 通常Windows上就是Arial
              fontfamily = "sans")       # 数字字体

dev.off()