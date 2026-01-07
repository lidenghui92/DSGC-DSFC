**Performance assessment of DSGC-optimized AF2**  

To validate the improvement of DSGC on structure prediction of deep-sea proteins, we randomly selected 200 protein sequences from DSGC, which lengths were equally distributed in the range of 0–1000 residues. Then, we built DS-MSA and AF2-MSA by searching DSGC and the default genetic datasets of AF2, respectively, and performed structure prediction using AF2 with each MSA.  

Following the instruction provided by AlphaFold Github repository, we first ran AF2 with the default settings, which would search against its default genetic datasets (including BFD ~1.8 TB, MGnify ~ 120 GB, UniRef90 ~ 67 GB, UniClust30 ~ 206 GB). This would generate an output directory, in which there was a subfolder, called msas, containing 3 MSA files, namely bfd_uniref_hits.a3m, mgnify_hits.sto, and uniref90_hits.sto. These three MSA files would later be used to extract the MSA features by AF2 and thus were referred to as the AF2-MSA by us.  

```bash
python3 docker/run_docker.py --fasta_paths=user_protein.fasta \
  --max_template_date=2020-05-14 \
  --model_preset=monomer \
  --db_preset=full_dbs \
  --data_dir=$DOWNLOAD_DIR \
  --output_dir=/home/user/absolute_path_to_the_output_dir
```

In the meanwhile, we used JackHMMER to search against the deep-sea sequences with the same chosen parameters of AF2. This would generate an MSA file, named deep_sea.sto, which was referred to as the DS-MSA by us.  

```bash
jackhmmer --noali --F1 0.0005 --F2 0.00005 --F3 0.0000005 --incE -E 0.0001 --cpu 8 -N 1 \
/home/user/absolute_path_to_the_query_sequence/query.fasta \
/home/user/absolute_path_to_the_deepsea_dataset/deepsea_sequence.fa
```

Then, we removed the 3 MSA files in the output folder (saving all output files in the first run somewhere else) and instead renamed the deepsea_hits.sto as mgnify_hits.sto. In this way, as we ran AF2 again and turned on the use_precomputed_msas flag, AF2 would recognize only the substituted STO file as the supplied MSA and conducted the subsequent inference.  

```python
python3 docker/run_docker.py \
  --fasta_paths=user_protein.fasta \
  --max_template_date=2020-05-14 \
  --model_preset=monomer \
  --db_preset=full_dbs \
--use_precomputed_msas=true \
  --data_dir=$DOWNLOAD_DIR \
  --output_dir=/home/user/absolute_path_to_the_output_dir
```

The computing time consumed for prediction and the resultant pLDDT score for each query were compared across MSAs (Fig. S4a, b, result: FigS4abc.AF2_pLDDT_time.xlsx) and visualized with FigS4abc.dotplot.R. The same set of AF2 parameters was used throughout the AF2 prediction with different datasets to ensure consistency and comparability. The predicted structures (FigS4ab.structure.tar.gz) using either DS-MSA or AF2-MSA have been deposited at Zenodo. All of the scripts mentioned above is available on our Github repository (FigS4ab.Run_AF2_with_DSMSA.sh).  

To further validate the accuracy of prediction using DSGC optimized AF2, we calculated the structure similarity (represented by TM-score) between the models predicted using DS-MSA and AF2-MSA respectively. The results showed high consistency between these models, especially those with higher pLDDT scores (Fig. S4c, see script FigS4abc.dotplot.R and inputfile FigS4abc.AF2_pLDDT_time.xlsx).  

**Structure-based mining of superfamily 1 helicase**  

We then employed Foldseek to align all structures in DSFC except those with low confidence against these reference structures, and 3,485 structures, which represented 3,485 sequence clusters, were confidently (query coverage > 0.75, TM-score > 0.5) aligned to the reference structures (see result Fig4a.Deepsea_vs_helicase.m8).  

```bash
foldseek createdb ./Deepsea_HQ_MQ/ DeepseaHQMQDB --threads 48
foldseek createindex DeepseaHQMQDB temp --threads 48
sh Nomburg_foldseek.sh -D ./DeepseaHQMQDB -o Deepsea_vs_helicase.m8 -d ./HELICASEREFDB -t 48
```

