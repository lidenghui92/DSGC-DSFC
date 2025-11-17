#!/usr/bin/perl

local $/ = ">"; 

open I,"<Fig4e.MSA_7294_Pif1like_seqs.mafft";
open O,">Sequence_with_motifIc_II.mafft";
open T,">Pif1_insertion_length.tsv";

my $t_pos=3172;  #the position of the "T" of motif Ic (partial, TXH) in the multiple sequence alignment (MSA).
my $m_pos=3865;  #the position of the "M" of motif II (partial, DEXSM) in the MSA.

while (<I>) {
    next if /^$/; 
    chomp;
    my ($header, @seq_lines) = split(/\n/, $_, 2);
    my $sequence = join('', @seq_lines);

    #Detecting the motif "TXH", most sequences in the MSA exhibited "TX-----H"
    #So we filter the sequences have 5 gaps and 1 [A-Z] between "T" and "H".
    my $txh_found = 0;
    if (substr($sequence, $t_pos - 1, 1) eq 'T' && 
        substr($sequence, $t_pos - 1 + 7, 1) eq 'H') {
            
        my $segment = substr($sequence, $t_pos - 1 + 1, 6);
        my $count = $segment =~ tr/A-Z//;
        if ($count == 1) {
            $txh_found = 1;
        }
    }
    
    #Detecting the motif "DEXSM", most sequences in the MSA exhibited "DEX------S-----M"
    #So we filter the sequences have 6 gaps and 1 [A-Z] between "E" and "S" and 5 gaps between "S" and "M".
    my $dexsm_found = 0;
    if (substr($sequence, $m_pos - 1 - 15, 2) eq 'DE' &&
        substr($sequence, $m_pos - 1 - 6, 7) eq 'S-----M'){

        my $segment = substr($sequence, $m_pos - 1 - 15 + 2, 7);
        my $count = $segment =~ tr/A-Z//;
        if ($count == 1) {
            $dexsm_found = 1;
        }
    }
    #filtering sequences with both motifIc and motifII 
    if ($txh_found && $dexsm_found) {
        print O ">$_";
        
        #The lengths of motif Ic and II were 5 and 6, respectively.
        #The insertion was bounded by motif Ic and motif II.
        #The length of insertion can calculate by subtracting 11 (5 + 6) 
        #from the total length of a sequence from "T" (begin of motif Ic) to "M" (end of "motif II")
        my $segment = substr($sequence, $t_pos - 1, $m_pos - $t_pos +1);
        my $total_len = $segment =~ tr/A-Z//;
        my $inslen = $total_len - 11;
        print T "$header\t$inslen\n";
    }
}


