#!usr/bin/perl
#This script was embedded in Fig3de.zip, and the output file was provided in Fig3de.zip at Zenodo
open S,"prediction_results.txt";
while(<S>){
    chomp;
    my @l=split;
    if(/#/){
        next;
    }
    $s{$l[0]}=$l[1];
}
close S;

open T,"all.member.tmHMM.tsv";
open O,">protein_location.tsv";
print O "ID\tSignalP\tTransMemb\tLen\tExpAA\tFirst60\n";
while(<T>){
    my $x=0;
    my $tm=my $sum="";
    chomp;
    my @l=split;
    $l[1]=~s/len=//;
    $l[2]=~s/ExpAA=//;
    $l[3]=~s/First60=//;
    $l[4]=~s/PredHel=//;
    if($l[5]=~/Topology=[io]\d+-(\d+)[io]$/){   #the end of the only PredHel region
        $x=$1;
    }
    if($l[4]==0){    #non-transmembrane: protein without PredHel region
        $tm="non";
    }elsif($l[4]==1 && $x<=60){    #probable signal pep: the only one PredHel region falls within first 60AA
        $tm="prb";
    }elsif($l[3]>=18){    #transmembrane: ExpAA is greater than 18 aa, thus the protein contains transmembrane region
        $tm="tm";
    }else{
        $tm="non";
    }
    if($tm=~/non/ && $s{$l[0]}=~/OTHER/){
        $sum="Plasmatic";
    }elsif($tm=~/prb/ && $s{$l[0]}=~/OTHER/){
        $sum="Transmembrane";
    }elsif($tm=~/tm/ && $s{$l[0]}=~/OTHER/){
        $sum="Transmembrane";
    }elsif($tm=~/non/ && $s{$l[0]}!~/OTHER/){
        $sum="Secretory";
    }elsif($tm=~/prb/ && $s{$l[0]}!~/OTHER/){
        $sum="Secretory";
    }elsif($tm=~/tm/ && $s{$l[0]}!~/OTHER/){
        $sum="Transmembrane";
    }else{
        print "error: check output of $l[0]\n";
    }
    print O "$l[0]\t$sum\t$s{$l[0]}\t$tm\t$l[1]\t$l[2]\t$l[3]\t$l[4]\t$x\n";
}
close T;
close O;
