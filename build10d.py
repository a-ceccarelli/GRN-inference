import numpy as np
import pandas as pd
import os
import csv
import sys
from sklearn.cluster import KMeans
from sklearn.cluster import AgglomerativeClustering
from sklearn.decomposition import PCA
from matplotlib import colors as mcolors
import math
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt

print(sys.version)
cwd = os.getcwd()

os.chdir('../')
os.chdir('../')
cwd = os.getcwd()
print(cwd)

full = pd.read_csv('all_data_mRNA_counts.csv', header = 0)
cell = 'H0', 'H1', 'H2', 'V1', 'V2', 'V3', 'V4', 'V5', 'V6', 'T'
#this is all of them
#genes = 'cki-1', 'lin-26', 'lin-39', 'nhr-73', 'srf-3','vab-3', 'elt-1', 'egl-18','ceh-16'
#this one is reasonably good with a couple of other things in H2
#genes =  'egl-18','elt-1','lin-39','vab-3','ceh-16'
#lin-39 makes worse
#cki-1 makes worse
genes = 'elt-1','egl-18','vab-3','ceh-16'
points = np.ndarray([])
cell1 = list()
point_name = []
for a in range(10):
    c = cell[a]
    select_cell = full[full['Cell'] == c]
    for e in range(1,16):
        select_worm = select_cell[select_cell['Worm'] == e]
        for gene in genes:
            select_gene = select_worm[select_worm['Strain'] == gene]
            mRNA = select_gene['mRNA']
            mRNA = mRNA.values.tolist()
            mRNA = mRNA[0]
            cell1.append(mRNA)
        if e == 1 and a == 0:
            sets = pd.DataFrame([(cell1)], columns = genes)
        else:
            sets2 = pd.DataFrame([(cell1)], columns = genes )
            sets = pd.concat([sets,sets2],ignore_index = True)
        cell1 = list()
        name = str(c)+'-'+str(e)
        point_name.append(str(name))
sets['Point_Name'] = point_name
sets.set_index('Point_Name', inplace = True)

caymans = KMeans(n_clusters = 10)
caymans.fit(sets)
print(caymans.labels_)
print(len(caymans.labels_))
Cell_Cluster = caymans.labels_
listed = {'Cell Name':point_name, 'Cluster':Cell_Cluster}
cluster_list = pd.DataFrame(listed)
cluster_list.to_csv('cluster_list.csv', index = False)
print(caymans.inertia_)
pca = PCA(3)
pca.fit(sets)
pca_data = pd.DataFrame(pca.transform(sets))
print(pca_data.head())
colors = list(zip(*sorted((
                    tuple(mcolors.rgb_to_hsv(
                          mcolors.to_rgba(color)[:3])), name)
                     for name, color in dict(
                            mcolors.BASE_COLORS, **mcolors.CSS4_COLORS
                                                      ).items())))[1]
skips = math.floor(len(colors[5 : -5])/10)
cluster_colors = colors[5 : -5 : skips]
fig = plt.figure()
ax = fig.add_subplot(111, projection = '3d')
ax.scatter(pca_data[0], pca_data[1], pca_data[2],
           c = list(map(lambda label : cluster_colors[label],
                                            caymans.labels_)))

str_labels = list(map(lambda label:'% s' % label, point_name))

list(map(lambda data1, data2, data3, str_label:
        ax.text(data1, data2, data3, s = str_label, size = 5.5,
        zorder = 20, color = 'k'), pca_data[0], pca_data[1], pca_data[2], str_labels))
plt.show()
"""
highrakey = AgglomerativeClustering(n_clusters = 10)
highrakey.fit(sets)
print(highrakey.labels_)
"""
