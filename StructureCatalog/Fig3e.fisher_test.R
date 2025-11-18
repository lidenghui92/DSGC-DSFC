args=commandArgs(T)
mydata <- read.table(paste(args[1],".fisherIn.tsv",sep=""),header=F,sep="\t")
        
data = NULL
data <- as.matrix(mydata[,2:length(mydata)])
rownames(data)<-unlist(mydata[,1]) 
value = ""
mx= NULL

COG=c()
P=c()
Padj=c()
fg=c()
bg=c()
fgn=c()
bgn=total=fgrate=c()

for (value in c(rownames(data))){
    p = fisher.test(matrix(c(data[value,1],data[value,2],data[value,3],data[value,4]),2,2),alternative='greater')$p.value
    COG = append(COG,value)
    P = append(P,p)
    fg = append(fg,data[value,1])
    fgn = append(fgn,data[value,2])
    bg = append(bg,data[value,3])
    bgn = append(bgn,data[value,4])
}
Padj <- p.adjust(P,"BH")

COG <- unlist(strsplit(as.character(COG),split=" "))

mx <- data.frame(COG_id=COG,
                 Fg=fg,
                 FgN=fgn,
                 Bg=bg,
                 BgN=bgn,
                 P_value=P,
                 P_adjust=Padj
                )

mx_sort <- mx[order(mx$P_adjust),]
write.table(mx_sort,file=paste(args[1],".fisherOut.tsv",sep=""),sep="\t",row.names = F,quote = F)