742 of these 3,485 clusters were found to be deep-sea exclusive, and we found 6,403 complete ORFs (see result Fig4a.3485_cluster_members.list) with a protein length in the range of 350–1100 aa (determined by the lengths of the references). These unigenes were then aligned to the nr database (v20200619), and 2,449 sequences with identity < 50% were kept in total (see result Fig4a.helicase_deepsea.nr.clustalo.megablastout).  

`diamond blastp --evalue 1e-5 -q helicase.filter.com.length_filter.list.fa -d nr.dmnd -o helicase_deepsea.nr.clustalo.megablastout --sensitive --max-target-seqs 5 --salltitles --outfmt 6 --tmpdir ./ --threads 48`  

The structures of the 2,449 sequences were predicted using DSGC-optimized AF2, and structures with average pLDDT > 70 were aligned against the 12 reference structures again with the same threshold (query coverage > 0.75, TM-score > 0.5) to ensure robustness (see result Fig4a.DS_2432_protein_vs_ref.m8). This filtering resulted in 1,308 candidate helicases, which structures have been deposited at Zenodo (Fig4b.Pdb_files_1308_deep-sea_helicases.zip).  

```bash
esm-fold -i candidate_2449.nr.list.fa -o ./helicase_structure --max-tokens-per-batch 1 --chunk-size 128
foldseek createdb ref_helicase_SF1_structure ref_HelicaseDB
sh Nomburg_foldseek.sh -i ./helicase_structure -o DS_2432_protein_vs_ref.m8 -d ref_HelicaseDB -t 48
```

For Fig. 4b, we constructed the tree of helicase structures based on their structure similarities instead of multiple sequence alignment. In detail, we employed the predicted structures of 1,308 deep-sea helicases (result: Fig4b.Pdb_files_1308_deep-sea_helicases.zip at Zenodo), 13 reference structures from PDB (3E1S, 5FHH, 5O6B, 7OTJ, 2GJK, 2XZL, 4B3F, 5EAN, 5MZN, 1PJR, 1UAA, 3LFU; outgroup: 1OYW) as inputs, and calculated their pairwise structural similarity (represented by TM-score) matrix using the software of US-align (v20240730). The generated matrix (result: Fig4b.TM_score_matrix.tsv.gz at Zenodo) was then used for hierarchical clustering using the UPGMA method, while the result was finally visualized as a tree file (result: Fig4b.tree_file_rooted.nwk, Fig4b.tree_rooted.pdf). The progresses of structure alignments and hierarchical clustering were conducted using the Stacpro pipeline, and all the scripts are available in the folder "stacpro".  

In addition, we generated multiple sequence alignments in Fig. 4e and Fig. S4d to analyze the insertions of helicase 1B domain. As shown in Fig. 4a, we first searched the DSFC with helicase reference structures and identified helicase-like structures in DSFC. As each structure in DSFC represents a cluster of unigenes (at > 20% amino-acid identity), we retrieved deep-sea unigenes represented by these helicase-like structures, and filtered these unigenes based on ORF completeness and protein length (in the range of 350–1100 aa). After predicting structures of these filtered sequences, we got 7,294 Pif1-like deep-sea proteins whose structures were best aligned to Pif1-like reference structures (3E1S, 5FHH, 5O6B, and 7OTJ). To calculate the insertion lengths of the 1B domain of helicase, we employed motif Ic and II as boundaries (see file Fig4e.motifs.docx). We thus created a multiple sequence alignment of the 7,294 protein sequences using MAFFT (v7.407) with default parameters (result: Fig4e.MSA_7294_Pif1like_seqs.mafft.gz) and filtered them with the presence of motif Ic and II, which resulted in 6,082 sequences. For Fig. 4e, we calculated the amino-acid lengths between motif Ic and II of these 6,082 sequences for Fig. 4e (result: Fig4e.Pif1_insertion.xlsx). Please note that outliers were not shown in Fig. 4e, and the scripts used to analyze the multiple sequence alignment of the 7,294 protein sequences was provided in Github (Fig4e.helicase_MSA_analyze.pl). For Fig. S4d, we aligned the sequences of the ten deep-sea helicases, which were selected for experimental validation, with sequences of RecD2 and DDA using MAFFT (v7.407) with default parameters (result: FigS4d.msa.gz).  

**PS: Files listed in "Files_at_Zenodo.txt" have been deposited at Zenodo with DOI: 10.5281/zenodo.17621312**  

