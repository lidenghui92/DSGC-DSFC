library(ggplot2)
library(tidyverse)

dat <- read.table("FigS2l.mafft_hyphy.tsv",header=T,sep="\t")

my_comp=list(c("DS","TS"),c("DS","OM"),c("TS","OM"))
p<-ggplot(dat,aes(x=RGC,y=REG_rate,fill=RGC))+
  geom_boxplot(outlier.shape = NA)+
  stat_compare_means(comparisons=my_comp, alternative = "greater",
                     symnum.args = list(
                       cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1),
                       symbols = c("****", "***", "**", "*", "ns")),
                     step.increase = 0.08,label.y=0.15) +
  scale_fill_manual(values=c("DS"="#1D267D","OM"="#007F20","TS"="#834026"))+
  theme_bw()
p
