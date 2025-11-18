
#### ---------------------------------------
#### Foldseek easy-cluster ####
#### ---------------------------------------

data_dir=.../Final_Deepsea_structureDB
all_pdb_dir=$data_dir/HQ3D  # Only consider the 1,119,421 High-Quality models
curr_dir=$PWD

# easy-cluster
foldseek easy-cluster $all_pdb_dir \
  res tmp \
  --tmscore-threshold 0.5 -c 0.7 --cov-mode 0 


mkdir -p $curr_dir/foldseek  #this folder is packaged in Fig3.foldseek_clusters.zip

mv rep.id                     $curr_dir/foldseek/foldseek_clusters_repID.dat  # ID's of representatives of 61,933 clusters 
mv foldseek_clusters_clu.tsv  $curr_dir/foldseek                              # 1,119,421 lines: rep mem


# get number of residues for each protein 
while read -r rep mem ; do 
  nres=`awk '{print $3}' $all_pdb_dir/${mem}.pdb | grep CA | wc -l`
  echo $rep $mem $nres >> $curr_dir/foldseek/foldseek_clusters_nres.tsv       # 1,119,421 lines
done < foldseek_clusters_clu.tsv


# get the average number of residues of members in a cluster of a given representative
repID_fpath=$curr_dir/foldseek/foldseek_clusters_repID.dat
for rep in `cat $repID_fpath` ; do
  nmem=`awk '{print $1}' $curr_dir/foldseek/foldseek_clusters_clu.tsv | grep $rep | wc -l`
  nres_ave=`grep $rep $curr_dir/foldseek/foldseek_clusters_nres.tsv | awk -v N=$nmem '{ sum += $3 } END { if (NR > 0) print sum / NR }'`
  echo $rep $nmem $nres_ave >> $curr_dir/foldseek/foldseek_clusters_nres_ave.tsv   # 61,933 lines 
done


# Sort, if needed 
# cat $curr_dir/foldseek/foldseek_clusters_nres_ave.tsv | sort --key 2,2 --key 3,3 -nr > $curr_dir/foldseek_cluster_statistics_sorted.dat

# Useful files of this step 
# $curr_dir/foldseek/foldseek_clusters_repID.dat
# $curr_dir/foldseek/foldseek_clusters_clu.tsv
# $curr_dir/foldseek/foldseek_clusters_nres.tsv 
# $curr_dir/foldseek/foldseek_clusters_nres_ave.tsv 


#### ---------------------------------------
#### TED novel domain analysis ####
#### ---------------------------------------
'''
The original output of the TED consensus tool (v1.0) by Lau et al., Science 2024: 
00.consensus_HML.tsv (61,933 lines)

Sample data from 00.consensus_HML.tsv as beneath. 

DSM_0174956964	ac85db11bf4b70d8a4683576963dfc0e	70	1	0	0	13-25_34-69	na	na
DSM_0358368444	a12a3199c54583cb8e0275aaddf8d321	78	1	0	0	2-76	na	na
DSM_0190499839	67237cd19be89c2bd54d56e181c9378e	64	1	0	0	4-15_32-64	na	na
DSM_0383068068	515415f6c8a962de46388617673bdcf2	196	1	0	0	6-191	na	na
DSM_0168918528	a24aba1cdf899b1bfc90df4126bc105c	75	1	0	0	11-75	na	na
DSM_0160450773	57f03fce1759a2ea9a48c3c713c97cd4	137	1	0	0	3-12_25-126	na	na
DSM_0102954247	a5f3040d69b5aef2bc9d10f5a32b9fb6	413	2	0	0	6-160,168-397	na	na
DSM_0475149340	52b1c94b5cdbbff8132a4a2e06ebde76	448	0	1	4	na	4-163_200-245_320-447	2-170_211-216_334-366,164-199_246-319,171-210_217-333,367-448
DSM_0310444513	487d10a6eac96f7ecfb533ca3779918b	127	1	0	0	18-120	na	na
DSM_0186807516	41422948509217f147e8abbb254e7f82	523	2	0	0	32-146_159-280,292-519	na	na

Explain: 
1st column, PDB file name without file extension 
3nd column, number of residues of the model 
4-6th columns, numbers of high/medium/low-quality domains 
7-9th columns, residue ranges of high/medium/low-quality domains, seperated by coma

----------------------------------------------------------------------------------------
The original output of Foldclass novelty score produced by TED consensus tool (v1.0): 
00.ted_output_anomaly_190000domain_HML.txt (192,890 lines)

Sample data from 00.ted_output_anomaly_190000domain_HML.txt as beneath.

.../Ted/ted-tools/ted_consensus_1.0/segmented_domains/DSM_0279321797_2-32.pdb 5.514344215393066
.../Ted/ted-tools/ted_consensus_1.0/segmented_domains/DSM_0339076165_37-127.pdb 29.913454055786133
.../Ted/ted-tools/ted_consensus_1.0/segmented_domains/DSM_0409682285_30-347.pdb 39.27803039550781
.../Ted/ted-tools/ted_consensus_1.0/segmented_domains/DSM_0313695352_10-92.pdb 57.93840789794922
.../Ted/ted-tools/ted_consensus_1.0/segmented_domains/DSM_0193374838_142-228.pdb 29.68964958190918
.../Ted/ted-tools/ted_consensus_1.0/segmented_domains/DSM_0295823895_197-312.pdb 43.49933624267578
.../Ted/ted-tools/ted_consensus_1.0/segmented_domains/DSM_0327836939_904-1063.pdb 43.341556549072266
.../Ted/ted-tools/ted_consensus_1.0/segmented_domains/DSM_0264847259_31-105.pdb 34.2420654296875
.../Ted/ted-tools/ted_consensus_1.0/segmented_domains/DSM_0498952300_222-318.pdb 37.76008605957031
.../Ted/ted-tools/ted_consensus_1.0/segmented_domains/DSM_0231404763_375-602.pdb 43.444305419921875

Explain:
1st column, PDB file path to the segment domain
2nd column, Foldclass novelty score 
'''

