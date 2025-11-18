# coding: utf-8
import re,gc 
import sys,os,time,math,string 
import numpy as np
np.set_printoptions(precision=3,suppress=True)

def calculate_ss(pdbfilename, simplified=True):
    '''
    The DSSP assignment codes are:
        H : Alpha helix
        B : Residue in isolated beta-bridge
        E : Extended strand, participates in beta ladder
        G : 3-helix (3/10 helix)
        I : 5 helix (pi helix)
        T : hydrogen bonded turn
        S : bend
          : Loops and irregular elements

    There are two ways to simplify 8-letter DSSP codes. 
    By default, the simplified DSSP codes in mdtraj are:
        H : Helix. Either of the H, G, or I codes.
        E : Strand. Either of the E, or B codes.
        C : Coil. Either of the T, S or ' ' codes.
    '''
    import mdtraj as md
    prot = md.load(pdbfilename)
    if simplified:
        return md.compute_dssp(prot, simplified=True)[0]
    return md.compute_dssp(prot, simplified=False)[0]

def find_continuous_number(seq):
    '''
    seq is in ascending order.
    '''
    full = np.arange(seq[0],seq[-1]+1)

    sseq = []
    for n in full:
        if n in seq:
            sseq.append('o')
        else:
            sseq.append('_')

    csseq = ''
    for m in re.finditer(r"o+",''.join(sseq)):
        if full[m.end()-1] > full[m.start()]:
            csseq += '%d-%d,' % (full[m.start()], full[m.end()-1])
        else:
            csseq += '%d,' % full[m.start()]

    return csseq.strip(',')

bsnm = lambda fpath: os.path.splitext(os.path.basename(fpath))[0]


def main():
    pdb = sys.argv[1]
    ss = calculate_ss(pdb)
    secseqHidx = np.where((ss=='H'))
    secseqEidx = np.where((ss=='E'))

    nH = 0
    if len(secseqHidx[0]) > 0:
        nH = len(find_continuous_number(secseqHidx[0]).split(','))

    nE = 0
    if len(secseqEidx[0]) > 0:
        nE = len(find_continuous_number(secseqEidx[0]).split(','))

    print(nH+nE)
    return nH + nE
                                  

if __name__ == "__main__":
    main()
