library(ggplot2)
library(sp)
library(RColorBrewer)
library(ggplot2)
library(reshape2)
library(ggpubr)
library(ggpmisc)
#Umap plot colored by clusters 
mydata<-NULL
mp<-NULL
mydata<-read.table("PC_Matrix_Det100_Enrich_0.5_coor.txt",header=TRUE,sep="\t")
UMAP_1<-mydata[,3]
UMAP_2<-mydata[,4]
mp<-ggplot(mydata,aes(x=UMAP_1,y=UMAP_2,color=clstr))+
  geom_point(size=3)+
  theme_bw()+
  scale_x_continuous(breaks = c(-15,-10,-5,0,5,10,15))+
  scale_y_continuous(breaks = c(-20,-15,-10,-5,0,5,10,15,20))+
  scale_color_manual(values = c('#3300CC','#1E90FF','#006400','#8B0000','#43CD80','#551A8B','#FFC125','#006400','#10CFEF','#4169E1','#3A5FCD','#330099','#4000ED','#B22222','#000033'))
mp

#Umap plot colored by abundance 
adb<-read.table("list_for_figure.abund.matrix.tsv",header = T,sep="\t")
p <- ggplot(adb,aes(x=UMAP_1,y=UMAP_2,color=arCOG04114_PC1))+
  geom_point(size=1.5)+
  theme_bw()+
  scale_x_continuous(breaks = c(-15,-10,-5,0,5,10,15))+
  scale_y_continuous(breaks = c(-20,-15,-10,-5,0,5,10,15,20))+
  scale_color_gradient2(midpoint = 3,low = "#edf8b170",mid="#7fcdbba0",high = "#0c2c84")+
  ggtitle("arCOG04114_PC1")
p

#Bar plot of abundance and sampling depths
my_comp <- list(c("1000-4000", "4000-6000"),c("1000-4000", "6000-9000"),c("1000-4000", "9000-12000"),
                c("4000-6000", "6000-9000"),c("4000-6000", "9000-12000"),c("6000-9000", "9000-12000"))
v<- ggplot(adb,aes(x=depthG,y=COG5142_PC1,fill=depthG))+
  geom_boxplot()+
  stat_compare_means(comparisons=my_comp)+
  stat_compare_means(label.y = 4.5)+
  theme_bw()
v

#Dotplot of abundance and ambient temperatures
library(ggplot2)
library(sp)
library(RColorBrewer)
library(ggplot2)
library(reshape2)
library(ggpubr)
library(ggpmisc)

adb<-read.table("Temp_COG1110_PC1.txt",header = T,sep="\t")
p <- ggplot(adb,aes(x=TempPlus,y=COG1110_PC11))+
  geom_point(size=1)+
  scale_x_log10(breaks = c(2,11,101,401))+
  scale_y_log10(breaks=c(1,10,100,1000,10000))+
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=T)+
  theme_bw()
p + stat_cor(method="pearson",label.x=0,label.y=4)






