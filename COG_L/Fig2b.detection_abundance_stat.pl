#!usr/bin/perl;

open I,"$ARGV[0]"; #input_file: the abundance matrix of COG-L gene clusters
open O,">Fig.2b.cluster_dtc_adb.stat.tsv";

my $rt=$aab=$cnt=$abd=0;
my $i=0;
my $ds=2138;
while(<I>){
    chomp;
    $cnt=$abd=0;
    my @l=split;
    $i+=1;
    if($i==1){
        print O "GeneCluster\tdetection_rate\tdetection\tavg_abundance\n";
    }else{
        for(my $nf=1;$nf<=@l;$nf+=1){
            if($l[$nf] > 0){
                $cnt+=1;  #detection_counts
                $abd+=$l[$nf];  #total_abundance
            }
        }
        $rt=sprintf "%.2f",$cnt/$ds*100;  #RaTio of samples which detected among all samples
        $aab=averg($abd,$cnt);  # Average_ABundance of gene among all NON-ZERO samples
        print O "$l[0]\t$rt\t$cnt\t$aab\n";
    }
}
sub averg{
    my $t=@_[0];
    my $s=@_[1];
    if($s==0){
        $a=0;
    }else{
        $a=sprintf "%.2f",$t/$s;
    }
    return $a;
}
