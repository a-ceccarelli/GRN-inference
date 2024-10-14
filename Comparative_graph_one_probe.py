
import os

import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib import rc
from matplotlib import rcParams
from matplotlib.font_manager import FontProperties
import scipy
from statannot import add_stat_annotation

os.chdir('/Users/alicja/Desktop/PhD_Year_1/old_data_17hrs')
cwd = os.getcwd()
print(cwd)

matplotlib.rcParams['mathtext.fontset'] = 'stix'
matplotlib.rcParams['font.family'] = 'STIXGeneral'
#matplotlib.rc('text', usetex = True)
cells = 'H0','H1', 'H2', 'V1', 'V2', 'V3', 'V4','V5','V6', 'T'
cells10 = 'H0','H1', 'H2', 'V1', 'V2', 'V3', 'V4','V5a','V5p','V5','V6', 'T'
cells_ante = 'H1a', 'H2a', 'V1a', 'V1aa', 'V2a', 'V2aa', 'V3a', 'V3aa', 'V4a', 'V4aa', 'V5a', 'V5aa', 'V6a', 'V6aa', 'Ta', 'Taa'
cells_poste = 'H1p', 'H2p', 'V1p', 'V1pp', 'V2p', 'V2pp', 'V3p', 'V3pp', 'V4p', 'V4pp', 'V5p', 'V5pp', 'V6p', 'V6pp', 'Tp', 'Tpp'
cells_paired = {'H1':['H1a','H1p'],'H2':['H2a','H2p'],'V1':['V1a','V1p'],'V2':['V2a','V2p'],'V3':['V3a','V3p'],'V4':['V4a','V4p'],'V5':['V5a','V5p'],'V6':['V6a','V6p'],'T':['Ta','Tp']}
#Enter filename

#all = pd.read_csv(r'Ceh-16_probe_all.csv', header = 0)
file = pd.read_csv(r'Ceh-16_probe_all.csv', header = 0)

#all = file[file['Strain'] == 'WT(JR667)'and'ceh-16(bp323)']
all = file[file['Strain'].isin(['WT(JR667)','ceh-16(bp323)'])]
#file = file[file['Time'] == 26]

#all2 = pd.read_csv(r'Egl-18_mRNA_JR667.csv', header = 0)
#all1 = all1[all1['Strain']!='ku491']
#wt = all[all['Strain'] == 'WT(JR667)']
#mut = all[all['Strain'] == 'ceh-16(bp323)']
all10= all[all['Time']== 10]
all26= all[all['Time']== 26]
all17= all[all['Time']== 17]


cells_d1 = 'H0','H1a','H1p', 'H2a','H2p', 'V1a','V1p', 'V2a','V2p', 'V3a', 'V3p','V4a','V4p','V5a','V5p','V6a','V6p', 'Ta', 'Tp'
cells_d2 = 'H0','H1a','H1p', 'H2a','H2p', 'V1aa','V1ap','V1pa','V1pp', 'V2aa','V2ap', 'V2pa','V2pp', 'V3aa', 'V3ap','V3pa', 'V3pp','V4aa','V4ap','V4pa','V4pp','V5aa','V5ap','V5pa','V5pp','V6aa','V6ap','V6pa','V6pp', 'Taa', 'Tap','Tpa', 'Tpp'
Cell_ND = all26[all26['Cell'].isin(cells)]
Cell_D =all26[all26['Cell'].isin(cells_d1)]

Cell_DD = all26[all26['Cell'].isin(cells_d2)]
fig, (ax1, ax2, ax3, ax4) = plt.subplots(4,1, figsize=(16,9), sharey = True)
#fig, ax2 = plt.subplots(1,1, figsize=(10,8))

