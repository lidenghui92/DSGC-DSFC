#Scirpts for analyses associated with Fig3de
#Intermediate files (Fig3de.zip) have been deposited at Zenodo.

#get taxonomic annotation from gene2tax_7level_LCA_add_gtdb.txt.gz
perl -e 'open I,$ARGV[0];while(<I>){chomp;($r,$m)=split;$ml{$r}=join(",",$m,$ml{$r});}foreach(keys%ml){$ml{$_}=~s/,$//;print "$_\t$ml{$_}\n"}' HQ3D_taxo_cluster.tsv > hqBacAr.cluster.row #in Fig3.foldseek_clusters_taxonomy.zip, this contains 759,874 hiqh-quality structures with taxonomic annotations at phylum-levels.
cat hqBacAr.cluster.row |perl -e 'while(<STDIN>){chomp;@l=split;@g=split(/,/,$l[1]);foreach(@g){print "$_\t$l[0]\n";}}' |FishInWinter.pl -bf table -ff table - gene2tax_7level_LCA_add_gtdb.txt > hqBacAr.memb.taxon #this file has been deposited at Zenodo.

#Merge clustering relationships with taxonomic annotation
awk -F";" '{sub(/\t/,"\td__",$1);print $1";p__"$2";c__"$3";o__"$4";f__"$5";g__"$6";s__"$7}' hqBacAr.memb.taxon |sed 's#Unclassified##g' > hqBacAr.memb.taxon.gtdbformat
echo -e  "Cluster\tGene\ttaxon" > hqBacAr.memb.taxon.gtdbformat2
cat hqBacAr.cluster.row |perl -e 'while(<STDIN>){chomp;@l=split;@g=split(/,/,$l[1]);foreach(@g){print "$_\t$l[0]\n";}}' |awk -F"\t" '{if(NR==FNR){a[$1]=$2}else{print a[$1]"\t"$1"\t"$2}}' - hqBacAr.memb.taxon.gtdbformat >> hqBacAr.memb.taxon.gtdbformat2
sed -i 's# #_#g' hqBacAr.memb.taxon.gtdbformat2
mv hqBacAr.memb.taxon.gtdbformat2 hqBacAr.memb.taxon.gtdbformat

#Transform GTDB taxonomy to NCBI taxonomy
gtdb2ncbi -i hqBacAr.memb.taxon.gtdbformat -o hqBacAr.memb.taxon.gtdb2ncbi #this script can be found at https://github.com/alienzj/gtdb2ncbi
awk -F";" '{print $1";"$2"\t"$7";"$8}' hqBacAr.memb.taxon.gtdb2ncbi|awk -F"\t" '{print $1"\t"$2"\t"$3"\t"$5}' |sed 's# #_#g' > hqBacAr.memb.taxon.gtdb2ncbi.phylums
sed 's#d__##g' hqBacAr.memb.taxon.gtdb2ncbi.phylums |sed 's#a;p__\t#a;p__Unclassified\t#g' |sed 's#p__##g' |awk '{if(NR==FNR){a[$1]=$3}else{if($3~/Bacteria/ || $3~/Archaea/){print $1"\t"$2"\t"a[$3]}}}' phylums_gtdb.tsv - > hqBaAr.Phylums.tsv  #Rename the name of each phylum based on the NCBI taxonomy (v2024.12, phylums_gtdb.tsv). Both phylums_gtdb.tsv and hqBaAr.Phylums.tsv have been deposited at Zenodo.

#prepare data for Fig. 3d
cat hqBaAr.Phylums.tsv |perl -e 'print "Cluster\tType\tSize\n";
	while(<STDIN>){chomp;@l=split(/\t/,$_);
	$size{$l[0]}+=1;
	@t=split(/;/,$l[2]);$domain=$t[0];$phylum=$l[2];
	if(!exists $c{$l[0]}{$phylum}){$c{$l[0]}{$phylum}=1;$phy{$l[0]}+=1;}
	if(!exists $c{$l[0]}{$domain}){$c{$l[0]}{$domain}=1;$dom{$l[0]}+=1;}}
	foreach (keys%phy){@tax=split(/;/,$_);
		if($dom{$tax[0]}>1){print "$_\tDiff_domains\t$size{$_}\n";}
		elsif($phy{$_}>1){print "$_\tDiff_phylums\t$size{$_}\n";}
		else{print "$_\tSame_phylum\t$size{$_}\n";}}' > hqBaAr.cluster_stat.txt #Data for Fig. 3d, and has been deposited at Zenodo.

awk '{a++;mem_a+=$3;
    if($3==1 && $2~/Same_phylum/){single_sp++;mem_sp+=$3;}
    else if($3!=1){
        if($2~/Same_phylum/){mult_sp++;mem_sp+=$3;}
        else if($2~/Diff_phylums/){dp++; mem_dp+=$3;}
        else {dd++;mem_dd+=$3;}}
	}
