import os
import shutil
print(os.getcwd())

#os.chdir('/Users/alicja/Desktop/elt-1_cy5_in_ceh_mut_26hrs')
#os.makedirs('tiffs')
os.chdir('/Users/alicja/Desktop/elt-1_cy5_in_ceh_mut_26hrs/C3')

for filename in os.listdir():
    if 'tif' in str(filename):
    #if 'c3' in str(filename):
        shutil.move(filename,'/Users/alicja/Desktop/elt-1_cy5_in_ceh_mut_26hrs/tiffs')

"""
for x in range(18,42):
    print(x)
    print('a'+str(x-1))
    os.rename('GFP0'+str(x)+'.tif', 'GFP0'+str(x-1)+'.tif')
"""