sns.boxplot(y = 'mRNA', x = 'Cell', hue = 'Strain',order = cells10 , data = all10, palette = {"bisque","darkorange"}, width = 0.5, showfliers=True,whis = 2.98, ax = ax1)
sns.boxplot(y = 'mRNA', x = 'Cell', hue= 'Strain', order = cells , data = all17, palette = {"lightcoral","firebrick"}, width = 0.5, showfliers=True,whis = 2.98, ax = ax2)
#ax2, test_results = add_stat_annotation(ax2, data=all, y = 'mRNA', x = 'Seam_cell',hue = 'Strain', order = cells, box_pairs=[(('WT(JR667),str(cell)','ceh-16(bp323);egl-18(ga97)')) test='Mann-Whitney', text_format='star', loc='outside', verbose=2)
sns.boxplot(y = 'mRNA', x = 'Cell', hue = 'Strain',order = cells_d1, data = Cell_D, palette = {"darkblue","skyblue"}, width = 0.5, showfliers=True, ax = ax3)
sns.boxplot(y = 'mRNA', x = 'Cell', hue = 'Strain',order = cells_d2, data = Cell_DD, palette = {"thistle","darkmagenta"}, width = 0.5, showfliers=True, ax = ax4)
ax1.set_ylabel(r'$\mathit{ceh-16 }$ mRNA counts at early L1', fontsize = 14, wrap = True)
ax2.set_ylabel(r'$\mathit{ceh-16 }$ mRNA counts at late L1',fontsize = 14, wrap = True)
ax3.set_ylabel(r'$\mathit{ceh-16 }$ mRNA counts at early L2',fontsize = 14, wrap = True)
ax4.set_ylabel(r'$\mathit{ceh-16 }$ mRNA counts at late L2',fontsize = 14, wrap = True)
ax1.set_xlabel('Seam Cell')

ax2.set_xlabel('Seam Cell')

ax3.set_xlabel('Seam Cell')
ax4.set_xlabel('Seam Cell')
ax1.legend(title = 'Strain', prop={'size': 10, 'style': 'italic'},loc = 'lower center', bbox_to_anchor = (0.5,-0.55), ncol = 2)
ax2.legend(title = 'Strain', prop={'size': 10, 'style': 'italic'},loc = 'lower center',bbox_to_anchor = (0.5,-0.55), ncol = 2)
ax3.legend(title = 'Strain', prop={'size': 10, 'style': 'italic'},loc = 'lower center', bbox_to_anchor = (0.5,-0.55), ncol = 2)
ax4.legend(title = 'Strain', prop={'size': 10, 'style': 'italic'},loc = 'lower center', bbox_to_anchor = (0.5,-0.55), ncol = 2)
#ax2.set_ylim([0, file['mRNA'].max()*1.25])

#bplot = sns.boxplot(data = (mut, wild), x = 'Cell', y = 'mRNA', showcaps=False, boxprops = {'facecolor':'None', 'zorder':10}, showfliers=False ,showmeans = True, meanprops={"marker":"s", "markerfacecolor":"white",  "markeredgecolor":"black","markersize":"3"},whiskerprops={'linewidth':0, "zorder":10}, ax = ax2, width = 0.5)
#bplot = sns.stripplot(y = 'mRNA', x = 'Cell', hue = 'Worm', data = (probe_ceh, probe_elt), jitter = True, marker = 'o', size = 4, palette = 'Spectral')

#plt.ylabel('ceh-16 cy5 mRNA levels in triple hox mutants')
#plt.legend(bbox_to_anchor = (1, 0.75), fontsize = 10, title = 'Probe')

pval_a10 = []
pval_b10 = []
pval_a17 = []
pval_b17 = []
pval_a26a = []
pval_b26a = []
pval_a26b = []
pval_b26b = []
pval_a10_star = list()
pval_b10_star = list()
pval_a17_star = list()
pval_b17_star = list()
pval_a26a_star = list()
pval_b26a_star = list()
pval_a26b_star = list()
pval_b26b_star = list()
"""
pvalues_ceh_in_egl = []
pvalues_egl_in_ceh = []

pvalues_elt_in_cehegl = []
pvalues_elt_in_egl = []
pvalues_elt_in_ceh = []
pvalues_elt_in_cehegl2 = []




pvalues_ceh_in_elt = []




pvalues_ceh_in_egl_star = list()

pvalues_egl_in_elt = []



pvalues_ceh_in_elt_star = list()


pvalues_elt_in_egl_star = list()
pvalues_elt_in_ceh_star = list()
pvalues_egl_in_ceh_star = list()

pvalues_egl_in_elt_star = list()


pvalues_elt_in_cehegl_star = list()
pvalues_elt_in_cehegl2_star = list()
"""
def convert_pvalue_to_asterisks(pvalue):
    if pvalue <= 0.0001:
        return "****"
    elif pvalue <= 0.001:
        return "***"
    elif pvalue <= 0.01:
        return "**"
    elif pvalue <= 0.05:
        return "*"
    return "ns"

