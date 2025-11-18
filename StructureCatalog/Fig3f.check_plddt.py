# coding: utf-8
import re,gc 
import sys,os,time,math,string 
import numpy as np
np.set_printoptions(precision=3,suppress=True)

def extract_plddt_from_pdb(pdb_file):
    from Bio.PDB import PDBParser
    parser = PDBParser()
    structure = parser.get_structure('structure', pdb_file)
    return [atom.get_bfactor() for atom in structure.get_atoms() if atom.get_name() == 'CA']

def main():
    fpath = sys.argv[1]
    plddt = np.array(extract_plddt_from_pdb(fpath)) 
    cutoff = np.percentile(plddt, 20)
    result = np.mean(plddt[plddt >= cutoff])
    print('%.2f'%result)
    return 

if __name__ == "__main__":
    main()
