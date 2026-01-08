##usage sh COG_annotation_by_PC.sh prefix path_to_emapper.annotations.gz, where,
##the "prefix" set as "OM-RGC", "TSGC", and "DSGC" for the three catalog, respectively.
##the "emapper.annotations.gz" represents the files uploaded to Zenodo, such as "OM-RGC_emapper_COG.xls.gz", "TSGC_emapper_COG.xls.gz", and "DSGC_emapper_COG.xls.gz".
##extract lines with an annotation of L category
zcat $2 |awk -F"\t" '$5~/L/' > $1_COG-L.emapper 

##output gene2COG tables
perl -e 'open I,"'$1'_COG-L.emapper";while(<I>){chomp;@l=split(/\t/,$_);@cog=split(/,/,$l[3]);$i=0;foreach(@cog){if($_=~/COG/){print "$l[0]\t$_\n";}}}' > $1_gene2COG.tsv

##output the COG description with preference to the description of bacteria(2)/archaea(2157) instead of root(1)
##the file "e5.og_annotations_COGonly.tsv" is downloaded from the eggNOG website, and only the record of COG or arCOG kept.
perl -e 'open E,"e5.og_annotations_COGonly.tsv";while(<E>){chomp;@l=split(/\t/,$_);$cog=join("\@",$l[1],$l[0]);$ct{$cog}=$l[3];}open I,"'$1'_gene2COG.tsv";while(<I>){@l=split;@ta=split(/\@/,$l[1]);$uid=join("_",$l[0],$ta[0]);if($g{$l[0]}{$ta[0]}<$ta[1]){$lin{$uid}=join("\t",$l[0],$ta[0],$l[1],$l[2],$ct{$l[1]});}$g{$l[0]}{$ta[0]}=$ta[1];}foreach(keys%lin){print "$lin{$_}\n";}' |sort > $1_gene2uniqCOG.tsv

##note:run the script below line-by-line

cat *_gene2uniqCOG.tsv > all_gene2COG.tsv

zcat ../93.hyphy/0.data_preparing/Fig2.COG_L_DS.TS.OM_cluster.row.gz | /share/app/perl-5.24.1/bin/perl -e 'open I,"Soil_geneset_id.changeL.list";while(<I>){chomp;($old,$new)=split;$id{$old}=$new;}while(<STDIN>){chomp;@l=split;@g=split(/,/,$l[1]);if(exists $id{$l[0]}){print "$id{$l[0]}\t"}else{print "$l[0]\t"};foreach(@g){if(exists $id{$_}){print "$id{$_},"}else{print "$_,"}}print "\n"}' | sed 's#,$##g' > COG_L_PC.member-uid.row  #this command would require a large memory, or one can first generate a subset of Soil_geneset_id.changeL.list with only the TSGC genes included in all_gene2COG.tsv.

perl -e 'open C,"all_gene2COG.tsv";while(<C>){@l=split;$c{$l[0]}=$l[1];}open I,"COG_L_PC.member-uid.row";while(<I>){chomp;@l=split;@g=split(/,/,$l[1]);$x=0;print "$l[0]\t";foreach(@g){$x+=1;if(exists $c{$_}){print "$c{$_},";}else{print "NA,";}}print "\t$x\n";}' |sed 's#,\t#\t#g' > COG_L_PC.memberCOG.row

perl -e 'open I,"COG_L_PC.memberCOG.row";while(<I>){chomp;@l=split;$c{$l[0]}=$l[2];@OG=split(/,/,$l[1]);foreach $og (@OG){if(exists $t{$l[0]}{$og}){$t{$l[0]}{$og}+=1;}else{$t{$l[0]}{$og}=1;}}}foreach $k (keys %t){print "\n$k\t$c{$k}";foreach $ks (sort{$t{$k}{$b} <=>$t{$k}{$a}} keys %{$t{$k}}){$r{$k}{$ks}=$t{$k}{$ks}/$c{$k}*100;print "\t$ks,$t{$k}{$ks},$r{$k}{$ks}%";}}' > COG_L_PC.memberCOG.stat  #this output file is provided

perl -e 'open C,"COG_L_PC.memberCOG.stat";while(<C>){@l=split;@m=split(/,/,$l[2]);$c{$l[0]}=$m[0];}open I,"COG_L_PC.member-uid.row";while(<I>){chomp;@l=split;@g=split(/,/,$l[1]);foreach(@g){print "$_\t$c{$l[0]}\n";}}' > COG_anno_by_PC.tsv

fish -bf table -ff table COG_L_PC.member-uid.row COG_anno_by_PC.tsv > rep_COG_anno_by_PC.tsv  #this output file is provided

##note:Statistics of functional consistency within clusters
sed 's#,#\t#g' COG_L_PC.memberCOG.stat |sed 's#%##g'|awk -F "\t" '{if($5>=90){a+=1;}if($5>=50){b+=1;}c+=1;}END{print "over 90% members have same COG term in "a" clusters\nover 50% members have same COG term in ",b,"clusters\nIn total ",c," clusters"}'
