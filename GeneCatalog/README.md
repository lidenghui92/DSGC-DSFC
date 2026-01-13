**Samples**  

  Fig1a_S1a.maps.R was used to draw maps with sampling sites with input file Fig1a_S1a.input.txt. Fig. 1b was also plotted based on Fig1a_S1a.input.txt.  
  
**Downloading Rawdata**  

The metagenomic sequencing datasets were downloaded from the NCBI, NODE, and CNGB with the following commands. Accession numbers of runs of each sample used in this study can be found in Table S1 of the paper.
```bash
#NCBI (example ID: SRR7042067) :
  fasterq-dump -p -t /scratch/$USER -O /data/$USER/sra SRR7042067
#CNGB (example ID: CNR093384):
  wget -c ftp://ftp2.cngb.org/pub/CNSA/data5/CNP0004691/CNS0876634/CNX0799665/CNR0933845/1E_1.fq.gz
#NODE (example ID: OER00425668):
  #You can register a new account here: https://www.biosino.org/bmdcRegist/register
  #After registration (or reset password), please wait 30 mins before login to the sftp port.
  sftp -oPort=44398 your-node-register-email@fms.biosino.org
  Password: your-node-password
  #Navigate to the target folder you need
  cd /Public/byRun/OER00/OER0042/OER004256/OER00425668
  get OED00831759_FDZ031YE0-5_R1.fq.gz
  #for more details: https://www.biosino.org/node/help
```

**Filtering and Assembly**  

All the raw reads were quality-controlled using Fastp (v0.23.1) to remove the low-quality, adapter contaminated and duplicated reads.   

`fastp -i example_1.fastq.gz -o example_clean_1.fq.gz -I example_2.fastq.gz -O example_clean_2.fq.gz -f 0 -t 0 -F 0 -T 0 -Y 30 -l 15 --json example_fastp.json --html example_fastp.html`  

The filtered reads were assembled with MEGAHIT (v1.2.9). For the 944 published datasets, the threshold for contig filtering was 500 bp. Considering the high sequencing depth of the 1,194 MEER samples, the contigs shorter than 1,000 bp were removed from the assemblies.   

```bash
megahit -1 example_clean_1.fq.gz -2 example_clean_2.fq.gz -o ./example/ --out-prefix example --presets meta-sensitive -t 10
perl -e '$/=">";<>;while(<>){chomp;my($name,$seq)=split/\n/,$_,2;$newname=(split(/\s+/,$name))[0];$seq=~s/\n//g;$seq=~s/\s+//g;$len=length ($seq);if($len>=1000){print ">example_$newname\n$seq\n"}}' example.contigs.fa >example.contigs_500.fa #For MEER samples, $len>=1000 is required
```
According to the assembly results, MetaGeneMark (v3.38) was used to predict the coding sequences (CDSs) longer than 100 bp in the assembled contigs, and the CDSs were translated into protein sequences according to codon table 11.
```bash
gmhmmp -m MetaGeneMark_v1.mod -o example.gmm example.contigs_500.fa
perl deal_gmm.pl example.gmm example.contigs_1000.fa 100 example_ example
perl transform.pl codon-table.11 example.gene_nucl.fa example.gene_prot.fa
```
Assembly results of all samples, see All_sample_contig_stat.xlsx, which was used to plot Fig. S1b.  

**Deep Sea Microbial Gene Catalog**  

All sequences were clustered using MMseqs2 (v14-7e284) to generate a nonredundant microbial gene catalog, designated as DSGC, which contained 501,998,347 genes.  

