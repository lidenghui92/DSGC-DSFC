#####need 2 input files: $prefix.pep and $prefix.cds; $cpu should better >= 8; usage sh tree2hyphy.sh $prefix $cpu
export OMP_NUM_THREADS=2 #threads for FastTreeMP
cd $1
muscle -super5 $1.pep -output $1.pep.msa -threads 2
pal2nal.pl $1.pep.msa $1.cds -output fasta > $1.cds.aln
pal2nal.pl $1.pep.msa $1.cds -output clustal > $1.cds.cstl
FastTreeMP -nt $1.cds.aln > $1.cds.tree
grep "DSM" $1.member.list > $1.dsmem.tmp;genometreetk pd --silent $1.cds.tree $1.dsmem.tmp > $1.ds.PG.tsv
grep "OM-RGC" $1.member.list > $1.ommem.tmp;genometreetk pd --silent $1.cds.tree $1.ommem.tmp > $1.om.PG.tsv
grep "Soil" $1.member.list > $1.tsmem.tmp;genometreetk pd --silent $1.cds.tree $1.tsmem.tmp > $1.ts.PG.tsv
hyphy absrel --branches Leaves --alignment $1.cds.aln -tree $1.cds.tree CPU=2 > $1.cds.json