END{a--;dd--;
	r_signle=single_sp/a;
	sp=mult_sp+single_sp;
	r_sp=sp/a;
	r_dp=dp/a;
	r_dd=dd/a;
	r_mem_sp=mem_sp/mem_a;
	r_mem_dp=mem_dp/mem_a;
	r_mem_dd=mem_dd/mem_a;

    print "Singleton_clusters\t"single_sp,r_signle;
    print "Cluster_with_members_from_same_Phylum\t"sp,r_sp,"containing members\t"mem_sp,r_mem_sp;
    print "Cluster_with_members_from_different_Phyla\t"dp,r_dp,"containing members\t"mem_dp,r_mem_dp;
    print "Cluster_with_members_from_different_Domains\t"dd,r_dd,"containing members\t"mem_dd,r_mem_dd;
    print "All_clusters\t"a,"containing memebers\t"mem_a;
	}' hqBaAr.cluster_stat.txt > hqBaAr.summary.txt #Data for Fig. 3d, and has been deposited at Zenodo.

#signalp and tmhmm analyses, the fasta file HQ3D_taxo_member.fa has been deposited at Zenodo.
signalp6 --fastafile HQ3D_taxo_member.fa --bsize 10 --organism other --output_dir signalp_local --mode fast --format none
mv signalp_local/prediction_results.txt signalp_prediction_results.txt
tmhmm > HQ3D_taxo_member.fa > tmhmm.HQ3D_taxo_member.tsv
perl tmHMM_signalP.merge.pl #this step generate the protein_location.tsv file, which has been deposited at Zenodo.
perl -e 'open C,"hqBacAr.cluster.row";while(<C>){chomp;@l=split;@g=split(/,/,$l[1]);foreach(@g){$c{$_}=$l[0];}}open P,"hqBaAr.cluster_stat.txt";while(<P>){chomp;@l=split;$t{$l[0]}=$l[1];}open L,"protein_location.tsv";while(<L>){chomp;@l=split;if(exists $c{$l[0]}){print "$l[0]\t$c{$l[0]}\t$t{$c{$l[0]}}\t$l[1]\n"}}' > hqBaAr.Phylums_Locations.stat
cut -f3,4 hqBaAr.Phylums_Locations.stat|sort |uniq -c | awk '{print $3"\t"$2"\t"$1}' > hqBaAr.Phylums_Locations.summary.stat #Data for Fig. 3d, and has been deposited at Zenodo.

#COG category enrichment
zcat Final_DSM_geneset_all.emapper.annotations.gz |FishInWinter -bf table -ff table -bc 2 hqBaAr.Phylums.tsv - > hqBaArPhy.EggNOG.tsv #Final_DSM_geneset_all.emapper.annotations.gz is the orignal emapper result of DSGC, necessary information has been deposited at Zenodo with file name DSGC_emapper_COG.xls.gz. This result file has been deposited at Zenodo.
awk -F"\t" '{print $1"\t"$19}' hqBaArPhy.EggNOG.tsv |perl -e 'while(<STDIN>){chomp;@l=split;@c=split(/,/,$l[1]);print "$l[0]\t";foreach(@c){if(/COG\d+\@1/){print "$_";}}' |sed 's#,$##g'|awk 'NF==2' | sed 's#\@1##g' > hqBaArPhy.COG.tsv #for DSGC_emapper_COG.xls.gz use awk -F"\t" '{print $1"\t"$4}' for same output.
zcat e5.og_annotations_COGonly.tsv.gz |awk '$1==1' |perl -e 'while(<STDIN>){chomp;@l=split;$c{$l[1]}=$l[2];}
open I,"hqBaArPhy.COG.tsv";while(<I>){
	chomp;@l=split;@c=split(/,/,$l[1]);print "$l[0]\t";
	foreach(@c){$out=join(",",split(//,$c{$_}));print "$out,";}
	print "\n";}' |sed 's#,$##g' > hqBaArPhy.category.tsv #e5.og_annotations_COGonly.tsv.gz is generated from "e5.og_annotations.tsv" by filtering COG/arCOG terms, and "e5.og_annotations.tsv" is availible from http://eggnog5.embl.de/download/eggnog_5.0/.
awk '{if(NR==FNR){a[$2]=$1}else{print a[$1]"\t"$0}}' hqBaAr.Phylums.tsv hqBaArPhy.category.tsv |sort > hqBaArPhy.category_clusterid.tsv #this file has been deposited at Zenodo.

grep Diff_domains hqBaAr.cluster_stat.txt | \
perl -e 'while(<STDIN>){@l=split;$d{$l[0]}=1}
    open I,"hqBaArPhy.category_clusterid.tsv";
    while(<I>){chomp;@l=split;%ctg=();
        @c=split(/,/,$l[2]);foreach(@c){$ctg{$_}=1;}
        $tgene+=1;
        foreach(keys%ctg){$tcog{$_}+=1;}
        if(exists $d{$l[0]}){$dgene+=1;foreach(keys%ctg){$dcog{$_}+=1;}}
    }
    foreach(keys%tcog){
        if(!exists $dcog{$_}){$dcog{$_}=0;}
        $bcog=$tcog{$_}-$dcog{$_};
        $fg=$dgene-$dcog{$_};
        $bg=$tgene-$tcog{$_}-$dgene+$dcog{$_};
        print "$_\t$dcog{$_}\t$bcog\t$fg\t$bg\n"}'  > hqBaArPhy.category.fisherIn.tsv #this file has been deposited at Zenodo.

Rscript fisher_test.R hqBaArPhy.category  #this generate hqBaArPhy.category.fisherOut.tsv for Fig. 3e, and has been deposited at Zenodo. The data was transformed before plotting Fig. 3e, for details please refer to hyBaArPhy.category.fisherOut.xlsx, which can also be found at Zenodo.
