# -*- coding: utf-8 -*-
import sys
import numpy as np
from PIL import Image

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
source_img = Image.open(infile1).convert('L')
target_img = Image.open(infile2).convert('L')
source_x_coordinate = np.loadtxt(infile3, dtype="int")
target_x_coordinate = np.loadtxt(infile4, dtype="int")
source_y_coordinate = np.loadtxt(infile5, dtype="int")
target_y_coordinate = np.loadtxt(infile6, dtype="int")

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
source_exp = source_array[source_x_coordinate, source_y_coordinate]
target_exp = target_array[target_x_coordinate, target_y_coordinate]

# Save
np.savetxt(outfile1, source_exp, fmt='%.10f')
np.savetxt(outfile2, target_exp, fmt='%.10f')
