library(ggplot2)
library(ggpubr)

mydata <- read.csv("input.csv")

my_comp <- list(c("AF2_1", "DS_1"),c("AF2_2", "DS_2"))

pdf("violin.pdf",w = 6.5,h = 6.5)
mydata$Group <- factor(mydata$Group,levels=c("AF2_1","DS_1","AF2_2","DS_2"))
p<-ggplot(mydata,aes(x=Group,y=score,fill = Group))+ 
   geom_violin(aes(fill=Group),color="white",cex=0.1)+ 
   geom_boxplot(width=0.1,position = position_dodge(0.9),color="black")+ 
   theme_classic()+ 
   scale_fill_manual(values = c("#717171","#1D267D","#1B9C3A","#834026","#717171","#1D267D","#1B9C3A","#834026"))+ 
   labs(x=NULL,title =NULL)+ 
   theme(axis.title =element_text(size = 12),axis.text.y =element_text(size = 10, color = 'black'), axis.text.x =element_text(size = 12, color = 'black'))+ stat_compare_means(comparisons=my_comp)+ 
   stat_compare_means(label.y = 1)   
p
dev.off()

