# -*- coding: utf-8 -*-
import sys
import numpy as np
from PIL import Image
import pandas as pd

# Arguments
args = sys.argv
infile3 = args[3]
infile4 = args[4]
infile5 = args[5]
infile6 = args[6]
outfile1 = args[7]
outfile2 = args[8]
# infile3 = 'data/public_neg_trs_1/source/x_resize.csv'
# infile4 = 'data/public_neg_trs_1/target/x_resize.csv'
# infile5 = 'data/public_neg_trs_1/source/y_resize.csv'
# infile6 = 'data/public_neg_trs_1/target/y_resize.csv'

# Loading
source_x_coordinate = np.loadtxt(infile3, dtype="int")
target_x_coordinate = np.loadtxt(infile4, dtype="int")
source_y_coordinate = np.loadtxt(infile5, dtype="int")
target_y_coordinate = np.loadtxt(infile6, dtype="int")

# dir
indir1 = infile3.replace("data/", "plot/").replace("x_resize.csv", "")
indir2 = infile4.replace("data/", "plot/").replace("x_resize.csv", "")

celltypes = ['Astrocytes', 'Microglia', 'Oligodendrocytes', 'Neurons']
source_celltype = pd.DataFrame(columns=celltypes)
target_celltype = pd.DataFrame(columns=celltypes)

for celltype in celltypes:
    print(celltype)
    # File
    source_infile = indir1 + celltype + ".png"
    target_infile = indir2 + celltype + ".png"
    # Loading
    source_img = Image.open(source_infile).convert('L')
    target_img = Image.open(target_infile).convert('L')
    # Bounding Box
    source_bbox = source_img.getbbox()
    target_bbox = target_img.getbbox()
    source_cropped_img = source_img.crop(source_bbox)
    target_cropped_img = target_img.crop(target_bbox)
    # Image => Numpy Array
    source_array = np.array(source_cropped_img)
    target_array = np.array(target_cropped_img)
    # 255 => 1
    source_array = np.where(source_array == 255, 1, 0)
    target_array = np.where(target_array == 255, 1, 0)
    # Non-zero values
    source_celltype[celltype] = source_array[source_x_coordinate, source_y_coordinate]
    target_celltype[celltype] = target_array[target_x_coordinate, target_y_coordinate]

# Save
source_celltype.to_csv(outfile1, index=False)
target_celltype.to_csv(outfile2, index=False)
