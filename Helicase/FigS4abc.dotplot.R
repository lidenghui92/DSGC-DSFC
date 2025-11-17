library(ggplot2)
library(ggpubr)
library(readxl)

dat <- read_excel("FigS4abc.AF2_pLDDT_time.xlsx",sheet="FigS4ab")
datc <- read_excel("FigS4abc.AF2_pLDDT_time.xlsx",sheet="FigS4abc_raw")

my_comp <- list(c("0_200_AF2_MSA","0_200_DS_MSA"),c("200_1000_AF2_MSA","200_1000_DS_MSA"))

#FigS4a
pa <- ggplot(dat,aes(y=pLDDT,x=Group,fill=MSA))+
  geom_violin()+
  geom_boxplot(width=0.1,color="#FFFFFF")+
  scale_y_continuous(limits = c(30,110),
                     breaks = c(40,60,80,100))+
  scale_fill_manual(values = c("AF2_MSA"="#717171","DS_MSA"="#1D2B70"))+
  stat_compare_means(comparisons = my_comp,label.y=100)+
  theme_bw()
pa

#FigS4b
pb <- ggplot(dat,aes(y=time_min,x=Group,fill=MSA))+
  geom_boxplot()+
  scale_y_continuous(limits = c(0,200),
                     breaks = c(0,25,50,100,150,200))+
  scale_fill_manual(values = c("AF2_MSA"="#717171","DS_MSA"="#1D2B70"))+
  stat_compare_means(comparisons = my_comp,label.y=180)+
  theme_bw()
pb

#FigS4c
pc <- ggplot(datc, aes(y=DSMSA_pLDDT, x=AF2MSA_pLDDT,color=TM_score)) +
  geom_point(size=2.5) + 
  scale_color_gradient2(limits=c(0,1),breaks=c(0.1,0.3,0.5,0.7,0.9),
                        mid = "#EEEEEE",high = "#0D0C71",midpoint = 0.5,low = "#FF0000") +
  scale_y_continuous(limits = c(70,100),breaks = c(70,80,90,100)) +
  scale_x_continuous(limits = c(70,100),breaks = c(70,80,90,100)) +
  theme_bw()
pc

