library(ggplot2)
library(maps)
library(RColorBrewer)

mp<-NULL
mapworld<-borders("world",colour = "#FFFFFF",fill="#FFFFFF")  #land colour
mp<-ggplot()+mapworld+theme(panel.background = element_rect(fill = '#E0F3F8', colour = '#E0F3F8')) #sea colour
mp<-mp+theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank()) #remove lines
mp<-mp+scale_x_continuous(breaks = c(-180,-90,0,90,180)) +scale_y_continuous(breaks = c(-60,-30,0,30,60)) #change x y
mp<-mp+geom_hline(yintercept = c(-60,-30,0,30,60),colour="#999999") + geom_vline(xintercept = c(-180,-90,0,90,180),colour="#999999")


samples<-read.table("Fig1a_S1a.input.txt",header=TRUE,sep="\t")
head(samples)
mp1a<-mp + 
  geom_point(data=samples,aes(x = Longitude, y = Latitude, colour = Ecosystem),alpha= 0.7, size = 1)+
  scale_color_manual(values=c("Hadal Ecosystems"="#4575B4",
                                "Hydrothermal Vents"="#D7191C",
                                "Methane Seeps"="#FDAE61",
                                "Other Deep-sea Ecosystems"="#91BFDB"))
mps1a<-mp + 
  geom_point(data=samples,aes(x = Longitude, y = Latitude, colour = SampleType),alpha= 0.7, size = 1)+
  scale_color_manual(values=c("Seawater"="#0D1282",
                              "Sediment"="#FFD460",
                              "Other-Biofilm"="#F67280",
                              "Other-Formation fluids"="#F67280",
                              "Other-Rock"="#F67280"))
pdf("Fig1a.pdf",w=24,h=12)
mp1a
dev.off()
pdf("FigS1a.pdf",w=24,h=12)
mps1a
dev.off()