for cell in cells10:

    a = all10[all10['Cell']==cell]
    a10 = a[a['Strain']=='WT(JR667)']
    b10 = a[a['Strain']=='ceh-16(bp323)']
    stats1, pvalue_a10 = scipy.stats.mannwhitneyu((a10['mRNA']), (b10['mRNA']))
    pval_a10.append(pvalue_a10)
    #a3 = a[a['Strain']=='elt-1(ku491)']

    #stats2, pvalue_ceh_in_elt = scipy.stats.mannwhitneyu((a1['mRNA']), (a3['mRNA']))
    #pvalues_ceh_in_elt.append(pvalue_ceh_in_elt)

for cell in cells:
    b = all17[all17['Cell']==cell]
    a17 = b[b['Strain']=='WT(JR667)']
    b17 = b[b['Strain']=='ceh-16(bp323)']
    stats1, pvalue_a17 = scipy.stats.mannwhitneyu((a17['mRNA']), (b17['mRNA']))
    pval_a17.append(pvalue_a17)
for cell in cells_d1:
    c = Cell_D[Cell_D['Cell']==cell]
    a26a = c[c['Strain']=='WT(JR667)']
    b26a = c[c['Strain']=='ceh-16(bp323)']
    stats1, pvalue_a26a = scipy.stats.mannwhitneyu((a26a['mRNA']), (b26a['mRNA']))
    pval_a26a.append(pvalue_a26a)
    """
    b = file[file['Seam_Cell']==cell]
    b1 = b[b['Strain']=='WT(JR667)']
    b2 = b[b['Strain']=='egl-18(ga97)']
    b3 = b[b['Strain']=='elt-1(ku491)']
    b4 = b[b['Strain']=='ceh-16(bp323)']
    b5 = b[b['Strain']=='ceh-16(bp323);egl-18(ga97)']

    stats3, pvalue_elt_in_egl = scipy.stats.mannwhitneyu((b5['mRNA']), (b2['mRNA']))
    pvalues_elt_in_egl.append(pvalue_elt_in_egl)

    stats4, pvalue_elt_in_ceh = scipy.stats.mannwhitneyu((b5['mRNA']), (b3['mRNA']))
    pvalues_elt_in_ceh.append(pvalue_elt_in_ceh)
    stats5, pvalue_elt_in_cehegl = scipy.stats.mannwhitneyu((b5['mRNA']), (b4['mRNA']))
    stats5, pvalue_elt_in_cehegl2 = scipy.stats.mannwhitneyu((b1['mRNA']), (b5['mRNA']))
    pvalues_elt_in_cehegl.append(pvalue_elt_in_cehegl)
    pvalues_elt_in_cehegl2.append(pvalue_elt_in_cehegl2)
    print(pvalues_elt_in_cehegl)
"""
for cell in cells_d2:
    c = Cell_DD[Cell_DD['Cell']==cell]
    a26b = c[c['Strain']=='WT(JR667)']
    #c2 = c[c['Strain']=='elt-1(ku491)']
    b26b = c[c['Strain']=='ceh-16(bp323)']
    #stats5, pvalue_egl_in_elt = scipy.stats.mannwhitneyu((c1['mRNA']), (c2['mRNA']))
    #pvalues_egl_in_elt.append(pvalue_egl_in_elt)
    stats1, pvalue_a26b = scipy.stats.mannwhitneyu((a26b['mRNA']), (b26b['mRNA']))
    pval_a26b.append(pvalue_a26b)
for pvalues in pval_a10:
    pval_a10_star.append(convert_pvalue_to_asterisks(pvalues))
for pvalues in pval_a17:
    pval_a17_star.append(convert_pvalue_to_asterisks(pvalues))
for pvalues in pval_a26a:
    pval_a26a_star.append(convert_pvalue_to_asterisks(pvalues))
for pvalues in pval_a26b:
    pval_a26b_star.append(convert_pvalue_to_asterisks(pvalues))
