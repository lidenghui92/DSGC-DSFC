library(ggplot2)
library(ggmap)
library(sp)
library(maptools)
library(maps)
library(ggnewscale)
library(RColorBrewer)

mp<-NULL
mapworld<-borders("world",colour = "#FFFFFF",fill="#FFFFFF")  #land colour
mp<-ggplot()+mapworld+theme(panel.background = element_rect(fill = '#E0F3F8', colour = '#E0F3F8')) #sea colour
mp<-mp+theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank()) #remove lines
mp<-mp+scale_x_continuous(breaks = c(-180,-90,0,90,180)) +scale_y_continuous(breaks = c(-60,-30,0,30,60)) #change x y
mp<-mp+geom_hline(yintercept = c(-60,-30,0,30,60),colour="#999999") + geom_vline(xintercept = c(-180,-90,0,90,180),colour="#999999")
pdf("Fig1A.pdf",w=24,h=12)

mydata.OE<-read.table("RGC_other.csv",header=TRUE,sep=",")
visit.x.OE<-mydata.OE[,3]
visit.y.OE<-mydata.OE[,2]

mydata.MS<-read.table("RGC_seep.csv",header=TRUE,sep=",")
visit.x.MS<-mydata.MS[,3]
visit.y.MS<-mydata.MS[,2]

mydata.HE<-read.table("RGC_trench.csv",header=TRUE,sep=",")
visit.x.HE<-mydata.HE[,3]
visit.y.HE<-mydata.HE[,2]

mydata.HV<-read.table("RGC_vent.csv",header=TRUE,sep=",")
visit.x.HV<-mydata.HV[,3]
visit.y.HV<-mydata.HV[,2]

mp2<-mp + 
  geom_point(alpha= 0.7,aes(x = visit.x.OE, y = visit.y.OE, size = 1, colour = 1)) +
  scale_color_gradient('Other', low = "#91BFDB", high = "#91BFDB") +
  new_scale("color") +
  geom_point(alpha= 0.8,aes(x = visit.x.MS ,y = visit.y.MS, size = 1, colour = 1)) +
  scale_color_gradient('SEEP', low = "#FDAE61", high = "#FDAE61") +
  new_scale("color") +
  geom_point(alpha= 0.8,aes(x = visit.x.HV, y = visit.y.HV, size = 1, colour = 1)) +
  scale_color_gradient('Vent', low = "#D7191C", high = "#D7191C") +
  new_scale("color") +
  geom_point(alpha= 0.8,aes(x = visit.x.HE, y = visit.y.HE, size = 1, colour = 1)) +
  scale_color_gradient('Trench', low = "#4575B4", high = "#4575B4")
mp2
dev.off()

