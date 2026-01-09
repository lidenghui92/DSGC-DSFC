#This script is used to generate the data in Table S3
#Key intermediate fils can be found in tableS3_intermediate.tgz
#Taxonomic annotation of all genes in DSGC, OM-RGC, and TSGC
cat DSGC.fa OM-RGC.fa TSGC.fa > DS_OM_TS.fa
seqkit split2 -s 10000000 DS_OM_TS.fa
mmseqs easy-taxonomy DS_OM_TS.part_001.fa /disks/node3_120TB/home/guoyang/software/db_mmseqs_gtdb/GTDB DS_OM_TS.part_001 DS_OM_TS.part_001.fa.tmp --taxage 1 --threads 32
#This command can generate a lca file: DS_OM_TS.part_001_lca.tsv
head -5 DS_OM_TS.part_001_lca.tsv
#DSM_0005934658  3030    family  UBA3495 d_Bacteria;p_Chloroflexota;c_Dehalococcoidia;o_UBA3495;f_UBA3495
#DSM_0005934684  17512   species Ga0077530 sp900117415   d_Bacteria;p_Pseudomonadota;c_Alphaproteobacteria;o_Rhizobiales;f_Hyphomicrobiaceae;g_Ga0077530;s_Ga0077530 sp900117415
#DSM_0005934698  93511   species UBA1096 sp913050205     d_Bacteria;p_Verrucomicrobiota;c_Verrucomicrobiia;o_Limisphaerales;f_UBA1096;g_UBA1096;s_UBA1096 sp913050205
#DSM_0005934701  114786  species JBCCFW01 sp039029535    d_Bacteria;p_Acidobacteriota;c_JBCCFW01;o_JBCCFW01;f_JBCCFW01;g_JBCCFW01;s_JBCCFW01 sp039029535
#DSM_0005934725  2327    genus   Ekhidna d_Bacteria;p_Bacteroidota;c_Bacteroidia;o_Cytophagales;f_Cyclobacteriaceae;g_Ekhidna
awk -F"\t" '{print $1"\t"$5}' DS_OM_TS.part_*_lca.tsv > all.lca.tsv
#Counting genes in annotated phyla (or orders) in each catalog 
awk '/^DSM_/' all_lca.tsv |perl -e 'while(<STDIN>){chomp;($g,$t)=split(/\t/,$_);if($t=~/;/){($d,$p)=split(/;/,$t);$dp=join(";",$d,$p);$c{$dp}+=1;}else{$c{"UNK"}+=1;}}foreach(keys%c){print "$_\t$c{$_}\n";}' > DS_ALL_phylum.stat
awk '/^DSM_/' all_lca.tsv |perl -e 'while(<STDIN>){chomp;($g,$t)=split(/\t/,$_);@tc=split(/;/,$t);$len=@tc;if($len>3){$o=join(";",$tc[0],$tc[1],$tc[2],$tc[3]);$c{$o}+=1;}else{$c{"UNK"}+=1;}}foreach(keys%c){print "$_\t$c{$_}\n";}' > DS_ALL_order.stat
awk '/^OM-RGC\.v2\./' all_lca.tsv |perl -e 'while(<STDIN>){chomp;($g,$t)=split(/\t/,$_);if($t=~/;/){($d,$p)=split(/;/,$t);$dp=join(";",$d,$p);$c{$dp}+=1;}else{$c{"UNK"}+=1;}}foreach(keys%c){print "$_\t$c{$_}\n";}' > OM_ALL_phylum.stat
awk '/^OM-RGC\.v2\./' all_lca.tsv |perl -e 'while(<STDIN>){chomp;($g,$t)=split(/\t/,$_);@tc=split(/;/,$t);$len=@tc;if($len>3){$o=join(";",$tc[0],$tc[1],$tc[2],$tc[3]);$c{$o}+=1;}else{$c{"UNK"}+=1;}}foreach(keys%c){print "$_\t$c{$_}\n";}' > OM_ALL_order.stat
awk '$1!~/^DSM_/ && $1!~/^OM-RGC\.v2\./' all_lca.tsv |perl -e 'while(<STDIN>){chomp;($g,$t)=split(/\t/,$_);if($t=~/;/){($d,$p)=split(/;/,$t);$dp=join(";",$d,$p);$c{$dp}+=1;}else{$c{"UNK"}+=1;}}foreach(keys%c){print "$_\t$c{$_}\n";}' > TS_ALL_phylum.stat
awk '$1!~/^DSM_/ && $1!~/^OM-RGC\.v2\./' all_lca.tsv |perl -e 'while(<STDIN>){chomp;($g,$t)=split(/\t/,$_);@tc=split(/;/,$t);$len=@tc;if($len>3){$o=join(";",$tc[0],$tc[1],$tc[2],$tc[3]);$c{$o}+=1;}else{$c{"UNK"}+=1;}}foreach(keys%c){print "$_\t$c{$_}\n";}' > TS_ALL_order.stat
#Calculate the proportions of annotated phyla (or orders) in each gene catalog
declare -A size=(
    ["DS"]=501998347
    ["TS"]=159907539
    ["OM"]=46775154
)
awk -v total="${size[$1]}" '{a=sprintf("%.4f",$2*100/total);print $1"\t"$2"\t"a}' $1\_ALL_$2.stat |sort -nrk3 > $1\_ALL_$2.total_percent.stat  #where $1 set as DS, TS, or OM. $2 set as phylum or order. 
#Filter the phyla (or order) if it comprised >0.1% (or >0.01%, respectively) of the catalog.
awk -F"\t" '$3>0.1' *_ALL_phylum.total_percent.stat |cut -f1 |sort |uniq -c |awk '$2!~/UNK/ && $1==3{print $2}' > shared_phyla.list
grep d_  *_ALL_phylum.total_percent.stat | sed 's#_ALL_phylum.total_percent.stat:#\t#g' |perl fishInWinter.pl -fc 2 shared_phyla.list -|sort -k2 > percent0.1_ALL_phylum_total_percent.compare.tsv
awk -F"\t" '$3>0.01' *_ALL_order.total_percent.stat |cut -f1 |sort |uniq -c |awk '$2!~/UNK/ && $1==3{print $2}' > shared_orders.list
grep d_  *_ALL_order.total_percent.stat | sed 's#_ALL_order.total_percent.stat:#\t#g' |perl fishInWinter.pl -fc 2 shared_orders.list -|sort -k2 > percent0.01_ALL_order_total_percent.compare.tsv 
#Data in percent0.1_ALL_phylum_total_percent.compare.tsv and percent0.01_ALL_order_total_percent.compare.tsv were summarized in Table S3.