"""
for pvalues in pvalues_egl_in_ceh:
    pvalues_egl_in_ceh_star.append(convert_pvalue_to_asterisks(pvalues))

for pvalues in pvalues_ceh_in_elt:
    pvalues_ceh_in_elt_star.append(convert_pvalue_to_asterisks(pvalues))

for pvalues in pvalues_elt_in_egl:
    pvalues_elt_in_egl_star.append(convert_pvalue_to_asterisks(pvalues))
for pvalues in pvalues_elt_in_ceh:
    pvalues_elt_in_ceh_star.append(convert_pvalue_to_asterisks(pvalues))


for pvalues in pvalues_egl_in_elt:
    pvalues_egl_in_elt_star.append(convert_pvalue_to_asterisks(pvalues))


pvalues_pair_wt =[]
pvalues_pair_wt_star =list()
pvalues_pair_mut = []
pvalues_pair_mut_star =list()

for cell in cells:
    wt = file[file['Strain']=='WT(JR667)']
    wt1 = wt[wt['Seam_Cell']==cells_paired[cell][0]]
    wt2 = wt[wt['Seam_Cell']==cells_paired[cell][1]]
    stats5, pvalue_pair_wt = scipy.stats.mannwhitneyu((wt1['mRNA']), (wt2['mRNA']))
    pvalues_pair_wt.append(pvalue_pair_wt)
    mut = file[file['Strain']=='ceh-16(bp323);egl-18(ga97)']
    mut1 = mut[mut['Seam_Cell']==cells_paired[cell][0]]
    mut2 = mut[mut['Seam_Cell']==cells_paired[cell][1]]
    stats5, pvalue_pair_mut = scipy.stats.mannwhitneyu((mut1['mRNA']), (mut2['mRNA']))
    pvalues_pair_mut.append(pvalue_pair_mut)
for pvalues in pvalues_pair_wt:
    pvalues_pair_wt_star.append(convert_pvalue_to_asterisks(pvalues))
for pvalues in pvalues_pair_mut:
    pvalues_pair_mut_star.append(convert_pvalue_to_asterisks(pvalues))


for pvalues in pvalues_elt_in_ceh:
    pvalues_elt_in_ceh_star.append(convert_pvalue_to_asterisks(pvalues))

for pvalues in pvalues_elt_in_egl:
    pvalues_elt_in_egl_star.append(convert_pvalue_to_asterisks(pvalues))
for pvalues in pvalues_elt_in_cehegl:
    pvalues_elt_in_cehegl_star.append(convert_pvalue_to_asterisks(pvalues))
for pvalues in pvalues_elt_in_cehegl2:
    pvalues_elt_in_cehegl2_star.append(convert_pvalue_to_asterisks(pvalues))
"""
y_position0 = file['mRNA'].max()
y_position1 = file['mRNA'].max()*1.07
y_position2 = file['mRNA'].max()*1.04
y_position3 = file['mRNA'].max()*1.01

for i in range (0,(len(cells10))):
    ax1.text(i,y_position0, str(pval_a10_star[i]), horizontalalignment = 'center', fontsize = 11, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#080808')
for i in range (0,(len(cells))):
    ax2.text(i,y_position0, str(pval_a17_star[i]), horizontalalignment = 'center', fontsize = 11, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#080808')
print(len(pval_a26a_star))
for i in range (0,(len(cells_d1))):
    ax3.text(i,y_position0, str(pval_a26a_star[i]), horizontalalignment = 'center', fontsize = 11, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#080808')
for i in range (0,(len(cells_d2))):
    ax4.text(i,y_position0, str(pval_a26b_star[i]), horizontalalignment = 'center', fontsize = 11, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#080808')

"""
for i in range (0,(len(cells_d1)),2):
    a = ((2*i)+1)/2
    e = int(i/2)
    ax2.text(a-0.15,y_position2, str(pvalues_pair_wt_star[e]), horizontalalignment = 'center', fontsize = 11, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#b3cede')
    ax2.text(a+0.15,y_position3, str(pvalues_pair_mut_star[e]), horizontalalignment = 'center', fontsize = 11, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#4884af')
    #ax2.text(i,y_position1, str(pvalues_elt_in_cehegl_star[i]), horizontalalignment = 'center', fontsize = 11, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#398c5b')
    #ax2.text(i,y_position2, str(pvalues_elt_in_ceh_star[i]), horizontalalignment = 'center', fontsize = 11, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#8ec492')

    #ax3.text(i,y_position1, str(pvalues_egl_in_elt_star[i]), horizontalalignment = 'center', fontsize = 11, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#c34341')
    #ax3.text(i,y_position2, str(pvalues_egl_in_ceh_star[i]), horizontalalignment = 'center', fontsize = 11, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#ec8c72')

y_position = file['mRNA'].max() * 1.2
for idx, pval in enumerate(pvalues_elt_in_cehegl_star):
    plt.text(x=idx, y=y_position, s=pval)

"""
plt.subplots_adjust(left=0.1, bottom=0.05, right=0.9, top=0.95, hspace = 0.5)
plt.show()
