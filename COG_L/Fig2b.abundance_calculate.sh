minimap2 -d COG_L_rep_cds.fa.mm2.idex COG_L_rep_cds.fa #this fasta file is not provided due to its large size, while the resulted abundance file was provided at Zenodo.
minimap2 -ax sr -t 20 COG_L_rep_cds.fa.mm2.idex example1_1.fq.gz example1_2.fq.gz  | samtools view -bS - > example1.bam
ngless -j 3 --strict-threads deep-sea_map_single.ngl example1

#Calculating of the abundances of gene clusters
awk 'NR==FNR{if(NR>2){all[$1]=$2;sum+=$2}next}{if ($1 in all){new=all[$1]/sum*1000000;printf "%.2f\n",new}else{print "0"}}' ./raw_count/allbest.out.example1.dist1.txt COG_L_rep_gene.sort.list >./example1.dist1.txt
paste COG_L_rep_gene.sort.list example1.dist1.txt example2.dist1.txt example3.dist1.txt ... exampleX.dist1.txt >COG_L_abundance.matrix.tmp
awk 'NR==FNR{all[$2]=$1;next}{if($1 in all){print all[$1]"\t"$0}}' gene2gene_0.2_0.5.all_DS_change.list COG_L_abundance.matrix.tmp | awk 'BEGIN{OFS="\t"}{$2=null;print $0}'| sed 's/\t\+/\t/g' >temp_DS_all.list 
sort -k1nr,1 temp_DS_all.list >temp_DS_all.sorted.list 
perl Fig2b.merge_abundance_by_cluster.pl >temp_DS_all.sorted.perl.list
sed -i '1d' temp_DS_all.sorted.perl.list
cat title.list temp_DS_all.sorted.perl.list >Fig2.COG_L_PC_abundance.matrix  #The final file has been uploaded to Zenodo
