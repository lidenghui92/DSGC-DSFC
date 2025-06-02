#!/usr/bin/perl

open I,"all.psg.out";

my ($ta,$tr,%da,%dr,%sa,%sr,%oa,%or);
while(<I>){
    chomp;
    my @l=split;
    $l[0]=~s/.cds.aln.ABSREL.json//;
    $ta{$l[0]}+=1;
    if($l[1]=~/DSM_/){
        $da{$l[0]}+=1;
        if($l[2]=~/REG/){
            $dr{$l[0]}+=1;
        }
    }elsif($l[1]=~/Soil_/){
        $sa{$l[0]}+=1;
        if($l[2]=~/REG/){
            $sr{$l[0]}+=1;
        }
    }elsif($l[1]=~/OM_/){
        $oa{$l[0]}+=1;
        if($l[2]=~/REG/){
            $or{$l[0]}+=1;
        }
    }
}
close I;

open O,">hyphy_stat2.tsv";
print O "Cluster\tREG_rate_DS\tREG_rate_TS\tREG_rate_OM\tREG_DS\tALL_DS\tREG_TS\tALL_TS\tREG_OM\tALL_OM\n";
foreach(keys%ta){
    my $d=$t=$s=$o="na";
    if(!exists $dr{$_}){$dr{$_}=0;}
    if(!exists $or{$_}){$or{$_}=0;}
    if(!exists $sr{$_}){$sr{$_}=0;}
    if($da{$_}>0){$d=sprintf"%.4f",$dr{$_}/$da{$_};}else{$d="na";}
    if($sa{$_}>0){$s=sprintf"%.4f",$sr{$_}/$sa{$_};}else{$s="na";}
    if($oa{$_}>0){$o=sprintf"%.4f",$or{$_}/$oa{$_};}else{$o="na";}
    print O "$_\t$d\t$s\t$o\t$dr{$_}\t$da{$_}\t$sr{$_}\t$sa{$_}\t$or{$_}\t$oa{$_}\n";
}
close O;
