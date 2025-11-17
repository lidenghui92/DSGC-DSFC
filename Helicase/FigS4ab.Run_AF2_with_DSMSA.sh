# Run the AF2 with the default settings and its default genetic datasets
python3 docker/run_docker.py \
  --fasta_paths=user_protein.fasta \
  --max_template_date=2020-05-14 \
  --model_preset=monomer \
  --db_preset=full_dbs \
  --data_dir=$DOWNLOAD_DIR \
  --output_dir=/home/user/absolute_path_to_the_output_dir

# Save all AF2 output 
cp -r /home/user/absolute_path_to_the_output_dir /home/user/absolute_path_to_the_output_dir_AF2

# Manual generation of DS-MSA using JackHMMER with the default parameters 
# chosen by AF2 (see alphafold/data/tools/jackhmmer.py on the official
# GitHub repo of AF2 for reference)
jackhmmer --noali --F1 0.0005 --F2 0.00005 --F3 0.0000005 --incE -E 0.0001 --cpu 8 -N 1 \
/home/user/absolute_path_to_the_query_sequence/query.fasta \
/home/user/absolute_path_to_the_deepsea_dataset/deepsea_sequence.fa 

# Replace the AF2-MSA with DS-MSA:
# Remove all 3 MSAs in the output directory generated in the first run.
# Move DS-MSA in that directory and rename.
rm /home/user/absolute_path_to_the_output_dir/msas/* 
mv /home/user/absolute_path_to_the_query_sequence/deepsea_hits.sto /home/user/absolute_path_to_the_output_dir/msas/mgnify_hits.sto

# Re-run AF2 with --use_precomputed_msas turned on.
python3 docker/run_docker.py \
  --fasta_paths=user_protein.fasta \
  --max_template_date=2020-05-14 \
  --model_preset=monomer \
  --db_preset=full_dbs \
--use_precomputed_msas=true \
  --data_dir=$DOWNLOAD_DIR \
  --output_dir=/home/user/absolute_path_to_the_output_dir
