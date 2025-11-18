library(tidyverse)
library(ggplot2)
library(readxl)

data <- read_xlsx("Fig3de/hyBaArPhy.category.fisherOut.xlsx")

head(data)

v<-ggplot(data,aes(y=RichFactor,x=reorder(COG_id,-RichFactor)))+
  geom_point(aes(size=log10_Fg_FgN,color=log10_Padj))+
  labs(y="")+
  scale_color_gradient(high="#00B050",low="#1D267D")+
  scale_size_continuous(range=c(1,5),limits = c(2,5),breaks = c(2,3,4,5))+
  theme_bw()
pdf("category_enrich_all_short.pdf",width = 5.6,height = 8.4)
v
dev.off()
