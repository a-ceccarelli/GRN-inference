
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

worms = file['Worm'].values.ravel()
worms = pd.unique(worms)
