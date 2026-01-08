library(ggplot2)
library(dplyr)
library(patchwork)

data <- read.table("Fig3de/hqBaAr.cluster_stat.txt", header = TRUE, sep = "\t")
#this input file can be found in Fig3de.zip at Zenodo.

type_colors <- c("Same_phylum" = "grey", "Diff_domains" = "blue", "Diff_phylums" = "green")

p <- ggplot(data, aes(x = reorder(Cluster, -Size), y = Size,fill=Type)) +
  geom_bar(stat = "identity",width=1) +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "transparent"),
        plot.background = element_rect(fill = "transparent")) +
  scale_y_log10()+
  labs(y = "Size")
p

