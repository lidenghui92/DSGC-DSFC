library(tidyverse)
library(rstatix)
library(ggpubr)
dct<-read.table("Fig2i.DShyphy_gene.dtc.tsv",header=T,sep="\t")
dcav = dct %>%
  group_by(GeneCluster,HyPhy_result) %>%
  summarise (mean = mean(Detection_rate,na.rm=T)) %>%
  pivot_wider(names_from = HyPhy_result,values_from=mean)
dcfc = dct %>%
  group_by(GeneCluster,HyPhy_result) %>%
  summarise (mean = mean(Detection_rate,na.rm=T)) %>%
  pivot_wider(names_from = HyPhy_result,values_from=mean) %>%
  summarise(FC = REG/NS)

#shapirotest
#sP = dct %>%
#       group_by(GeneCluster) %>%
#       shapiro_test(Detection_rate)
#tres <- dcav %>% left_join(dcfc) %>% left_join(sP)
#write.table(tres,file="shapirotest.tsv",sep="\t",row.names=F)

wP = dct %>%
  group_by(GeneCluster) %>%
  wilcox_test(Detection_rate ~ HyPhy_result)
wP_FDR = wP %>%
  select(1,last_col()) %>%
  mutate(FDR = p.adjust(.$p,method = "BH"))
wres<- dcav %>% left_join(dcfc) %>% left_join(wP_FDR)
write.table(wres,file="Fig2i.dectFC_wP.1tsv",sep="\t",row.names = F)

wres <- read.delim("Fig2i.dectFC_wP.tsv",header = T)
FC = 1.5
PValue = 0.05
wres$sig[(-1*log10(wres$FDR) < -1*log10(PValue)|wres$FDR=="NA")|(log2(wres$FC) < log2(FC))& log2(wres$FC) > -log2(FC)] <- "NotSig"
wres$sig[-1*log10(wres$FDR) >= -1*log10(PValue) & log2(wres$FC) >= log2(FC)] <- "Up"
wres$sig[-1*log10(wres$FDR) >= -1*log10(PValue) & log2(wres$FC) <= -log2(FC)] <- "Down"

p<-ggplot(wres,aes(log2(FC),-1*log10(FDR))) +  
  geom_point(aes(color = sig)) +
  labs(x="log[2](Fold Change of Detection Rate)", 
    y="-log[10](P-Value)") + 
  scale_color_manual(values = c("black","grey","#0A005F")) +
  geom_hline(yintercept=-log10(PValue),linetype=2)+
  geom_vline(xintercept=c(-log2(FC),log2(FC)),linetype=2)+
  scale_x_continuous(breaks = c(-3,-1,0,1,3))+
  scale_y_continuous(limits=c(0,6), #omit one outlier here (FDR=3.57E-16,FC=1.67)
                     breaks = c(0,2,4,6))+
  theme_bw()

pdf("Fig2i.pdf",w=12,h=12)
p
dev.off()