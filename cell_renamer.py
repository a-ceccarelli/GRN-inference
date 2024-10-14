import sys
import pandas as pd
import numpy as np
import os
os.chdir('/Users/alicja/Desktop/elt-1_cy5_in_ceh_mut_26hrs/tiffs/analyzed')
file = pd.read_csv(r'mRNA_data 20220628T141149.csv', header = 0)
strain= 'ceh-16(bp323)'
probe = 'elt-1 cy5'
hours_of_development = 26
#assign the values you used for each cell kind in here
l1_cells = {'H0':'a','H1':'s','H2':'d','V1':'f','V2':'g','V3':'h','V4':'j','V5':['k','l'],'V6':'n','T':'m'}
l2_cells = {'V1':['h','j','k','l'],'V2':['n','m','t','y'],'V3':['u','i','o','p'],'V4':['1','2','3','5'],'V5':['6','7','8','9'],'V6':['0','e','v','b'],'T':['+','.','<','-']}
late_l1_cells = {'H0':'a','H1':'s','H2':'d','V1':'f','V2':'g','V3':'h','V4':'j','V5':'k','V6':'l','T':'n'}
#from here down its just automatic
worms = file['Worm'].values.ravel()
worms = pd.unique(worms)

if hours_of_development == 17:

    cells = 'H0','H1','H2','V1','V2','V3','V4','V5','V6','T'
    for worm in worms:
        set = file[file['Worm']==worm]
        for cell in cells:
            set['ROI_attribute'] = set['ROI_attribute'].replace({late_l1_cells[str(cell)]:str(cell)})
        file.update(set)

elif hours_of_development == 10:
    cells = 'H0','H1','H2','V1','V2','V3','V4','V6','T'
    for worm in worms:
        set = file[file['Worm']==worm]
        for cell in cells:
            set['ROI_attribute'] = set['ROI_attribute'].replace({l1_cells[str(cell)]:str(cell)})
        if (l1_cells['V5'][0] in set['ROI_attribute'].unique() and l1_cells['V5'][1] in set['ROI_attribute'].unique()):
            set['ROI_attribute'] = set['ROI_attribute'].replace({l1_cells['V5'][0]:'V5a',l1_cells['V5'][1]:'V5p'})
        elif l1_cells['V5'][1] in set['ROI_attribute'].unique():
            set['ROI_attribute'] = set['ROI_attribute'].replace({l1_cells['V5'][1]:'V5'})
        file.update(set)

elif hours_of_development == 26:
    cells = 'V1','V2','V3','V4','V6','T'
    for worm in worms:
        set = file[file['Worm']==worm]
        set['ROI_attribute'] = set['ROI_attribute'].replace({'a':'H0'})
        if 's' in set['ROI_attribute'].unique():
            set['ROI_attribute'] = set['ROI_attribute'].replace({'s':'H1a','d':'H1p'})
        elif 'd' in set['ROI_attribute'].unique():
            set['ROI_attribute'] = set['ROI_attribute'].replace({'d':'H1'})
        if 'f' in set['ROI_attribute'].unique():
            set['ROI_attribute'] = set['ROI_attribute'].replace({'f':'H2a','g':'H2p'})
        elif 'g' in set['ROI_attribute'].unique():
            set['ROI_attribute'] = set['ROI_attribute'].replace({'g':'H2'})
        if l2_cells['V5'][3] in set['ROI_attribute'].unique():
            if l2_cells['V5'][1] in set['ROI_attribute'].unique():
                if l2_cells['V5'][0] in set['ROI_attribute'].unique():
                    if l2_cells['V5'][2] in set['ROI_attribute'].unique():
                        set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells['V5'][0]:'V5aa',l2_cells['V5'][1]:'V5ap',l2_cells['V5'][2]:'V5pa',l2_cells['V5'][3]:'V5pp'})
                    else:
                        set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells['V5'][0]:'V5aa',l2_cells['V5'][1]:'V5ap',l2_cells['V5'][3]:'V5p'})
                elif l2_cells['V5'][2] in set['ROI_attribute'].unique():
                    set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells['V5'][1]:'V5a',l2_cells['V5'][2]:'V5pa',l2_cells['V5'][3]:'V5pp'})
                else:
                    set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells['V5'][1]:'V5a',l2_cells['V5'][3]:'V5p'})
            elif l2_cells['V4'][3] in set['ROI_attribute'].unique():
                if l2_cells['V4'][1] in set['ROI_attribute'].unique():
                    set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells['V5'][3]:'V5pp'})
            elif l2_cells['V6'][3] in set['ROI_attribute'].unique():
                if l2_cells['V6'][1] in set['ROI_attribute'].unique():
                    set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells['V5'][3]:'V5pp'})
            else:
                set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells['V5'][3]:'V5'})
        for cell in cells:
            if (l2_cells[str(cell)][0] in set['ROI_attribute'].unique() and l2_cells[str(cell)][2]) in set['ROI_attribute'].unique():
                set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells[str(cell)][0]:str(cell)+'aa',l2_cells[str(cell)][1]:str(cell)+'ap',l2_cells[str(cell)][2]:str(cell)+'pa',l2_cells[str(cell)][3]:str(cell)+'pp'})
            elif (l2_cells[str(cell)][0] in set['ROI_attribute'].unique() and l2_cells[str(cell)][3]) in set['ROI_attribute'].unique():
                set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells[str(cell)][0]:str(cell)+'aa',l2_cells[str(cell)][1]:str(cell)+'ap',l2_cells[str(cell)][3]:str(cell)+'p'})
            elif (l2_cells[str(cell)][1] in set['ROI_attribute'].unique() and l2_cells[str(cell)][2]) in set['ROI_attribute'].unique():
                set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells[str(cell)][1]:str(cell)+'a',l2_cells[str(cell)][2]:str(cell)+'pa',l2_cells[str(cell)][3]:str(cell)+'pp'})
            elif l2_cells[str(cell)][1] in set['ROI_attribute'].unique() and l2_cells[str(cell)][3] in set['ROI_attribute'].unique():
                set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells[str(cell)][1]:str(cell)+'a',l2_cells[str(cell)][3]:str(cell)+'p'})
            elif l2_cells[str(cell)][3] in set['ROI_attribute'].unique():
                set['ROI_attribute'] = set['ROI_attribute'].replace({l2_cells[str(cell)][3]:str(cell)})
        file.update(set)


file.columns = ['Cell','Worm','mRNA']
file = file[file['Cell']!=',']
file = file[file['Cell']!='r']
print(file)
file.to_csv(str(probe)+'_at_'+str(hours_of_development)+'_in_'+str(strain)+'.csv', index = False, header = True)
