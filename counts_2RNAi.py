import numpy as np
import pandas as pd
import os
import csv
import sys
import seaborn as sns
import matplotlib.pyplot as plt
import mpl_toolkits.axes_grid1
import matplotlib
from matplotlib import rc
from scipy.stats import mannwhitneyu
from scipy import stats
from matplotlib import rcParams
from matplotlib.font_manager import FontProperties

matplotlib.rcParams['mathtext.fontset'] = 'stix'
matplotlib.rcParams['font.family'] = 'STIXGeneral'
os.chdir('/Users/alicja/Desktop/PhD_Year_1/Seam_cell_counts')
cwd = os.getcwd()
print(cwd)
blub = ()
csv_strain_names = 'ceh-16(bp323);egl-18(ga97)', 'ceh-16;cre-lox'
names = 'ceh-16(bp323);egl-18(ga97)', 'ceh-16 cre lox'
colnames = 'ceh-16(bp323);egl-18(ga97)','ceh-16 cre lox'
factor = 'RNAi'

b = 'egl-18'
a = 'ht115'
factor_list = a,b
All = pd.read_csv('20220308_RNAi_ht115_egl-18_on_ceh-cre_cehegl.csv', header = 0)
y = 27
min = 0
strain1_2 = All[All['Strain']==csv_strain_names[0]][All[factor]==b]
strain1 = All[All['Strain']==csv_strain_names[0]][All[factor]==a]
strain2 = All[All['Strain']==csv_strain_names[1]][All[factor]==a]
strain2_2 = All[All['Strain']==csv_strain_names[1]][All[factor]==b]
strain1 = strain1['ScM']
strain1_2 = strain1_2['ScM']
strain2 = strain2['ScM']
strain2_2 = strain2_2['ScM']
fig,ax = plt.subplots()
ax2 = ax.twiny()
ax.set_xlim(0)
ax2.set_xlim(0)
sns.boxplot(data= (strain1 ,blub, strain2,blub), showcaps=False, boxprops = {'facecolor':'None', 'zorder':10}, showfliers=False ,showmeans = True, meanprops={"marker":"s", "markerfacecolor":"white",  "markeredgecolor":"black","markersize":"3"},whiskerprops={'linewidth':0, "zorder":10}, ax = ax2, width = 0.5)
sns.boxplot(data = (blub,strain1_2,blub, strain2_2), showcaps=False, boxprops = {'facecolor':'None', 'zorder':10}, showfliers=False ,showmeans = True, meanprops={"marker":"s", "markerfacecolor":"white",  "markeredgecolor":"black","markersize":"3"},whiskerprops={'linewidth':0, "zorder":10}, ax = ax2, width = 0.5)
sns.swarmplot(data = (strain1,blub, strain2,blub),color = 'white',  size = 2, dodge = True, edgecolor= 'black', linewidth =  0.5 , zorder = 2, ax = ax2)
sns.swarmplot(data = (blub,strain1_2,blub, strain2_2),color = 'white',  size = 2, dodge = True, edgecolor= 'black', linewidth =  0.5 , zorder = 2, ax = ax2)
ax.set_xticks(range(20))
ax2.set_xticks(range(len(names)))
ax = sns.violinplot(x= 'Strain', y = 'ScM', hue =factor ,data= All, order = csv_strain_names, scale = 'count', scale_hue = True, palette=sns.color_palette(['lightblue', 'cornflowerblue']), cut = 0, inner=None, orient='v', width = 1, dodge = True, zorder = 0, ax = ax)
named = '',''
#ax.set_xticklabels(names, style = 'italic', wrap = True,  y = 0, fontsize = 9)
ax.set_xticklabels(names, wrap = True,  y = 0, fontsize = 10, style = 'italic')
ax2.set_xticklabels(named)
ax2.set_xlabel('')
ax2.set_yticks(range(min,y,2))
ax2.tick_params(length = 0)
ax.set_yticks(range(min,y,2))
plt.yticks(range(min,y,2))
ax.set_xlabel('Strain', fontsize = 11)
ax.set_ylabel('Seam Cell Number', fontsize = 11)

plt.subplots_adjust(bottom = 0.25)
plt.show()
