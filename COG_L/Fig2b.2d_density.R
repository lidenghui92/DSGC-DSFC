library(ggplot2)
library(ggExtra)
library(patchwork)

dat<-read.table("Fig2b.cluster_dtc_adb.stat.tsv",header=TRUE,sep="\t")
uq<-dat[dat$excl_DS_Clusters=="DS-Uniq",]


prop_low <- mean(uq$detection <= 21) * 100
prop_high <- mean(uq$detection >= 100) * 100

p_main <- ggplot(uq, aes(x=detection, y=avg_abundance+1))+
  geom_hex() +
  geom_vline(xintercept = 21, color = "red", linetype = "dashed", size = 0.8) +
  geom_vline(xintercept = 100, color = "blue", linetype = "dashed", size = 0.8) +
  scale_fill_gradient2(name="count",trans="log10",
                       breaks=(c(10,100,1000,10000,50000)),
                       low='#edf8b1',high='#0c2c84',mid="#7fcdbb",
                       midpoint=2.8) +
  scale_y_log10(expand = c(0, 0)) +
  theme_bw()+
  labs(x=NULL)

p_density <- ggplot(uq, aes(x = detection)) +
  geom_density(fill = "lightblue", alpha = 0.7) +
  geom_vline(xintercept = 21, color = "red", linetype = "dashed", size = 0.8) +
  geom_vline(xintercept = 100, color = "blue", linetype = "dashed", size = 0.8) +
  theme_bw() +
  theme(
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    plot.margin = margin(b = 0)
  )

p_combined <- p_density / p_main + 
  plot_layout(heights = c(1, 3))
  
pdf("Fig2b.pdf",w=15,h=12)
print(p_combined)
dev.off()

