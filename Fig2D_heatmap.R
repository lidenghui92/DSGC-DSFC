library(ComplexHeatmap)
library(circlize)


A <- read.csv("Fig2D.csv",header = T,row.names = 1)
data <- as.matrix(A)
Group = c(rep("hydrothermal vent",100),rep("methane seep",85),rep("other ecosystems",100),rep("hadal ecosystems",100))
Group = factor(Group,levels = c("hydrothermal vent","methane seep","other ecosystems","hadal ecosystems"))
col_fun = colorRamp2(c(-4, 0, 4), c("navy","white","firebrick3"))   ###饱和度更高#2f7fc1，#ffffff，#b22222
top_annotation = HeatmapAnnotation(
  cluster = anno_block(gp = gpar(fill = c("#91BFDB","#4575B4","#FDAE61","#D7191C")),
                       labels = c("other ecosystems","hadal ecosystems","methane seep","hydrothermal vent"),
                       labels_gp = gpar(col = "white", fontsize = 6)))

m <- Heatmap(data,name = " ",
        col = col_fun,
        top_annotation = top_annotation,
        column_split = Group,
        show_heatmap_legend = T,
        border = F,
        show_column_names = F,
        show_row_names = T,
	cluster_columns = T,
	cluster_rows = F, 
	row_gap = unit(4, "mm"),  #行空白间距
        column_gap = unit(4, "mm"),   #列空白间距
        column_title = NULL)

pdf("Fig2D.pdf",w = 20, h = 10)
m
dev.off()