```bash
mmseqs easy-cluster deepsea_all_pep.fa cluster_proteins tmp_cluster --min-seq-id 0.95 -c 0.90 --cov-mode 1 --cluster-mode 3 --threads 30
perl -e 'open OU1,">Final_DSM_geneset_prot.fa"; open OU2,">name.change.list"; while(<>){ chomp; if(/^>/){ $id=sprintf("%010d",++$id); print OU2 "$_\tDSM_$id\n"; print OU1 ">DSM_$id\n"; next; } print OU1 "$_\n"; }' cluster_proteins_rep_seq.fasta #Name format change
```
To elucidate the relationships between complete and incomplete unigenes, we clustered DSGC protein sequences with MMseqs2 (v14-7e284) (see FigS1c.DSGC_protein_family_stat.sh), followed by statistical profiling using the FigS1c.DSGC_protein_family_stat.sh script, which provided the data for Fig. S1c. The clustering result (DSGC_cluster_20id.tsv.gz) and a list of incomplete ORFs (DSGC_only_uncomplete.list.gz) have been deposited at Zenodo.  

To assess the coverage of the DSGC relative to deep-sea microbial gene content, we randomly selected 100 metagenomic samples from each of the four deep-sea ecosystem groups and extracted up to 50 million reads per sample. The reads from each sample were aligned to the DSGC using Diamond (v2.1.6), and the mapping rate for each metagenomic dataset was calculated. The final alignment results are provided in FigS1d.Read_mapping_stat.xlsx, which data is illustrated Fig. S1d.
```bash
diamond makedb --in Final_DSM_geneset_prot.fa --db DSM_geneset --threads 30
diamond blastx -d DSM_geneset.dmnd --query example_top25M_clean_1.fq.gz --out example_1_mapping.m8 --outfmt 6 -k 1 --id 70 --query-cover 80 -p 20 -e 0.0001 --faster
diamond blastx -d DSM_geneset.dmnd --query example_top25M_clean_2.fq.gz --out example_2_mapping.m8 --outfmt 6 -k 1 --id 70 --query-cover 80 -p 20 -e 0.0001 --faster
```

For the taxonomic annotation of the DSGC, all gene sequences were aligned to the Non-Redundant Protein Sequence Database (the nr database) (v20200619).  

`diamond blastp --evalue 1e-5 -q Final_DSM_geneset_prot.fa_1.fa -d nr.dmnd -o Final_DSM_geneset_prot.fa.nr.megablastout --sensitive --max-target-seqs 5 --salltitles --outfmt 6 --threads 20`  

Genes derived from metagenome-assembled genomes (MAGs) were taxonomically classified using GTDB-Tk, while the remaining genes were assigned taxonomy based on the lowest common ancestor (LCA) of their top hits in the NR database. The complete taxonomic annotation results have been deposited at Zenodo (see file: gene2tax_7level_LCA_add_gtdb.txt.gz).  

We used Diamond (v2.1.6) and eggNOG-mapper (v2.0.1) to annotate the DSGC and KEGG databases (r104.1) and eggNOG database (v5.0.0), respectively. For the TSGC and OM-RGC datasets, annotations against the eggNOG database (v5.0.0) were carried out using the same eggNOG-mapper version (v2.0.1) and parameter set. The relevant results can be found in files DSGC_KEGG_annotation.gz, DSGC_emapper_COG.xls.gz, OM-RGC_emapper_COG.xls.gz and TSGC_emapper_COG.xls.gz, which have been deposited at Zenodo.
```bash
diamond blastp -p 25 -d /KEGG/prokaryotes.dmnd -e 0.00001 -q Final_DSM_geneset_prot.fa -f 6 --sensitive -o Final_DSM_geneset_prot.fa.m8
export EGGNOG_DATA_DIR=/Path_to_database/eggNOG
python emapper.py -i Final_DSM_geneset_prot.fa --output Final_DSM_geneset_prot.fa -m diamond
```

Sequences in DSGC, as well as those in global topsoil gene catalog (TSGC, 159.7 M genes) and the Tara ocean's OM-RGC (46.8 M genes) were aligned against all 21,979 Pfams in the Pfam database (v36.0) using hmmsearch program (E-value ≤ 0.01) from the HMMER package (v3.3.2), and then the hmmsearch results were filtered by a sequence coverage of 75%. The Nf (number of effective sequences in MSA) was calculated using plmc (commit 1a9ale9228a2177c618c69040ea8cfc2d902d9df):
```bash
hmmsearch -o /dev/null --noali --notextw --cpu 10 --incT 27 -T 27 -A InputFA_PFxxxxx.sto PFxxxxx.hmm InputFA
perl reformat.pl -M first -r -g '-' sto a3m InputFA_PFxxxxx.sto InputFA_PFxxxxx.a3m #https://github.com/soedinglab/hh-suite/blob/master/scripts/reformat.pl
plmc --fast -m 1 -n 10 InputFA_PFxxxxx.a3m 1>out1.txt 2>out2.txt #extract the Nf value, e.g., "# Effective number of samples: 1419.6"
```

