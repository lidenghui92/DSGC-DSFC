# volcano plot
library(ggplot2)
library(ggrepel)  

data = read.delim("PSG_dectFC_wP_DS.tsv",header = T)

FC = 1.5 
PValue = 0.05 

data$sig[(-1*log10(data$FDR) < -1*log10(PValue)|data$FDR=="NA")|(log2(data$FC) < log2(FC))& log2(data$FC) > -log2(FC)] <- "NotSig"
data$sig[-1*log10(data$FDR) >= -1*log10(PValue) & log2(data$FC) >= log2(FC)] <- "Up"
data$sig[-1*log10(data$FDR) >= -1*log10(PValue) & log2(data$FC) <= -log2(FC)] <- "Down"

ggplot(data,aes(log2(FC),-1*log10(FDR))) +   
  geom_point(aes(color = sig)) +   
  labs(x="log[2](Fold Change of Detection Rate)", 
       y="-log[10](P-Value)") + 
  scale_color_manual(values = c("black","grey","#0A005F")) +
  geom_hline(yintercept=-log10(PValue),linetype=2)+
  geom_vline(xintercept=c(-log2(FC),log2(FC)),linetype=2)+
  scale_x_continuous(breaks = c(-3,-1,0,1,3))+
  scale_y_continuous(breaks = c(0,2,4,6,8))+
  theme_bw()
# boxplot
library(ggplot2)
library(reshape2)
library(ggpubr)
library(tidyr)

mydata<-read.table("psg.abd.examples.tsv",header=TRUE,sep="\t")
head(mydata)
my_comp <- list(c("REG_HE","NS_HE"),c("REG_HV","NS_HV"),c("REG_MS","NS_MS"),c("REG_OE","NS_OE"))
ttl="Soil_0124377794"
aa <- mydata[mydata$Cluster==ttl,]
ggplot(aa,aes(x=Tag,y=Rate,color=Tag))+
  geom_boxplot()+
  scale_x_discrete(limits=c("REG_HE","NS_HE","REG_HV","NS_HV","REG_MS",
                            "NS_MS","REG_OE","NS_OE"))+
  stat_compare_means(comparisons=my_comp)+
  ggtitle(ttl)+
  theme(panel.grid=element_blank(), 
        panel.background=element_rect(fill='transparent', color='black'))


