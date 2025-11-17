#Usage:sh Fig2c.fisher.sh number_of_COG-L_genes_in_excl-DS-clusters(1363058) number_of_all_COG-L_genes_in_DSGC(24294500)
#For each COG term, count the numbers of all genes (%c in the perl command), genes in exclusive clusters (%uc) and shared clusters (%sc).
#Input file1 DS_excl-cluster_members.list, contains the gene IDs of all genes in excl-DS-clusters.
#Input file2 DS_gene2uniqCOG.list contains the COG terms for each DSGC COG-L genes, can be obtained with the following command: grep "^DSM_" COG_anno_by_PC.tsv |grep -v NA > DS_gene2uniqCOG.list
perl -e 'open U,"$ARGV[0]";while(<U>){chomp;$u{$_}=1;}open I,"$ARGV[1]";while(<I>){@l=split;$c{$l[1]}+=1;if(exists $u{$l[0]}){$uc{$l[1]}+=1;}else{$sc{$l[1]}+=1;}}foreach(keys%c){print "$_\t$c{$_}\t$uc{$_}\t$sc{$_}\n"}' DS_exclcluster_members.list DS_gene2uniqCOG.list > DS_COG-L.stat2
#calculate data for fisher's exact test
awk -F"\t" '{r=$3/$2;c='$1'-$3;d='$2'-'$1'-$4;print DS"\t"$2"\t"$3"\t"c"\t"$4"\t"d"\t"r}' DS_COG-L.stat2 > DS_COG-L.stat3
awk -F"\t" '{for(i=3;i<=6;i++){if($i==""){$i=0;}}print $0}' DS_COG-L.stat3> DS_COG-L.stat4
sed -i 's# #\t#g' DS_COG-L.stat4
mv DS_COG-L.stat4 DS_COG-L.stat
#run the test
Rscript Fig2c.fisher_test.R DS
rm DS_COG-L.stat2 DS_COG-L.stat3
awk '$NF<0.05' DS_COG-L.fisher.tsv > Fig2c.DS_COG-L.fisher.tsv