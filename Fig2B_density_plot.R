library(ggplot2)
library(ggExtra)

aaa<-read.table("Fig2B.csv",header=TRUE,sep=",")

pdf("Fig2B.pdf",w=24,h=12)
# classic plot
p <- ggplot(aaa, aes(x=lognf, y=nff, color=Eff_RGC, size=1)) +
  geom_point() +
  theme(legend.position="none") +
  scale_x_continuous(limits =c(1,5))+
  scale_y_continuous(limits=c(0.5,0.95))

# marginal density
p <- ggMarginal(p, type="density",groupColour=T) 
p
dev.off()