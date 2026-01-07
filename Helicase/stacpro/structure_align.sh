#usage: sh structure_align.sh path_to_the_structures
#for the stacpro pacakge: https://github.com/BGI-Qingdao/stacpro
export PYTHONPATH="Path_to_stacpro:$PYTHONPATH"
python main_parallel_step1.py $1/ 300
mkdir $1/alignments
for i in {0..299};do echo "export PYTHONPATH=\"Path_to_stacpro:\$PYTHONPATH\";python main_parallel_step2.py $1/ 300 "$i >> run_step2.sh; done
#then should submit tasks in run_step2.sh to HPC
python main_parallel_step3.py $1/
python main_parallel_step4.py $1/ 
