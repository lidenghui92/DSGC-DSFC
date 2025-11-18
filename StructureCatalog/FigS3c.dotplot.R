library(ggplot2)
library(ggpubr)

dat<-read.table("FigS3c.ESMFold_vs_AF3_plddt_tmscore.tsv",header=T,sep="\t")

p <- ggplot(dat, aes(y=ESMFold_plddt_aa, x=AF3_plddt_aa,color=tmscore)) +
  geom_point(size=2.5) + 
  scale_color_gradient2(limits=c(0,1),breaks=c(0.1,0.3,0.5,0.7,0.9),
                        mid = "#EEEEEE",high = "#0D0C71",midpoint = 0.5,low = "#FF0000") +
  scale_y_continuous(limits = c(70,100),breaks = c(70,80,90,100)) +
  scale_x_continuous(limits = c(70,100),breaks = c(70,80,90,100)) +
  theme_bw()
p
