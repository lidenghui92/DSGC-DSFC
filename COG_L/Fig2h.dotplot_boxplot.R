library(ggplot2)
library(ggpubr)
library(patchwork)

REG<-read.table("hyphy_stat.tsv",header=T,sep="\t") 
#This input is a three-column table using data from 
#Fig2h.HyPhy_stat_5837clusters.xlsx,
#where the column names are: RGC, REG_rate, and All_members.

my_comp <- list(c("DS", "OM"),c("OM", "TS"),c("DS", "TS"))
p_dot <- ggplot(REG, aes(x=All_members, y=REG_rate,color=RGC)) +
  geom_point(alpha=0.5) +
  coord_cartesian(ylim = c(0, 1)) + 
  theme_bw()+
  theme(legend.position = "none") 
p_box <- ggplot(REG, aes(x=RGC, y = REG_rate, fill = RGC)) +
  geom_boxplot(outlier.shape=NA) +
  stat_compare_means(comparisons=my_comp,step.increase = 0.08,label.y = 0.25)+
  coord_cartesian(ylim = c(0, 1)) + 
  theme_bw()
p <- p_dot + p_box + 
  plot_layout(widths = c(5, 1))

pdf("Fig2H.pdf",w=12,h=12)
p #stat numbers
dev.off()


