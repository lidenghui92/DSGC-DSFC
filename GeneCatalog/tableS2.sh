#10 million sequences were randomly selected, with random seeds (-s) set to 11, 100, 200, 300, and 400 respectively.
seqkit sample --two-pass -s 11 -n 10000000 OM-RGC_v2_geneset_prot.faa -o OM_s11_1000w.fa 
seqkit sample --two-pass -s 11 -n 10000000 Soil_geneset_prot.faa -o TS_s11_1000w.fa
seqkit sample --two-pass -s 11 -n 10000000 Final_DSM_geneset_prot.fa -o DS_s11_1000w.fa

#cluster
cat OM_s11_1000w.fa TS_s11_1000w.fa DS_s11_1000w.fa >all_s11_1000w_prot.fa
/dellfsqd2/ST_OCEAN/USER/lidenghui/software/app/mmseqs/bin/mmseqs easy-cluster all_1000w_prot.fa  final_s11_1000w_0.2_0.5  ./linclust --threads 10 --cov-mode 0 --cluster-mode 0 -c 0.5 --min-seq-id 0.2

#Statistical results
awk '{all[$1]=$2"\t"all[$1]}END{for (i in all){print i"\t"all[i]}}' final_s11_1000w_0.2_0.5_cluster.tsv >g2g_s11_1000w_0.2_0.5.list

grep "DSM_0" g2g_s11_1000w_0.2_0.5.list | grep "Soil_" | grep "OM-RGC.v2" | wc -l     
grep "DSM_0" g2g_s11_1000w_0.2_0.5.list | grep "Soil_" | grep -v "OM-RGC.v2" | wc -l   
grep "DSM_0" g2g_s11_1000w_0.2_0.5.list | grep -v "Soil_" | grep "OM-RGC.v2" | wc -l   
grep -v "DSM_0" g2g_s11_1000w_0.2_0.5.list | grep "Soil_" | grep  "OM-RGC.v2" | wc -l 
grep "DSM_0" g2g_s11_1000w_0.2_0.5.list | grep -v "Soil_" | grep -v "OM-RGC.v2" | wc -l  
grep -v "DSM_0" g2g_s11_1000w_0.2_0.5.list | grep "Soil_" | grep -v "OM-RGC.v2" | wc -l 
grep -v "DSM_0" g2g_s11_1000w_0.2_0.5.list | grep -v "Soil_" | grep "OM-RGC.v2" | wc -l 

#deletion singleton gene
sed 's#\t$##g' g2g_s11_1000w_0.2_0.5.list | awk -F"\t" 'NF>2' >g2g_s11_1000w_0.2_0.5_rmsingle.list

grep "DSM_0" g2g_s11_1000w_0.2_0.5_rmsingle.list | grep "Soil_" | grep "OM-RGC.v2" | wc -l   
grep "DSM_0" g2g_s11_1000w_0.2_0.5_rmsingle.list | grep "Soil_" | grep -v "OM-RGC.v2" | wc -l  
grep "DSM_0" g2g_s11_1000w_0.2_0.5_rmsingle.list | grep -v "Soil_" | grep "OM-RGC.v2" | wc -l  
grep -v "DSM_0" g2g_s11_1000w_0.2_0.5_rmsingle.list | grep "Soil_" | grep  "OM-RGC.v2" | wc -l  
grep "DSM_0" g2g_s11_1000w_0.2_0.5_rmsingle.list | grep -v "Soil_" | grep -v "OM-RGC.v2" | wc -l 
grep -v "DSM_0" g2g_s11_1000w_0.2_0.5_rmsingle.list | grep "Soil_" | grep -v "OM-RGC.v2" | wc -l
grep -v "DSM_0" g2g_s11_1000w_0.2_0.5_rmsingle.list | grep -v "Soil_" | grep "OM-RGC.v2" | wc -l 