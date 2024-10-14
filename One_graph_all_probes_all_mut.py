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
cells = 'H0','H1', 'H2', 'V1', 'V2', 'V3', 'V4','V5','V6', 'T'

file_ceh = pd.read_csv(r'Ceh-16_probe_all.csv', header = 0)
file_egl = pd.read_csv(r'Egl-18_mRNA_JR667.csv', header = 0)
file_elt = pd.read_csv(r'Elt-1_mRNA_JR667.csv', header = 0)
file_ceh = file_ceh[file_ceh['Time']== 17]
file_egl = file_egl[file_egl['Time']== 17]
file_elt = file_elt[file_elt['Time']== 17]
files = file_ceh.append(file_egl)
files = files.append(file_elt)
files = files[files['Strain'].isin(['WT(JR667)','elt-1(ku491)','egl-18(ga97)','ceh-16(bp323)'])]
sns.catplot(x = 'Cell', y = 'mRNA', hue = 'Strain', col = 'Probe', data = files, kind = 'box', palette = 'magma', legend = False)
plt.legend(loc = 'lower center', ncol = 4, title = 'Strain')
pval_elt_in_elt = []
pval_elt_in_egl= []
pval_elt_in_ceh = []
pval_egl_in_elt = []
pval_egl_in_egl= []
pval_egl_in_ceh = []
pval_ceh_in_elt = []
pval_ceh_in_egl= []
pval_ceh_in_ceh = []
pval_elt_in_elt_star = list()
pval_elt_in_egl_star = list()
pval_elt_in_ceh_star = list()
pval_egl_in_elt_star = list()
pval_egl_in_egl_star = list()
pval_egl_in_ceh_star = list()
pval_ceh_in_elt_star = list()
pval_ceh_in_egl_star = list()
pval_ceh_in_ceh_star = list()
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
probes = 'elt-1', 'egl-18', 'ceh-16'
strains = 'WT(JR667)', 'elt-1(ku491)', 'egl-18(ga97)', 'ceh-16(bp323)'
pval_elt = pval_elt_in_elt, pval_elt_in_egl, pval_elt_in_ceh
pval_egl = pval_egl_in_elt, pval_egl_in_egl, pval_egl_in_ceh
pval_ceh = pval_ceh_in_elt, pval_ceh_in_egl, pval_ceh_in_ceh
pval = pval_elt, pval_egl, pval_ceh
for probe in probes:
    file_probe = files[files['Probe']==probe
    probe_index = probes.index(probe)
    print(pval_probe)
    for strain in strains:
        for cell in cells:





        ceh_cell = [file_ceh['Cell']==cell]
        ceh_in_WT = ceh_cell[ceh_cell['Strain']=='WT(JR667)']
        ceh_in_elt = ceh_cell[ceh_cell['Strain']=='elt-1(ku491)']
        ceh_in_egl = ceh_cell[ceh_cell['Strain']=='egl-18(ga97)']
        ceh_in_ceh = ceh_cell[ceh_cell['Strain']=='ceh-16(bp323)']
        stats1, pvalue_ceh_in_elt = scipy.stats.mannwhitneyu((ceh_in_WT['mRNA']), (ceh_in_elt['mRNA']))
        pval_ceh_in_elt.append(pvalue_ceh_in_elt)
        stats1, pvalue_ceh_in_egl = scipy.stats.mannwhitneyu((ceh_in_WT['mRNA']), (ceh_in_egl['mRNA']))
        pval_ceh_in_egl.append(pvalue_ceh_in_egl)
        stats1, pvalue_ceh_in_ceh = scipy.stats.mannwhitneyu((ceh_in_WT['mRNA']), (ceh_in_ceh['mRNA']))
        pval_ceh_in_ceh.append(pvalue_ceh_in_ceh)


plt.show()