domain_pdb_dir=$curr_dir/DSTEDdom  # compressed in DSTEDdom.tar.gz
foldseek_clu_statistics=$curr_dir/foldseek/foldseek_clusters_nres_ave.tsv
TED_novelty_dat=$curr_dir/00.ted_output_anomaly_190000domain_HML.txt  # ID's of High-/Medium-/Low-quality domains, 192,890 lines 
DSTEDdom_HM=$curr_dir/00.TED_concensus_HM_domainID.dat                # ID's of High-/Medium-quality domains, 104,508 lines  

## Compute plddt & nss  
for fpath in `awk '{print $1}' $TED_novelty_dat`; do
  filename="${fpath##*/}"
  filename_wo_ext="${filename%.*}"                # DSM_0327836939_904-1063
  fpath=$domain_pdb_dir/${filename_wo_ext}.pdb    # $curr_dir/DSTEDdom/DSM_0327836939_904-1063.pdb

  plddt=`python Fig3f.check_plddt.py $fpath`
  nss=`python Fig3f.check_secseq.py $fpath`

  echo "$filename_wo_ext $plddt $nss" >> $curr_dir/01.domain_plddt_nss.dat  # 192,890 lines
done

# filter 
awk '$2 >= 90 && $3 >= 6' $curr_dir/01.domain_plddt_nss.dat  > $curr_dir/01.domain_plddt_nss_filtered.dat  # 76,751 lines 

input=$curr_dir/01.domain_plddt_nss_filtered.dat
output=$curr_dir/02.domain_cs_nres_novelty.dat     # cs: cluster size
res=$curr_dir/02.domain_cs_nres_domnres_plddt_nss_novelty.dat

while read -r domain plddt nss ; do
  filename_wo_ext=$domain # DSM_0327836939_904-1063
  idx=`echo $filename_wo_ext | cut -d '_' -f2`
  dsm_idx="DSM_$idx"      # DSM_0327836939

  cluster_size=`grep $dsm_idx $foldseek_clu_statistics | awk '{print $2}'`
  average_nres=`grep $dsm_idx $foldseek_clu_statistics | awk '{print $3}'`
  novelty=`grep $domain $TED_novelty_dat | awk '{print $2}'`

  echo "$domain $cluster_size $average_nres $novelty"
done < $input > $output

# Formatting
awk '{
       filename_wo_ext = $1                  
       cluster_size    = int($2)             
       average_nres    = sprintf("%.1f", $3)
       novelty         = sprintf("%.2f", $4) 
       printf "%s %d %s %s\n", filename_wo_ext, cluster_size, average_nres, novelty
     }' $output > tmp
mv tmp $output  # 02.domain_cs_nres_novelty.dat, 76,751 lines


# $res: 02.domain_cs_nres_domnres_plddt_nss_novelty.dat, 76,751 lines
while read -r domain cs nres novelty ; do
  input_string=`echo $domain | cut -d '_' -f 3-`
  npart=$(echo $input_string | tr "_" " " | wc -w)

  nres_domain=0
  for i in `seq 1 $npart`; do 
    part=`echo $input_string | cut -d '_' -f $i`
    a=`echo $part | cut -d '-' -f1`
    b=`echo $part | cut -d '-' -f2`
    nres_domain=`expr $b - $a + 1 + $nres_domain`
  done 

  plddt=`grep $domain $input | awk '{print $2}'`
  nss=`grep $domain $input | awk '{print $3}'`

  echo "$domain $cs $nres $nres_domain $plddt $nss $novelty" >> $res 
done < $output  


