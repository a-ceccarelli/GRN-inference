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
matplotlib.rcParams['mathtext.fontset'] = 'stix'
matplotlib.rcParams['font.family'] = 'STIXGeneral'
os.chdir('/Users/alicja/Desktop/hbl-1_collab/lin-14_ptrobe_1051_ain-1_RNAi/tiffs/analyzed')
probe = 'lin-14'
length =  pd.read_csv(r'Worm_length_09-20-2022 19-45.csv', header = 0)

mRNA = pd.read_csv(r'mRNA_data 20220920T194546.csv', header = 0)
length = length.merge(mRNA,how ='left', on = 'Worm')
length.__delitem__('ROI_attribute')
length['Worm']= length['Worm'].map(str)
length['mRNA_per_mm3'] = length['mRNA_count']/(length['Worm Area (cubed uM)'])*10**9
length.to_csv(str(probe)+' all_values_and_length.csv',sep = ',', index = False)


"""
plt.axvline(x=150, color = 'gray', linestyle = '--')
plt.axvline(x=240, color = 'gray', linestyle = '--')
plt.axvline(x=330, color = 'gray', linestyle = '--')
plt.text(100, 37000000, 'L1', fontsize = 20, color = 'gray')
plt.text(175, 37000000, 'L2', fontsize = 20, color = 'gray')
plt.text(265, 37000000, 'L3', fontsize = 20, color = 'gray')
plt.text(365, 37000000, 'L4', fontsize = 20, color = 'gray')
"""
#sns.scatterplot(x = 'Worm length (uM)', y = 'mRNA_per_mm3', hue = 'Worm', data = length, palette = 'mako')
sns.scatterplot(x = 'Worm length (uM)', y = 'mRNA_per_mm3', data = length, color = 'black')
a = length['Worm length (uM)']
z = np.polyfit(a, length['mRNA_per_mm3'], 1)
p = np.poly1d(z)
plt.plot(a,p(a),"r")
plt.xlabel(r'Worm length ($\mu$m)')
#plt.legend(bbox_to_anchor = (1,1.05), fontsize = 8.5, title = 'Worm Number',ncol = 3)
plt.legend('',frameon=False)
plt.subplots_adjust(left=0.1, bottom=0.1, right=0.9, top=0.9, hspace = 0.1)
plt.ylabel(str(probe)+r' mRNA per mm$^3$')
#plt.yticks(0,50000000, step = 10000000)
plt.show()
