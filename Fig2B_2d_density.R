library(ggplot2)
library(ggExtra)

aaa<-read.table("COG_L_PC_detection_all.tsv",header=TRUE,sep="\t")
uq<-aaa[aaa$UorS=="DS-Uniq",]
sh<-aaa[aaa$UorS=="DS-Share",]
pdf("aab.pdf",w=15,h=12)

p <- ggplot(uq, aes(x=DS.Nosample, y=DS.abundance+1))+
  geom_hex() +
  scale_fill_gradient2(name="count",trans="log10",
                       breaks=(c(10,100,1000,10000,50000)),
                       low='#edf8b1',high='#0c2c84',mid="#7fcdbb",
                       midpoint=2.8) +
  scale_y_log10(expand = c(0, 0)) +
  theme_bw()
p
dev.off()