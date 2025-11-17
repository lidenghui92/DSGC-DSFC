####DSGC, TSGC and OM-RGC clustering

cat Final_DSM_geneset_prot.fa OM-RGC_v2_geneset_prot.fa Soil_geneset_prot.fa >all.prot.fa
mmseqs easy-cluster all.prot.faa  final_20_50  ./temp --threads 40 --cov-mode 0 --cluster-mode 0 -c 0.5 --min-seq-id 0.2
awk '{all[$1]=all[$1]","$2;}END{for (i in all){print i"\t"all[i]}}' final_20_50_cluster.tsv | sed 's/,//' >final_20_50_g2g.list

###Relevant statistical results for Fig 1F
grep "DSM_" final_20_50_g2g.list | grep "Soil_" | grep "OM-RGC" | wc -l        ####1226961
grep "DSM_" final_20_50_g2g.list | grep "Soil_" | grep -v "OM-RGC" | wc -l     ####2358664
grep "DSM_" final_20_50_g2g.list | grep -v "Soil_" | grep  "OM-RGC" | wc -l    ####1467212
grep -v "DSM_" final_20_50_g2g.list | grep "Soil_" | grep  "OM-RGC" | wc -l    ####56519
grep "DSM_" final_20_50_g2g.list | grep -v "Soil_" | grep  -v "OM-RGC" | wc -l ####58105982
grep -v "DSM_" final_20_50_g2g.list | grep "Soil_" | grep  -v "OM-RGC" | wc -l ####17959463
grep -v "DSM_" final_20_50_g2g.list | grep -v "Soil_" | grep  "OM-RGC" | wc -l ####2707314
###Relevant statistical results for Fig S1F
grep "," final_20_50_g2g.list | grep "DSM_" |  grep -v "Soil_" |  grep  -v "OM-RGC" | wc -l   ###17811094
grep "," final_20_50_g2g.list | grep "Soil_" | grep -v "DSM_" |  grep  -v "OM-RGC" | wc -l    ###3840346
grep "," final_20_50_g2g.list | grep "OM-RGC" |  grep -v "Soil_" | grep -v "DSM_" | wc -l     ###688319

####DSGC and GOGC clustering
cat Final_DSM_geneset_prot.fa  GOGC_geneset_prot.fa >DSGC_GOMC.prot.fa
mmseqs easy-cluster DSGC_GOMC.prot.fa  DS_GO_20_50  ./temp1 --threads 40 --cov-mode 0 --cluster-mode 0 -c 0.5 --min-seq-id 0.2

###Relevant statistical results for Fig 1G
grep "DSM_" DS_GO_20_50_g2g.list | grep "Ocean" | wc -l     ####8579765
grep -v "Ocean" DS_GO_20_50_g2g.list | wc -l                ####54551577
grep -v "DSM_" DS_GO_20_50_g2g.list | wc -l                 ####49141285
grep -v "Ocean" DS_GO_20_50_g2g.list | awk '{for(i=2;i<=NF;i++){print $i}}' | wc -l  ####157133253