These data were summarized in Fig1e.Pfam_homologs.xlsx, and Fig. 1e was generated using Fig1e.Pfam_neff.R.  

The protein family-level clustering between DSGC, and the global ocean gene catalog 1.0 (GOGC), or and TSGC and OM-RGC were calculated with MMseqs2 (v14-7e284) (see Fig1fg_S1e.stat.sh). We calculated data for Fig. 1fg and Fig. S1e with the scripts Fig1fg_S1e.stat.sh. As the DSGC, OM-RGC, and TSGC differ in size, we further conducted five independent clustering replicates, each using 10 million sequences randomly subsampled per catalog with the ‘sample’ module of SeqKit (v0.4.5) (see tableS2.sh). All MMseqs2 parameters remained identical to those employed for clustering the full catalogs.

To enable a taxonomically consistent comparison of genetic diversity, all prokaryotic genes in DSGC, OM-RGC, and TSGC were annotated using MMseqs2 (v18.8cc5c) with the easy taxonomy routine against the GTDB database (release r226). As some phyla (or order) were represented by very few genes, a phylum (or order) was considered robust in a given catalog if it comprised >0.1% (or >0.01%, respectively) of the total genes in that catalog. Taxonomic groups that passed this threshold in all three catalogs were defined as overlapping phyla (or orders). DSGC exhibited largest non-redundant gene numbers in these overlapping phyla (or orders) among the three catalogs, while it harbored largest non-redundant gene counts in 11/15 overlapping phyla and 45/62 overlapping orders. The scripts for this analyses and key intermediate files are summarized in tableS3.sh and tableS3_intermediate.tgz, respectively.

**Analysis of Metagenome-Assembled Genomes**  

To generate metagenome-assembled genomes (MAGs), MetaWRAP (v1.3.2) was employed for binning of all the 2,138 deep-sea metagenomes with default parameters. All MAGs were evaluated using CheckM (v1.0.12), and those with low-quality (completeness <50% or contamination >10%) were removed.
```bash
metaWRAP binning -o example -t 30 --metabat2 --concoct --maxbin2 -l 1000 -a example.contigs_500.fa example_clean_1.fastq example_clean_2.fastq 
metawrap bin_refinement -o example/BIN_REFINEMENT -t 30 -A example/metabat2_bins/ -B example/maxbin2_bins/ -C example/concoct_bins/ -c 50 -x 10
```

All the retained MAGs were clustered at 95% ANI with dRep (v3.3.0). GTDB-TK (v2.3.2) was used for taxonomic annotation of each MAG by searching the GTDB (r214).
```bash
dRep dereplicate ./result -g DS_genome_path.txt -p 50 --length 0 --completeness 50 --contamination 10 --S_algorithm ANImf --P_ani 0.9 --S_ani 0.95 --cov_thresh 0.3 --strain_heterogeneity_weight 0 --genomeInfo DS_MAGs_checkm.csv > ./drep.log 2>&1
gtdbtk classify_wf --genome_dir /DS_ALL_MAGs/ --out_dir /result -x fa --cpus 10 --skip_ani_screen
```

The MAG statistics and annotations for all deep-sea and Tara ocean samples can be found in the deepsea_OM_mags_stat.xlsx. Deepsea_HQ_MAGs_drep.tar.gz at Zenodo contained all the high-quality deep-sea MAGs.  

**PS: Files listed in "Files_at_Zenodo.txt" have been deposited at Zenodo with DOI: 10.5281/zenodo.18170924**  

