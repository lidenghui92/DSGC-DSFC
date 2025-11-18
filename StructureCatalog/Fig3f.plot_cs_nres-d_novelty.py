import os, sys
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1.inset_locator import inset_axes

# 10.nonhit_exhaustive_HM_domain_cs_nres_domnres_plddt_nss_packing_novelty_sorted.dat
input_dat = sys.argv[1]

data = pd.read_csv(input_dat, sep='\s+', header=None, 
        names=['domain', 'cluster_size', 'nres', 'domain_nres', 'plddt', 'nss', 'packing', 'novelty'])

fig, ax = plt.subplots(figsize=(5, 5))
scatter = ax.scatter(data['novelty'], data['cluster_size'], c=data['domain_nres'],
                     s=5, cmap='YlGnBu_r')

ax.set_xlim(0, 100)
ax.set_ylim(0.8, 1000)

ax.set_yscale('log')
axins = inset_axes(ax,
                   width="70%",   
                   height="10%",  
                   loc='upper left',
                   bbox_to_anchor=(0.05, 0.7, 0.2, 0.2),
                   bbox_transform=ax.transAxes,
                   borderpad=0,
                   )

cbar = fig.colorbar(scatter, cax=axins, orientation="horizontal")
scatter.set_clim(0, 900)
cbar.set_ticks([0, 800])

axins.xaxis.set_ticks_position("top")
axins.xaxis.set_label_position("top")

plt.tight_layout()
plt.savefig('./novelty_nres-d_cs.png', format='png', dpi=600)
plt.savefig('./novelty_nres-d_cs.pdf', format='pdf')
