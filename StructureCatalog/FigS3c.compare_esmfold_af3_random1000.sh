#!/bin/bash

#### Get 1000 foldseek cluster representatives randomly, see Fig3.foldseek_clusters.zip 
cat ./foldseek/foldseek_clusters_nres_ave.tsv | sort --key 2,2 --key 3,3 -nr > ./foldseek_cluster_statistics_sorted.dat
shuf -n 1000 ./foldseek_cluster_statistics_sorted.dat > FigS3c.foldseek_cluster_statistics_sorted_shuf1000.dat



#### Convert AF3-predicted models from CIF format to PDB format, , see FigS3c.AF3_online_pred_results.tar.gz, FigS3c.esmfold_struct.tar.gz
# Need to install Biopython version 1.84 (by Cock et al., Bioinformatics, 2009)
for nm in `ls ./FigS3c.AF3_online_pred_results` ; do 
  af3_cif=./FigS3c.AF3_online_pred_results/${nm}/fold_${nm}_model_0.cif
  af3_pdb=./FigS3c.AF3_online_pred_results/${nm}/fold_${nm}_model_0.pdb
  python FigS3c.cif2pdb.py $af3_cif $af3_pdb 
done


#### Compute average plddt scores for AF3 models and ESMFold models.
# Note that for AF3 models each atom has an individual plddt score, 
# while for ESMfold models atoms belonging to the same residue have the same plddt score.

compute_plddt_stat () {
  input_pdb=$1

  awk '
  BEGIN {
    min = 9999
    max = -9999
  }
  /^ATOM  |^HETATM/ {
    b_str = substr($0, 61, 6)
    if (b_str ~ /^ *-?[0-9]+\.?[0-9]* */) {
        b = b_str + 0
        sum += b
        sum_sq += b^2
        count++
        min = (b < min) ? b : min
        max = (b > max) ? b : max
    }
  }
  END {
    if (count > 0) {
        avg = sum/count
        stddev = sqrt(sum_sq/count - avg^2)
        printf "B-factor statistics:\n"
        printf "  Atoms counted:   %d\n", count
        printf "  Average:         %.2f\n", avg
        printf "  Standard dev:    %.2f\n", stddev
        printf "  Minimum:         %.2f\n", min
        printf "  Maximum:         %.2f\n", max
    } else {
        print "No valid atoms found"
    }
  }' $input_pdb
}


echo "id ESMFold_aa ESMFold_ca AF3_aa AF3_ca" >> tmp
for nm in `ls ./FigS3c.AF3_online_pred_results`; do
  idx=`echo $nm | cut -d '_' -f2`
  af3_pdb=./FigS3c.AF3_online_pred_results/${nm}/fold_dsm_${idx}_model_0.pdb
  esm_pdb=./FigS3c.esmfold_struct/DSM_${idx}.pdb

  af3_plddt_aa=`compute_plddt_stat $af3_pdb | grep "Average:" | awk '{print $2}'`
  esm_plddt_aa=`compute_plddt_stat $esm_pdb | grep "Average:" | awk '{print $2}'`

  af3_plddt_ca=`grep CA $af3_pdb | compute_plddt_stat | grep "Average:" | awk '{print $2}'`
  esm_plddt_ca=`grep CA $esm_pdb | compute_plddt_stat | grep "Average:" | awk '{print $2}'`

  echo "$nm $esm_plddt_aa $esm_plddt_ca $af3_plddt_aa $af3_plddt_ca" >> tmp
  echo $nm
done
mv tmp ESMFold_vs_AF3_plddt_allatom.dat


#### Compute TM-score between AF3 models and ESMFold models
# TMscore excutable (version 2022/2/27) provided by Zhang Lab was used.
echo "id tmscore" >> tmp
for nm in `ls ./FigS3c.AF3_online_pred_results`; do
  idx=`echo $nm | cut -d '_' -f2`
  af3_pdb=./FigS3c.AF3_online_pred_results/${nm}/fold_dsm_${idx}_model_0.pdb
  esm_pdb=./FigS3c.esmfold_struct/DSM_${idx}.pdb

  tmscore=`$TMscore $esm_pdb $af3_pdb | grep "TM-score    =" | awk '{print $3}'`
  echo "$nm $tmscore" >> tmp
  echo $nm
done
mv tmp ESMFold_vs_AF3_tmscore.dat


#### Merge plddt results & TM-score results into one file.
echo "id ESMFold_plddt_aa ESMFold_plddt_ca AF3_plddt_aa AF3_plddt_ca tmscore" >> tmp
for nm in `ls ./FigS3c.AF3_online_pred_results`; do
  tmscore=`grep $nm ESMFold_vs_AF3_tmscore.dat | awk '{print $2}'`
  esm_plddt_aa=`grep $nm ESMFold_vs_AF3_plddt_allatom.dat | awk '{print $2}'`
  esm_plddt_ca=`grep $nm ESMFold_vs_AF3_plddt_allatom.dat | awk '{print $3}'`
  af3_plddt_aa=`grep $nm ESMFold_vs_AF3_plddt_allatom.dat | awk '{print $4}'`
  af3_plddt_ca=`grep $nm ESMFold_vs_AF3_plddt_allatom.dat | awk '{print $5}'`
  echo "$nm $esm_plddt_aa $esm_plddt_ca $af3_plddt_aa $af3_plddt_ca $tmscore" >> tmp 
  echo $nm 
done
mv tmp FigS3c.ESMFold_vs_AF3_plddt_tmscore.dat
