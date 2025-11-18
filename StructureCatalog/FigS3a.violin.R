library(ggplot2)
library(tidyverse)

dat <- read.table("FigS3a.DSFC.3Dstat.tsv",header=F,sep="\t")

dat <- dat %>%
  mutate(V5_100 = V5 * 100)
df <- dat %>%
  select(V4, V5_100) %>%
  pivot_longer(cols = everything(),
               names_to = "var",
               values_to  = "value")


p<-ggplot(df,aes(x=var,y=value,fill=var))+
  geom_violin(alpha=0.8)+
  scale_x_discrete(labels=c("pLDDT","pTM"))+
  theme_bw()
p
