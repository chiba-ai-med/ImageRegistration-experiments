# -*- coding: utf-8 -*-
import sys
import numpy as np
from PIL import Image

# Arguments
args = sys.argv
infile1 = args[1]
infile2 = args[2]
outfile1 = args[3]
outfile2 = args[4]
outfile3 = args[5]
outfile4 = args[6]

# Loading
source_img = Image.open(infile1).convert('L')
target_img = Image.open(infile2).convert('L')

# Image => Numpy Array
source_array = np.array(source_img)
target_array = np.array(target_img)

# 255 => 1
source_array = np.where(source_array == 255, 1, 0)
target_array = np.where(target_array == 255, 1, 0)

# Non-zero values' Coordinates
source_y_coordinate, source_x_coordinate = np.nonzero(source_array)
target_y_coordinate, target_x_coordinate = np.nonzero(target_array)

# Save
np.savetxt(outfile1, source_x_coordinate, fmt='%d')
np.savetxt(outfile2, target_x_coordinate, fmt='%d')
np.savetxt(outfile3, source_y_coordinate, fmt='%d')
np.savetxt(outfile4, target_y_coordinate, fmt='%d')
