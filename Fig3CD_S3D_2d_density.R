library(tidyverse)
library(ggplot2)
library(hexbin)
data<-read.table("DeepseaHQDB_vs_PDB_besthit_filter0.5.m8",header = F,sep = "\t")

p<-ggplot(data, aes(y=V3, x=V15) ) +
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
pdf("density_plot_r.pdf",w=6,h=5)
p
dev.off()
