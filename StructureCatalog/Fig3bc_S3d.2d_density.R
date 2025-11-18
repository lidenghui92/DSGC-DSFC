library(tidyverse)
library(ggplot2)
library(hexbin)
data<-read.table("DS-PDB_density.m8",header = F,sep = "\t") #for Fig4. b, use DS-AFDB_density.dat, for Fig4. c, use DS-DS_density.dat
p<-ggplot(data, aes(y=V3, x=V4) ) +
  geom_hex(bins = 300) +
  scale_fill_gradient2(name="count",
                    breaks=(c(40,80,120)),
                    low='#edf8b1',high='#0c2c84',mid="#7fcdbb",
                    midpoint=60) +
  scale_x_continuous(expand = c(0, 0),limits = c(0.5,1)) +
  scale_y_continuous(expand = c(0, 0),limits = c(0,1)) +
  theme(
    legend.position='none'
  )+
  theme_bw()
pdf("density_plot.pdf",w=6,h=5)
p
dev.off()