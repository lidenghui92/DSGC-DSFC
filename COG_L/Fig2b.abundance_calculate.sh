minimap2 -d COG_L_rep_cds.fa.mm2.idex COG_L_rep_cds.fa #this fasta file is not provided due to its large size, while the resulted abundance file was provided at Zenodo.
minimap2 -ax sr -t 20 COG_L_rep_cds.fa.mm2.idex example1_1.fq.gz example1_2.fq.gz  | samtools view -bS - > example1.bam
ngless -j 3 --strict-threads deep-sea_map_single.ngl example1

awk 'NR==FNR{if(NR>2){all[$1]=$2;sum+=$2}next}{if ($1 in all){new=all[$1]/sum*1000000;printf "%.2f\n",new}else{print "0"}}' ./raw_count/allbest.out.example1.dist1.txt COG_L_rep_gene.sort.list >./example1.dist1.txt
paste COG_L_rep_gene.sort.list example1.dist1.txt example2.dist1.txt example3.dist1.txt ... exampleX.dist1.txt >temp.list
awk 'NR==FNR{all[$2]=$1;next}{if($1 in all){print all[$1]"\t"$0}}' COG_L_rep_cds.list2cluster.list.change.v2 temp.list | awk 'BEGIN{OFS="\t"}{$2=null;print $0}'| sed 's/\t\+/\t/g' >temp_v2.list
awk 'all[$1]++{print $1}' COG_L_rep_cds.list2cluster.list.change.v2 | awk '!all[$1]++' >need_merge_DSM.list
awk 'NR==FNR{all[$1]=1;next}{if(!($1 in all)){print $0}}' need_merge_DSM.list COG_L_rep_cds.list2cluster.list.change.v2 >single_DSM.list
awk 'NR==FNR{all[$1]=1;next}{if ($1 in all){print $0}}' single_DSM.list temp_v2.list >temp_v2_single.list
awk 'NR==FNR{all[$1]=1;next}{if ($1 in all){print $0}}' need_merge_DSM.list temp_v2.list >temp_v2_merge.list
python merge_kegg.py temp_v2_merge.list >temp_v2_merge.change.py.list
awk '{printf $1"\t";for (i=2;i<=NF;i++){if($i!="0.0"){printf "%.2f\t",$i}else{printf "0\t"}}print ""}' temp_v2_merge.change.py.list | sed 's/\t$//g' >temp_v2_merge.change.py.list.v2

cat ../title.list temp_v2_single.list temp_v2_merge.change.py.list.v2 > COG_L_abundance.matrix
