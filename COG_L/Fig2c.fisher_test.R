args=commandArgs(T)
mydata <- read.table(paste(args[1],"_COG-L.stat",sep=""),header=F,sep="\t")
        
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
    p = fisher.test(matrix(c(data[value,2],data[value,3],data[value,4],data[value,5]),2,2),alternative='greater')$p.value
    COG = append(COG,value)
    P = append(P,p)
    fg = append(fg,data[value,2])
    fgn = append(fgn,data[value,3])
    bg = append(bg,data[value,4])
    bgn = append(bgn,data[value,5])
    total = append(total,data[value,1])
    fgrate = append(fgrate,data[value,6])
}
Padj <- p.adjust(P,"BH")

COG <- unlist(strsplit(as.character(COG),split=" "))

mx <- data.frame(COG_id=COG,
                 Fg=fg,
                 FgN=fgn,
                 Bg=bg,
                 BgN=bgn,
                 Total=total,
                 Fg_Rate=fgrate,
                 P_value=P,
                 P_adjust=Padj
 
                )

mx_sort <- mx[order(mx$P_adjust),]
write.table(mx_sort,file=paste(args[1],"_COG-L.fisher.tsv",sep=""),sep="\t",row.names = F,quote = F)
