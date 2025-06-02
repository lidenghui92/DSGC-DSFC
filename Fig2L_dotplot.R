library(ggplot2)
library(reshape2)
library(ggpubr)
library(tidyr)
library(hrbrthemes)
library(ggpmisc)
library(ggExtra)

PSG<-read.table("hyphy_stat.tsv",header=T,sep="\t")

p <- ggplot(PSG, aes(x=Seqs, y=Rate,color=RGC)) +
  geom_point() + 
  theme_bw()

p <- ggMarginal(p, type="density",groupFill = T,groupColour = T) 
p

pdf("corelation.pdf",w=12,h=12)
p 
dev.off()
