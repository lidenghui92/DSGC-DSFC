zgrep "DSM_" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep "Soil_" | grep "OM-RGC" | wc -l  #56200
zgrep "DSM_" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep "Soil_" | grep -v "OM-RGC" | wc -l  #89186
zgrep "DSM_" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep -v "Soil_" | grep  "OM-RGC" | wc -l #19260
zgrep -v "DSM_" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep "Soil_" | grep  "OM-RGC" | wc -l #2838
zgrep "DSM_" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep -v "Soil_" | grep  -v "OM-RGC" | wc -l  #243218
zgrep -v "DSM_" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep "Soil_" | grep  -v "OM-RGC" | wc -l  #297505
zgrep -v "DSM_" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep -v "Soil_" | grep  "OM-RGC" | wc -l  #19890