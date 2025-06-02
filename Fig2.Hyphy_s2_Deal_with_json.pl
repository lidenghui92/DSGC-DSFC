#!/usr/bin/perl

use strict;
use JSON;
my $json_data;
{
    local $/;
    open my $fh, '<', "$ARGV[0]" or die "Cannot open file $!";
    $json_data = <$fh>;
    close $fh;
}

my $data = decode_json($json_data);

my $result= $data->{'branch attributes'}{'0'};

open O, ">>all.psg.out";
for my $gid (sort keys %{$result}) {
    my $padj = $result->{$gid}->{'Corrected P-value'};
    my @path = split(/\//,$ARGV[0]);
    my $fid = pop(@path);
    if($gid!~/Node\d+/){
        if($padj<0.05){
            print O "$fid\t$gid\tREG\t$padj\n";
        }else{
            print O "$fid\t$gid\tNS\t$padj\n";
        }
    }
}
close O;
