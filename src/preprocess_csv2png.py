# -*- coding: utf-8 -*-
import os
import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
from functions import csv2img3
# from src.functions import csv2img3

# Arguments
args = sys.argv
infile1 = args[1]
infile2 = args[2]
infile3 = args[3]
infile4 = args[4]
infile5 = args[5]
infile6 = args[6]
outfile1 = args[7]
outfile2 = args[8]
logtransform = int(args[9])
# infile1 = 'data/public_neg_trs_1/source/sum_exp.csv'
# infile2 = 'data/public_neg_trs_1/target/sum_exp.csv'
# infile3 = 'data/public_neg_trs_1/source/x.csv'
# infile4 = 'data/public_neg_trs_1/target/x.csv'
# infile5 = 'data/public_neg_trs_1/source/y.csv'
# infile6 = 'data/public_neg_trs_1/target/y.csv'

# Loading
source_exp = np.loadtxt(infile1)
target_exp = np.loadtxt(infile2)
source_x_coordinate = np.loadtxt(infile3, dtype='int')
target_x_coordinate = np.loadtxt(infile4, dtype='int')
source_y_coordinate = np.loadtxt(infile5, dtype='int')
target_y_coordinate = np.loadtxt(infile6, dtype='int')

# Log-transformation
if logtransform:
    source_exp = np.log10(source_exp + 1)
    target_exp = np.log10(target_exp + 1)

# CSV => PNG
## source_exp
tmp_data = csv2img3(source_y_coordinate, source_x_coordinate, source_exp)
fig = plt.figure(dpi=100, figsize=(50,50))
ax = fig.add_subplot(111)
plt.axis('off')
ax.set_frame_on(False)
plt.imshow(tmp_data, cmap='gray')
plt.savefig(outfile1)

## target_exp
tmp_data = csv2img3(target_y_coordinate, target_x_coordinate, target_exp)
fig = plt.figure(dpi=100, figsize=(50,50))
ax = fig.add_subplot(111)
plt.axis('off')
ax.set_frame_on(False)
plt.imshow(tmp_data, cmap='gray')
plt.savefig(outfile2)
