library(tidyverse)
library(rstatix)
library(ggpubr)
dct<-read.table("all.psg.abd_wlcx.tsv",header=T,sep="\t")
dcav = dct %>%
        group_by(PC,REt) %>%
        summarise (mean = mean(Dtc_DS,na.rm=T)) %>%
        pivot_wider(names_from = REt,values_from=mean) 
dcfc = dct %>% 
	group_by(PC,REt) %>% 
	summarise (mean = mean(Dtc_DS,na.rm=T)) %>% 
	pivot_wider(names_from = REt,values_from=mean) %>% 
	summarise(FC = REG/NS)

#sP = dct %>% 
#	group_by(PC) %>%
#	shapiro_test(Dtc_DS)
#tres <- dcav %>% left_join(dcfc) %>% left_join(sP)
#write.table(tres,file="shapirotest.tsv",sep="\t",row.names=F)

#tP = dct %>%
#  group_by(PC) %>%
#  t_test(DS ~ PsT,var.equal=T)
#
#tP_FDR = tP %>%
#  select(1,last_col()) %>%
#  mutate(FDR = p.adjust(.$p,method = "BH"))
#
#tres <- dcav %>% left_join(dcfc) %>% left_join(tP_FDR)
#write.table(tres,file="PSG_dectFC_tP_DS.tsv",sep="\t",row.names = F)
#
wP = dct %>%
  group_by(PC) %>%
  wilcox_test(Dtc_DS ~ REt)
wP_FDR = wP %>%
  select(1,last_col()) %>%
  mutate(FDR = p.adjust(.$p,method = "BH"))  
wres<- dcav %>% left_join(dcfc) %>% left_join(wP_FDR)
write.table(wres,file="PSG_dectFC_wP_DS.tsv",sep="\t",row.names = F)
