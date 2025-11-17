#need 2 input files $prefix.pep and $prefix.cds;
#usage: sh Fig2H.muscle2hyphy.sh $prefix
export OMP_NUM_THREADS=2 #threads for FastTreeMP
muscle -super5 $1.pep -output $1.pep.msa -threads 2
#Phylogenetic_diversity_estimate
pal2nal.pl $1.pep.msa $1.cds -output clustal > $1.cds.cstl
grep "DSM" $1.member.list > $1.dsmem.tmp;genometreetk pd --silent $1.cds.tree $1.dsmem.tmp > $1.ds.PG.tsv
grep "OM-RGC" $1.member.list > $1.ommem.tmp;genometreetk pd --silent $1.cds.tree $1.ommem.tmp > $1.om.PG.tsv
grep "Soil" $1.member.list > $1.tsmem.tmp;genometreetk pd --silent $1.cds.tree $1.tsmem.tmp > $1.ts.PG.tsv
#Test of rapid evolution
pal2nal.pl $1.pep.msa $1.cds -output fasta > $1.cds.aln
FastTreeMP -nt $1.cds.aln > $1.cds.tree
hyphy absrel --branches Leaves --alignment $1.cds.aln -tree $1.cds.tree