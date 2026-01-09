####DSGC, TSGC and OM-RGC clustering

cat Final_DSM_geneset_prot.fa OM-RGC_v2_geneset_prot.fa Soil_geneset_prot.fa >all.prot.fa
mmseqs easy-cluster all.prot.faa  final_20_50  ./temp --threads 40 --cov-mode 0 --cluster-mode 0 -c 0.5 --min-seq-id 0.2
awk '{all[$1]=all[$1]","$2;}END{for (i in all){print i"\t"all[i]}}' final_20_50_cluster.tsv | sed 's/,//' >DS_TS_OM_20id_cluster_stat.list

###Relevant statistical results for Fig 1F
grep "DSM_0" DS_TS_OM_20id_cluster_stat.list | grep "Soil_" | grep "OM-RGC.v2" | wc -l        ####1226110
grep "DSM_0" DS_TS_OM_20id_cluster_stat.list | grep "Soil_" | grep -v "OM-RGC.v2" | wc -l     ####2359451
grep "DSM_0" DS_TS_OM_20id_cluster_stat.list | grep -v "Soil_" | grep  "OM-RGC.v2" | wc -l    ####1467212
grep -v "DSM_0" DS_TS_OM_20id_cluster_stat.list | grep "Soil_" | grep  "OM-RGC.v2" | wc -l    ####51245
grep "DSM_0" DS_TS_OM_20id_cluster_stat.list | grep -v "Soil_" | grep  -v "OM-RGC.v2" | wc -l ####58105982
grep -v "DSM_0" DS_TS_OM_20id_cluster_stat.list | grep "Soil_" | grep  -v "OM-RGC.v2" | wc -l ####17964801
grep -v "DSM_0" DS_TS_OM_20id_cluster_stat.list | grep -v "Soil_" | grep  "OM-RGC.v2" | wc -l ####2707314
###Relevant statistical results for Fig S1e
grep "," DS_TS_OM_20id_cluster_stat.list | grep "DSM_0" |  grep -v "Soil_" |  grep  -v "OM-RGC.v2" | wc -l   ###17811094
grep "," DS_TS_OM_20id_cluster_stat.list | grep "Soil_" | grep -v "DSM_0" |  grep  -v "OM-RGC.v2" | wc -l    ###3841389
grep "," DS_TS_OM_20id_cluster_stat.list | grep "OM-RGC.v2" |  grep -v "Soil_" | grep -v "DSM_0" | wc -l     ###688319

####DSGC and GOGC clustering
cat Final_DSM_geneset_prot.fa  GOGC_geneset_prot.fa >DSGC_GOMC.prot.fa
mmseqs easy-cluster DSGC_GOMC.prot.fa  DS_GO_20_50  ./temp1 --threads 40 --cov-mode 0 --cluster-mode 0 -c 0.5 --min-seq-id 0.2

###Relevant statistical results for Fig 1G
grep "DSM_" DS_GO_20id_cluster_stat.list | grep "Ocean" | wc -l     ####8579765
grep -v "Ocean" DS_GO_20id_cluster_stat.list | wc -l                ####54551577
grep -v "DSM_" DS_GO_20id_cluster_stat.list | wc -l                 ####49141285

grep -v "Ocean" DS_GO_20id_cluster_stat.list | awk '{for(i=2;i<=NF;i++){print $i}}' | wc -l  ####157133253



