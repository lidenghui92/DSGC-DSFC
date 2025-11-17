mmseqs easy-cluster Final_DSM_geneset_prot.fa protein_fm tmp_cluster --min-seq-id 0.2 -c 0.50 --cov-mode 2 --threads 35
awk '{all[$1]=all[$1]" "$2;}END{for (i in all){print i"\t"all[i]}}' protein_fm_cluster.tsv | sed 's/\s\+/\t/g' >pf_gene2cluster.stat
awk 'NF>2' pf_gene2cluster.stat >DS_pf_mul_clu.stat
awk '{for (i=2;i<=NF;i++){print $i}}' DS_pf_mul_clu.stat >DS_pf_mul_clu_all_gene_list
awk 'NR==FNR{all[$1]=1;next}{if ($1 in all){print $0}}' DS_pf_mul_clu_all_gene_list DSGC_only_uncomplete.list >pf_mul_clu_all_uncom.list
awk 'NR==FNR{all[$1]=1;next}{for(i=2;i<=NF;i++){if (!($i in all)){print $0;next}}}' DSGC_only_uncomplete.list DS_pf_mul_clu.stat >pf_mul_clu_with_1comple.stat
awk 'NR==FNR{all[$1]=1;next}{for(i=2;i<=NF;i++){if ($i in all){print $i}}}' DSGC_only_uncomplete.list pf_mul_clu_with_1comple.stat >pf_mul_clu_with_1comple_only_uncom.list 

wc -l DSGC_only_uncomplete.list   ###Incomplete Unigenes total: 293377524
wc -l pf_mul_clu_all_uncom.list          ###The number of incomplete gene clusters into protein families: 267,287,837
wc -l pf_mul_clu_with_1comple_only_uncom.list  ###The number of incomplete genes clustered into protein families, with each family containing at least one complete gene: 253092033
###Incomplete genes are clustered into protein families, and all genes in the family are incomplete: 267287837 - 253092033 = 14195804 