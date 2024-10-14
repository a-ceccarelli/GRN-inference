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

plt.rcParams['font.size'] = '18'

cells = 'H0','H1', 'H2', 'V1', 'V2', 'V3', 'V4','V5','V6', 'T'
cells10 = 'H0','H1', 'H2', 'V1', 'V2', 'V3', 'V4','V5a','V5p','V5','V6', 'T'
cells_d1 = 'H0','H1a','H1p', 'H2a','H2p', 'V1a','V1p', 'V2a','V2p', 'V3a', 'V3p','V4a','V4p','V5a','V5p','V6a','V6p', 'Ta', 'Tp'
cells_d2 = 'H0','H1a','H1p', 'H2a','H2p', 'V1aa','V1ap','V1pa','V1pp', 'V2aa','V2ap', 'V2pa','V2pp', 'V3aa', 'V3ap','V3pa', 'V3pp','V4aa','V4ap','V4pa','V4pp','V5aa','V5ap','V5pa','V5pp','V6aa','V6ap','V6pa','V6pp', 'Taa', 'Tap','Tpa', 'Tpp'

file = pd.read_csv(r'Elt-1_mRNA_JR667.csv', header = 0)
all = file[file['Strain'].isin(['WT(JR667)','ceh-16(bp323)'])]
all10= all[all['Time']== 10]
all26= all[all['Time']== 26]
all17= all[all['Time']== 17]
#"bisque","darkorange"
#"lightcoral","firebrick"
#"darkblue","skyblue", "lightcyan","darkblue"
Cell_ND = all26[all26['Cell'].isin(cells)]
Cell_D =all26[all26['Cell'].isin(cells_d1)]
Cell_DD = all26[all26['Cell'].isin(cells_d2)]
fig, (ax1, ax2, ax3, ax4) = plt.subplots(1,4, figsize=(18,4), sharey = True)
sns.boxplot(y = 'mRNA', x = 'Strain', data = all10, palette = {"bisque","darkorange"}, width = 0.5, showfliers=True,whis = 2.98, ax = ax1, showmeans = True, meanprops={"marker":"*", "markerfacecolor":"white", "markeredgecolor":"black", "markersize":"9"})
sns.boxplot(y = 'mRNA', x = 'Strain', data = all17, palette = {"bisque","darkorange"}, width = 0.5, showfliers=True,whis = 2.98, ax = ax2, showmeans = True, meanprops={"marker":"*", "markerfacecolor":"white", "markeredgecolor":"black", "markersize":"9"})
sns.boxplot(y = 'mRNA', x = 'Strain', data = Cell_D, palette = {"bisque","darkorange"}, width = 0.5, showfliers=True, ax = ax3, showmeans = True, meanprops={"marker":"*", "markerfacecolor":"white", "markeredgecolor":"black", "markersize":"9"})
sns.boxplot(y = 'mRNA', x = 'Strain', data = Cell_DD, palette = {"bisque","darkorange"}, width = 0.5, showfliers=True, ax = ax4, showmeans = True, meanprops={"marker":"*", "markerfacecolor":"white", "markeredgecolor":"black", "markersize":"9"})
ax1.set_ylabel(r'$\mathit{ceh-16 }$ mRNA counts at early L1', fontsize = 16, wrap = True)
ax2.set_ylabel(r'$\mathit{ceh-16 }$ mRNA counts at late L1',fontsize = 16, wrap = True)
ax3.set_ylabel(r'$\mathit{ceh-16 }$ mRNA counts at early L2',fontsize = 16, wrap = True)
ax4.set_ylabel(r'$\mathit{ceh-16 }$ mRNA counts at late L2',fontsize = 16, wrap = True)

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
def convert_pvalue_to_asterisks(pvalue):
    if pvalue <= 0.00001:
        return "****"
    elif pvalue <= 0.0001:
        return "***"
    elif pvalue <= 0.001:
        return "**"
    elif pvalue <= 0.01:
        return "*"
    return "ns"

a = all10
a10 = a[a['Strain']=='WT(JR667)']
b10 = a[a['Strain']=='ceh-16(bp323)']
stats1, pvalue_a10 = scipy.stats.mannwhitneyu(a10['mRNA'], b10['mRNA'])
pval_a10.append(pvalue_a10)

b = all17
a17 = b[b['Strain']=='WT(JR667)']
b17 = b[b['Strain']=='ceh-16(bp323)']
stats1, pvalue_a17 = scipy.stats.mannwhitneyu(a17['mRNA'], b17['mRNA'])
pval_a17.append(pvalue_a17)

c = Cell_D
a26a = c[c['Strain']=='WT(JR667)']
b26a = c[c['Strain']=='ceh-16(bp323)']
stats1, pvalue_a26a = scipy.stats.mannwhitneyu(a26a['mRNA'], b26a['mRNA'])
pval_a26a.append(pvalue_a26a)

d = Cell_DD
a26b = d[d['Strain']=='WT(JR667)']
b26b = d[d['Strain']=='ceh-16(bp323)']
stats1, pvalue_a26b = scipy.stats.mannwhitneyu(a26b['mRNA'], b26b['mRNA'])
pval_a26b.append(pvalue_a26b)
print(pval_a10)
for pvalues in pval_a10:
    pval_a10_star = convert_pvalue_to_asterisks(pvalues)
for pvalues in pval_a17:
    pval_a17_star = convert_pvalue_to_asterisks(pvalues)
for pvalues in pval_a26a:
    pval_a26a_star = convert_pvalue_to_asterisks(pvalues)
for pvalues in pval_a26b:
    pval_a26b_star = convert_pvalue_to_asterisks(pvalues)

y_position0 = file['mRNA'].max()

ax1.text(0.5,y_position0, str(pval_a10_star), horizontalalignment = 'center', fontsize = 14, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#080808')
ax2.text(0.5,y_position0, str(pval_a17_star), horizontalalignment = 'center', fontsize = 14, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#080808')
ax3.text(0.5,y_position0, str(pval_a26a_star), horizontalalignment = 'center', fontsize = 14, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#080808')
ax4.text(0.5,y_position0, str(pval_a26b_star), horizontalalignment = 'center', fontsize = 14, fontweight = 'bold', fontstretch = 'extra-condensed',color = '#080808')

plt.subplots_adjust(left=0.1, bottom=0.15, right=0.9, top=0.95, hspace = 0.5)
plt.show()
