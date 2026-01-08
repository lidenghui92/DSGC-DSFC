library(Seurat)
library(dplyr)
library(cowplot)
library(reshape2)

#import files Fig2c.PC_Matrix_enriched.tsv and FigS2d.PC_Matrix_All.tsv for Fig2c and FigS2d, respectively.
#both input files can be generated using the command lines in the ReadMe with other provided files.
#object.data <-read.table(file="Fig2c.PC_Matrix_enriched.tsv",check.names=F)
object.data <-read.table(file="FigS2d.PC_Matrix_All.tsv",check.names=F)
object_name <- CreateSeuratObject(counts = object.data, min.cells = 1, min.features = 1)
object_name <- NormalizeData(object = object_name, normalization.method = "LogNormalize",scale.factor = 10000)
object_name <- FindVariableFeatures(object = object_name, selection.method = "vst", nfeatures = 3000)

# Scaling the data
all.genes <- rownames(x = object_name)
object_name <- ScaleData(object = object_name, features = all.genes)
object_name <- RunPCA(object = object_name, features = VariableFeatures(object = object_name),npcs = 100)

#Cluster the samples
object_name <- FindNeighbors(object = object_name, dims = 1:100)
object_name <- FindClusters(object = object_name, resolution = 0.5)

#Run non-linear dimensional reduction (UMAP/tSNE)
object_name <- RunUMAP(object = object_name, dims = 1:100)
#object_name <- RunTSNE(object = object_name, dims = 1:10)
pdf("FigS2d.PC_Matrix_All.pdf")
DimPlot(object = object_name, reduction = "umap",label=TRUE)
dev.off()

#get_coordinate
cluster_ID=as.data.frame(Idents(object = data))
cluster_cor= as.data.frame(Embeddings(object = data,reduction = "umap"))
res=cbind(cluster_ID,cluster_cor)
#write.table(res,"Fig2c.PC_Matrix_enriched_0.5_coor.txt",sep="\t",quote = FALSE)
write.table(res,"FigS2d.PC_Matrix_All_0.5_coor.txt",sep="\t",quote = FALSE)