## Compute packing 
for fpath in `awk '{print $1}' $output`; do
  fpath=$domain_pdb_dir/${fpath}.pdb    # $curr_dir/DSTEDdom/DSM_0327836939_904-1063.pdb

  packing=`python Fig3f.check_packing_density.py $fpath`
  echo "$fname $packing" >> $curr_dir/02.domain_packing.dat  # 76,751 lines
done

# filter 
awk '$2 >= 10.3' $curr_dir/02.domain_packing.dat > $curr_dir/02.domain_packing_filtered.dat  # 65,289 lines 

# Put all fields of output in one file 
input=$curr_dir/02.domain_cs_nres_domnres_plddt_nss_novelty.dat
output=$curr_dir/03.domain_cs_nres_domnres_plddt_nss_packing_novelty.dat # 65,289 lines

while read -r domain packing ; do
  line=`grep $domain $input`

  domain=`echo $line | cut -d ' ' -f1`
  cs=`echo $line | cut -d ' ' -f2`
  nres=`echo $line | cut -d ' ' -f3`
  domres=`echo $line | cut -d ' ' -f4`
  plddt=`echo $line | cut -d ' ' -f5`
  nss=`echo $line | cut -d ' ' -f6`
  novelty=`echo $line | cut -d ' ' -f7`

  echo "$domain $cs $nres $domres $plddt $nss $packing $novelty" >> $output
done < $curr_dir/02.domain_packing_filtered.dat 


## Copy all filtered domains to a folder 
mkdir -p $curr_dir/03.DSTEDdom_filtered

for fpath in `awk '{print $1}' $output`; do 
  fpath=$domain_pdb_dir/${fpath}.pdb
  cp $fpath $curr_dir/03.DSTEDdom_filtered
done


## Foldseek, exhaustively align with AFDB rep (2.3 million structures) 
AFDBrepDB=../afdb_rep_v4/afdb_rep_v4  # Pre-downloaed AFDB representative DB by Barrio-Hernandez et al., Nature 2023
targetDB=$AFDBrepDB

foldseek easy-search \
  $curr_dir/03.DSTEDdom_filtered $targetDB 04.DSTEDdom_vs_AFDBrep_exhaustive.m8 ./tmpFolder \
  --exhaustive-search  \
  -c 0.6 --cov-mode 2  --tmscore-threshold 0.56 --alignment-type 1 \
  --format-output "query,target,fident,alnlen,qlen,tlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,alntmscore" 


# Only consider non-hit High-/Medium-quality domains 
awk '{print $1}' $curr_dir/03.domain_cs_nres_domnres_plddt_nss_packing_novelty.dat | grep -f $DSTEDdom_H > tmp
all=$curr_dir/04.DSTEDdom_filtered.dat                            
mv tmp $all                                                         # 41.224 lines   

dat=$curr_dir/04.DSTEDdom_vs_AFDBrep_exhaustive.m8
hit=$curr_dir/04.DSTEDdom_vs_AFDBrep_exhaustive_hits.dat
awk '{print $1}' $dat | awk '!seen[$0]++' > $hit                    # 63,621 lines 

grep -v -F -x -f $hit $all > $curr_dir/04.nonhit_exhaustive_HM.dat  # 392 lines 


## Plot novelties of non-hit domains 
nohitID=$curr_dir/04.nonhit_exhaustive_HM.dat
dat=$curr_dir/03.domain_cs_nres_domnres_plddt_nss_packing_novelty.dat

prefix=05.nonhit_exhaustive_HM_domain
midfix=cs_nres_domnres_plddt_nss_packing_novelty
nohit=$curr_dir/${prefix}_${midfix}_sorted.dat
grep -F -f $nohitID $dat | sort --key 8,8 -nr --key 2,2 > $nohit  # 392 lines 

python $curr_dir/Fig3f.plot_cs_nres-d_novelty.py $nohit 


## Perform SymD to get symmetrical domains 
symD=.../symd1.61-linux  # pre-downloaded symd software by Tai et al., Nucleic Acids Research 2014

mkdir -p 06.domainID
cnt=1
for nm in `cat $curr_dir/04.nonhit_exhaustive_HM.dat`; do
  fpdb=$curr_dir/03.DSTEDdom_filtered/${nm}.pdb
  cp $fpdb r${cnt}.pdb

  $symD r${cnt}.pdb | grep "Best(initial shift" >> $curr_dir/06.symd_ini.dat

  for pdb in `ls r${cnt}*trfm.pdb` ; do
    score=`grep "Z-score at best alignment" $pdb | awk '{print $7}'`
    echo $nm $pdb $score >> $curr_dir/06.symd_res.dat
  done

  rm *best.fasta
  mv *info.txt $curr_dir/06.domainID/
  mv *trfm.pdb $curr_dir/06.domainID/

  cnt=`expr $cnt + 1`
done

awk '$3 > 9' $curr_dir/06.symd_res.dat | sort --key 3,3 -nr > $curr_dir/06.symd_res_Z-gt9.dat   # 58 lines 


