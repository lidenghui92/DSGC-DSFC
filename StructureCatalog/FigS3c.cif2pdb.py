#!/usr/bin/env python
import sys, os 
from Bio.PDB import MMCIFParser, PDBIO

def mmcif_to_pdb(mmcif_file, pdb_file, structure_id="model"):
    # Create a MMCIF parser
    parser = MMCIFParser(QUIET=True)
    
    # Parse the mmCIF file
    structure = parser.get_structure(structure_id, mmcif_file)
    
    # Create PDBIO object and save as PDB
    io = PDBIO()
    io.set_structure(structure)
    io.save(pdb_file)
    print(f"Successfully converted {mmcif_file} to {pdb_file}")


def main():
    input_mmcif = sys.argv[1]
    output_pdb  = sys.argv[2] 
    mmcif_to_pdb(input_mmcif, output_pdb)

if __name__ == '__main__':
    main()


