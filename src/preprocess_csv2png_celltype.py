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

# Loading
source_celltype = pd.read_csv(infile1, header=0)
target_celltype = pd.read_csv(infile2, header=0)
source_x_coordinate = np.loadtxt(infile3, dtype='int')
target_x_coordinate = np.loadtxt(infile4, dtype='int')
source_y_coordinate = np.loadtxt(infile5, dtype='int')
target_y_coordinate = np.loadtxt(infile6, dtype='int')

# Setting
outdir1 = outfile1.replace("FINISH_celltype", "")
outdir2 = outfile2.replace("FINISH_celltype", "")

# CSV => PNG
## source_exp
for celltype in source_celltype.columns:
    print(celltype)
    tmp_data = csv2img3(source_x_coordinate, source_y_coordinate, source_celltype[celltype])
    tmp_file = outdir1 + celltype + ".png"
    fig = plt.figure(dpi=100, figsize=(50,50))
    ax = fig.add_subplot(111)
    plt.axis('off')
    ax.set_frame_on(False)
    plt.imshow(tmp_data, cmap='gray')
    plt.savefig(tmp_file)

## target_exp
for celltype in target_celltype.columns:
    print(celltype)
    tmp_data = csv2img3(target_x_coordinate, target_y_coordinate, target_celltype[celltype])
    tmp_file = outdir2 + celltype + ".png"
    fig = plt.figure(dpi=100, figsize=(50,50))
    ax = fig.add_subplot(111)
    plt.axis('off')
    ax.set_frame_on(False)
    plt.imshow(tmp_data, cmap='gray')
    plt.savefig(tmp_file)

# FINISH
open(outfile1, 'w').close()
open(outfile2, 'w').close()
