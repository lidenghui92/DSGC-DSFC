library(ggplot2)
library(ggpubr)

dat <- read.table("FigS2mn.instrain_result.txt",header=T,sep="\t")
dat_flt <- dat[!is.na(dat$pNpS_variants),]
my_comp=list(c("NS","REG"))

pm<-ggplot(dat_flt,aes(x=HyPhy_result,y=pNpS_variants,fill=HyPhy_result))+
  geom_boxplot(outlier.shape = NA)+
  stat_compare_means(comparisons=my_comp,
                     symnum.args = list(
                       cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1),
                       symbols = c("****", "***", "**", "*", "ns")),
                     step.increase = 0.08,label.y=0.7) +
  scale_y_continuous(breaks=c(0,0.2,0.4,0.6))+  
  scale_fill_manual(values=c("REG"="#1D267D","NS"="#525252"))+
  theme_bw()
pm

pn<-ggplot(dat_flt,aes(x=HyPhy_result,y=nucl_diversity,fill=HyPhy_result))+
  geom_boxplot(outlier.shape = NA)+
  stat_compare_means(comparisons=my_comp,
                     symnum.args = list(
                       cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1),
                       symbols = c("****", "***", "**", "*", "ns")),
                     label.y=0.03) +
  scale_y_continuous(breaks=c(0,0.01,0.02,0.03,0.04))+
  scale_fill_manual(values=c("REG"="#1D267D","NS"="#525252"))+
  theme_bw()
pn

