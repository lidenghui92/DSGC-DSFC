#!usr/bin/perl
#
open I,"/dellfsqd1/ST_OCEAN/ST_OCEAN/USRS/lidenghui/Project/deep_sea/08.quantified_gene/NGLess/result_change/COGL_all_DS_0205/temp_DS_all.sorted.list";
my $r="na";
my (@l,%e,%ab);

while(<I>){
    chomp;
    @l=split;
    if(exists $e{$l[0]}){
        for($i=1;$i<2139;$i++){
            $ab{$l[0]}{$i}+=$l[$i];
        }
    }else{
        $e{$l[0]}=1;
        for($i=1;$i<2139;$i++){
            $ab{$l[0]}{$i}=$l[$i];
        }
        print "$r";
        for($i=1;$i<2139;$i++){
            print "\t$ab{$r}{$i}";
        }
        print "\n";
        $r=$l[0];
    }
}
print "$r";
for($i=1;$i<2139;$i++){
    print "\t$ab{$r}{$i}";
}
print "\n";
close I;
