#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(sum);

open I, "ESM_Memb30_HQ.stat" or die "Could not open file $!";

my %tags;
while (<I>) {
    chomp;
    my @l = split;
    $tags{$l[11]} ||= [];
    push @{$tags{$l[11]}}, $l[0];
}
close I;

my $sample_rate = 0.0002;
my %sample_by_tag;

foreach my $tag (keys %tags) {
    my $count = scalar @{$tags{$tag}};
    my $sample_count = int($count * $sample_rate);
    $sample_by_tag{$tag} = $sample_count;
    print "$sample_count\n";
}

my %sampled;
my $gene;
my $i;

foreach my $tag (keys %tags) {
    for($i=1;$i<=$sample_by_tag{$tag};$i+=1){
        $gene = ${$tags{$tag}}[rand(scalar(@{$tags{$tag}}))];
        if(exists $sampled{$gene}){
            $i-=1;
        }else{
            $sampled{$gene}=$tag;
        }
    }
}
open O,">PC_benchmark.list.tmp";
foreach (keys%sampled){
    print O "$_\t$sampled{$_}\n";
}

system("perl fishInWinter.pl -bf table -ff table PC_benchmark.list.tmp ESM_Memb30_HQ.stat > PC_benchmark.list");
system("perl fishInWinter.pl -bf table -ff table PC_benchmark.list final_20_50_Memb30.comprow_blasta > PC_benchmark.member");
system("cut -f2 PC_benchmark.member|sed 's#,#\\n#g'|perl fishInWinter.pl -bf table -ff fasta - final_20_50_Memb30.mem.fa > PC_benchmark.member.fa")
