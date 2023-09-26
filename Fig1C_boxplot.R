library(ggplot2)
library(reshape2)
library(ggpubr)

mydata <- read.table("Fig1C_mapping_rate.csv",header=TRUE,sep=",")
my_comp <- list(c("MS", "HE"),c("HV", "HE"),c("OE", "HE"),c("MS", "OE"),c("HV", "MS"),c("OE", "HV"))

pdf("Fig1C.pdf",width = 6,height = 6)

p_between <- ggboxplot(mydata, x = "eco_group" , y = "mapping_rate")+
  stat_compare_means(comparisons=my_comp)+
  stat_compare_means(label.y = 1)
p_between

dev.off()
