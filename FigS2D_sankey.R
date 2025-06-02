library(tidyverse)
library(viridis)
library(patchwork)
library(networkD3)
library(webshot)

data_long <- read.table("sankey.csv", header=T, sep = ",")
nodes <- data.frame(name=c(as.character(data_long$source), as.character(data_long$target)) %>% unique())#制作nodes
head(nodes)
data_long$IDsource=match(data_long$source, nodes$name)-1 
data_long$IDtarget=match(data_long$target, nodes$name)-1
ColourScal='d3.scaleOrdinal() .range(["#F7FBFF", "#DEEBF7", "#C6DBEF", "#9ECAE1" ,"#6BAED6", "#4292C6" ,"#2171B5" ,"#084594"])'
p<-sankeyNetwork(Links = data_long, Nodes = nodes,
              Source = "IDsource", Target = "IDtarget",
              Value = "Value", NodeID = "name", 
              sinksRight=FALSE, colourScale=ColourScal, nodeWidth=10, fontSize=13, nodePadding=20)
saveNetwork(p,"sankey.html")
webshot("sankey.html","sankey.pdf")