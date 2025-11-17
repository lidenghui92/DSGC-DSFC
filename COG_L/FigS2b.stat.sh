grep "^DSM_" COG_L.mmseqsGTDB.lca.tsv | wc -l  #all COG-L genes: 25572290
grep "^DSM_" COG_L.mmseqsGTDB.lca.tsv | grep ";p_" | wc -l #COG-L genes annotated with a phylum: 18750769
grep "^DSM_" COG_L.mmseqsGTDB.lca.tsv | grep ";p_" | awk -F";" '{print $2}' | sort | uniq -c | sed 's/^\s\+//g'| sed 's/\s\+p_/\tp_/g' | awk -F"\t" '{print $2"\t"$1}' >DS_COG_L_phyla.stat  # DSGC: 18750769 genes in 204 phyla: 91915.53 genes/phylum
grep "^Soil_" COG_L.mmseqsGTDB.lca.tsv | wc -l #all COG-L genes: 8031727
grep "^Soil_" COG_L.mmseqsGTDB.lca.tsv | grep ";p_" | wc -l #COG-L genes annotated with a phylum: 6577105
grep "^Soil_" COG_L.mmseqsGTDB.lca.tsv | grep ";p_" | awk -F";" '{print $2}' | sort | uniq -c | sed 's/^\s\+//g'| sed 's/\s\+p_/\tp_/g' | awk -F"\t" '{print $2"\t"$1}' >Soil_COG_L_phyla.stat  #TSGC:6577105 genes in 192 phyla: 34255.76 genes/phylum
grep "^OM-RGC.v2" COG_L.mmseqsGTDB.lca.tsv | wc -l #all COG-L genes: 1859135
grep "^OM-RGC.v2" COG_L.mmseqsGTDB.lca.tsv | grep ";p_" | wc -l #COG-L genes annotated with a phylum: 1584216
grep "^OM-RGC.v2" COG_L.mmseqsGTDB.lca.tsv | grep ";p_" | awk -F";" '{print $2}' | sort | uniq -c | sed 's/^\s\+//g'| sed 's/\s\+p_/\tp_/g' | awk -F"\t" '{print $2"\t"$1}' >OM_COG_L_phyla.stat   #OM-RGC:1584216 genes in 176 phyla: 9001.23 genes/phylum