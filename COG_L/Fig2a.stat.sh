zgrep "DSM_0" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep "Soil_" | grep "OM-RGC.v2" | wc -l  #56192
zgrep "DSM_0" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep "Soil_" | grep -v "OM-RGC.v2" | wc -l  #89193
zgrep "DSM_0" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep -v "Soil_" | grep  "OM-RGC.v2" | wc -l #19260
zgrep -v "DSM_0" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep "Soil_" | grep  "OM-RGC.v2" | wc -l #2382
zgrep "DSM_0" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep -v "Soil_" | grep  -v "OM-RGC.v2" | wc -l  #243218
zgrep -v "DSM_0" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep "Soil_" | grep  -v "OM-RGC.v2" | wc -l  #297962
zgrep -v "DSM_0" Fig2.COG_L_DS.TS.OM_cluster.row.gz | grep -v "Soil_" | grep  "OM-RGC.v2" | wc -l  #19890
