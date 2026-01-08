#this file is not used. see FigS2l.mafft2hyphy.sh

#need 2 input files $prefix.pep and $prefix.cds
#Usage: sh mafft2hyphy.sh $prefix
linsi --thread 5 $1.pep > $1.pep.msa
pal2nal.pl $1.pep.msa $1.cds -output fasta > $1.cds.aln
trimal -in $1.cds.aln -out $1.trimed.cds.aln -gappyout
iqtree3 -s $1.trimed.cds.aln --seqtype CODON -m MFP --threads-max 5 -T AUTO
hyphy absrel --branches Leaves --alignment $1.trimed.cds.aln -tree $1.trimed.cds.aln.treefile > $1.cds.log
