library(ggplot2)
library(reshape2)
library(ggpubr)

average <- function(data,column_name,ecosystem){
  H_group <- data[[column_name]][data[[paste0(ecosystem, "_Others")]] == ecosystem]
  O_group <- data[[column_name]][data[[paste0(ecosystem, "_Others")]] == 'Others']
  mean_H <- mean(H_group, na.rm = TRUE)
  mean_O <- mean(O_group, na.rm = TRUE)
  FC <- mean_H / mean_O
  test_result <- wilcox.test(H_group, O_group)
  P = test_result$p.value
  cat(paste(column_name,"Fold-change:"), round(FC, 2), "\n")
  cat(paste(column_name,"P-value:"), format.pval(P, digits = 3), "\n")
}

mydata <- NULL
mydata <- read.table("Fig2de.Cluster_Abd_significance.txt",header=TRUE,sep="\t")

average(mydata, "DSM_0039108973_RG","HV")
average(mydata, "DSM_0405589153_Cren7","HV")
average(mydata, "DSM_0192097322_OGG","HE")
average(mydata, "DSM_0109376981_Cas9","HV")

#Fig2D
tempdata <- mydata[!is.na(mydata$Temperature), ]
head(tempdata)
p_RG <- ggplot(tempdata,aes(x=Temperature+1, y=DSM_0039108973_RG+1,colors="grey"))+
  geom_point(color="#0c2c84")+
  scale_x_log10(breaks = c(1,4,40,400,500))+
  scale_y_log10(breaks=c(1,10,100,1000,10000,200000))+
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=T)+
  theme_bw()
p_RG2 <- p_RG + stat_cor(method="pearson",label.x=0,label.y=4)

pdf("Fig2d.pdf",width = 6,height = 6) 
p_RG2
dev.off()

#Fig2E
depth_levels <- c('1000_4000', '4000_6000', '6000_9000', '9000_12000')
my_comp <- combn(depth_levels, 2, simplify = FALSE)
p_OGG <- ggplot(mydata,aes(x=Depth, y=DSM_0192097322_OGG,colors="grey"))+
  geom_boxplot(outlier.shape=NA)+
  stat_compare_means(comparisons=my_comp, symnum.args = list(
    cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1),
    symbols = c("****", "***", "**", "*", "ns")),
    step.increase = 0.08,label.y = 13)+
  scale_y_continuous(breaks=c(3,6,9,12,15))+
  theme_bw()
p_OGG
pdf("Fig2e.pdf",width = 4,height = 6) 
p_OGG
dev.off()
