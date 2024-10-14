import sys
print(sys.version)

import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import os
import seaborn as sns
import itertools

cwd = os.getcwd()
cwd = os.getcwd()
os.chdir("/Users/alicja/Desktop")
#os.chdir("/Volumes/Seagate Backup Plus Drive/10_hours/Probe-egl-18cy5+elt-1RED")
#print(cwd)
#Change the file name
h1_ND = []
h1_D = []
file = pd.read_csv(r'Cell_measurements_with_mRNA2.csv', header = 0)
cells = 'H0','H1','H2','V1','V2','V3','V4','V5','V6','T'
#anti_cells = 'H1', 'H2'
sorted = list()
cellies = list()
worm = list ()
#cells = 'H1','H2'

for cell in cells:
    if cell == 'H0':
        anterior =  '',
        print('b')
    elif cell == 'H1'or cell =='H2':
        anterior =  '', 'a', 'p'
        print('a')
    else:
        anterior = '','a','p','aa','ap','pa','pp'
        print('c')
    for anti in anterior:
        Cell_ND = file[file[str(cell)+str(anti)].notna()]

        """
        Cell_D = file[file[str(cell)+'a'].notna()]
        Cell_AD = file[file[str(cell)+'aa'].notna()]
        Cell_PD = file[file[str(cell)+'pa'].notna()]
        sorted.append((Cell_ND[str(cell)]).tolist())
        for bla in range(len(Cell_ND[str(cell)])):
            cellies.append(str(cell))
        """
        sorted.append((Cell_ND[str(cell)+str(anti)]).tolist())
        worm.append((Cell_ND['Worm']).tolist())
        for bla in range(len(Cell_ND[str(cell)+str(anti)])):
            cellies.append(str(cell+str(anti)))


    #sorted.append(Cell_ND)
sorted = list(itertools.chain.from_iterable(sorted))
worm = list(itertools.chain.from_iterable(worm))
print(sorted)
print(cellies)
print(worm)
zipped = list(zip(worm, sorted, cellies))
mRNA = pd.DataFrame(zipped, columns = ['Worm', 'mRNA', 'Cell'])
print(mRNA)
mRNA.to_csv('ceh-16_in_JR667_at_26_hours.csv', header = True, index = False )
