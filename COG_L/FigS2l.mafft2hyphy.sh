#need 2 input files $prefix.pep and $prefix.cds;
#these input files is extracted from DS.TS.OM.all.COG_L.pep.gz and Fig2.all.unigen_for_hyphy.cds.gz, respectively, based on the clustering relationships in Fig2.5837clusters_for_hyphy.tsv.gz
#usage: sh FigS2l.mafft2hyphy.sh $prefix
#example usage: FigS2l.mafft2hyphy.sh DSM_0100156101
#Output files of the example (DSM_0100156101) can be found in Fig2h_S2l.HyPhy_example_output.zip
linsi --thread 5 $1.pep > $1.pep.msa
pal2nal.pl $1.pep.msa $1.cds -output fasta > $1.cds.aln
trimal -in $1.cds.aln -out $1.trimed.cds.aln -gappyout
iqtree3 -s $1.trimed.cds.aln --seqtype CODON -m MFP --threads-max 5 -T AUTO
hyphy absrel --branches Leaves --alignment $1.trimed.cds.aln -tree $1.trimed.cds.aln.treefile CPU=2
