# coding: utf-8
import sys,os 
import numpy as np
import mdtraj as md
from itertools import combinations

pdb_file = sys.argv[1] 
t = md.load(pdb_file)

heavy_atoms = t.topology.select('mass > 2')

# Build a mapping to map every residue to its heavy atoms 
residue_to_heavy_atoms = {}
for atom in t.topology.atoms:
    if atom.element.mass > 1.5:  # only consider heavy atoms 
        if atom.residue.index not in residue_to_heavy_atoms:
            residue_to_heavy_atoms[atom.residue.index] = []
        residue_to_heavy_atoms[atom.residue.index].append(atom.index)

# Initialize the distance matrix  
n_residues = t.n_residues 
distance_matrix = np.full((n_residues, n_residues), np.inf)

# Compute the minimum distances for all pairs of residues  
for res_i, res_j in combinations(residue_to_heavy_atoms.keys(), 2):
    min_distance = np.inf
    for atom_i in residue_to_heavy_atoms[res_i]:
        for atom_j in residue_to_heavy_atoms[res_j]:
            distance = md.compute_distances(t, [[atom_i, atom_j]])[0][0]
            if distance < min_distance:
                min_distance = distance
    distance_matrix[res_i, res_j] = min_distance
    distance_matrix[res_j, res_i] = min_distance  # symmetrical 

# Convert distance matrix to contact matrix  
for i in range(n_residues):
    for j in range(n_residues):
        distance_matrix[i, j] = 1 if distance_matrix[i, j] <= 0.5 else 0  # 0.5 nm = 5 A

np.fill_diagonal(distance_matrix, 0)

hydrophobic_residues = ['ALA', 'VAL', 'LEU', 'ILE', 'MET', 'PHE', 'TRP', 'TYR', 'PRO']
hydrophobic_counts = []
for i, residue in enumerate(t.topology.residues):
    if residue.name in hydrophobic_residues:
        count = np.sum(distance_matrix[i, :])
        hydrophobic_counts.append(count)

# Print out the results 
#for i, count in enumerate(hydrophobic_counts):
#    print(f"Hydrophobic residue {i+1} has {int(count)} neighbors within 5 angstroms.")

average_neighbors = np.mean(hydrophobic_counts)
print('%.1f'%average_neighbors)


