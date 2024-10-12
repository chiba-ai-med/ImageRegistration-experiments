# -*- coding: utf-8 -*-
import os
import sys
import pandas as pd
import numpy as np
import SimpleITK as sitk
import SimpleITK.utilities as utils
from functions import apply_function_to_columns, csv2img_eachcol, res_source, res_target, csv2img, csv2img3, resample_image, resample_image_categorical
# from src.functions import apply_function_to_columns, csv2img_eachcol, res_source, res_target, csv2img, csv2img3, resample_image, resample_image_categorical

# Arguments
args = sys.argv
infile1 = args[1]
infile2 = args[2]
infile3 = args[3]
infile4 = args[4]
infile5 = args[5]
infile6 = args[6]
infile7 = args[7]
infile8 = args[8]
infile9 = args[9]
infile10 = args[10]
infile11 = args[11]
infile12 = args[12]
infile13 = args[13]

outfile1 = args[14]
outfile2 = args[15]
outfile3 = args[16]
outfile4 = args[17]
outfile5 = args[18]
outfile6 = args[19]
outfile7 = args[20]
outfile8 = args[21]
outfile9 = args[22]
outfile10 = args[23]
outfile11 = args[24]
outfile12 = args[25]

# Loading
source_exp = np.loadtxt(infile1)
target_exp = np.loadtxt(infile2)
source_all_exp = pd.read_csv(infile3, header=0)
source_sum_exp = np.loadtxt(infile4)
target_sum_exp = np.loadtxt(infile5)
bin_source_sum_exp = np.loadtxt(infile6)
bin_target_sum_exp = np.loadtxt(infile7)
source_celltype = pd.read_csv(infile8, header=0)
target_celltype = pd.read_csv(infile9, header=0)
source_x_coordinate = np.loadtxt(infile10, dtype='int')
target_x_coordinate = np.loadtxt(infile11, dtype='int')
source_y_coordinate = np.loadtxt(infile12, dtype='int')
target_y_coordinate = np.loadtxt(infile13, dtype='int')

# Re-numbering
source_x_coordinate = np.argsort(np.argsort(source_x_coordinate))
target_x_coordinate = np.argsort(np.argsort(target_x_coordinate))
source_y_coordinate = np.argsort(np.argsort(source_y_coordinate))
target_y_coordinate = np.argsort(np.argsort(target_y_coordinate))

# CSV => Numpy Array
source_img_array = csv2img3(source_x_coordinate, source_y_coordinate, source_exp)
target_img_array = csv2img3(target_x_coordinate, target_y_coordinate, target_exp)

source_all_img_array = apply_function_to_columns(source_all_exp, csv2img_eachcol, x=source_x_coordinate, y=source_y_coordinate)

source_sum_img_array = csv2img3(source_x_coordinate, source_y_coordinate, source_sum_exp)
target_sum_img_array = csv2img3(target_x_coordinate, target_y_coordinate, target_sum_exp)

bin_source_sum_img_array = csv2img3(source_x_coordinate, source_y_coordinate, bin_source_sum_exp)
bin_target_sum_img_array = csv2img3(target_x_coordinate, target_y_coordinate, bin_target_sum_exp)

source_celltype_img_array = apply_function_to_columns(source_celltype, csv2img_eachcol, x=source_x_coordinate, y=source_y_coordinate)
target_celltype_img_array = apply_function_to_columns(target_celltype, csv2img_eachcol, x=target_x_coordinate, y=target_y_coordinate)

# Numpy Array => ITK Image Object
source_img = sitk.GetImageFromArray(source_img_array.T)
target_img = sitk.GetImageFromArray(target_img_array.T)

source_sum_img = sitk.GetImageFromArray(source_sum_img_array.T)
target_sum_img = sitk.GetImageFromArray(target_sum_img_array.T)

bin_source_sum_img = sitk.GetImageFromArray(bin_source_sum_img_array.T)
bin_target_sum_img = sitk.GetImageFromArray(bin_target_sum_img_array.T)

source_all_img = [sitk.GetImageFromArray(x.T) for x in source_all_img_array]

source_celltype_img = [sitk.GetImageFromArray(x.T) for x in source_celltype_img_array]
target_celltype_img = [sitk.GetImageFromArray(x.T) for x in target_celltype_img_array]

# Change Resolution
## ITK Image Object
# source_res = res_source(infile1)
# target_res = res_target(infile2)

# source_img = resample_image(source_img, source_res)
# target_img = resample_image(target_img, target_res)
# res_x = int(max(target_x_coordinate) - min(target_x_coordinate) + 1)
# res_y = int(max(target_y_coordinate) - min(target_y_coordinate) + 1)
res_x = 100
res_y = 100

source_img = utils.resize(source_img, (res_x, res_y), sitk.sitkGaussian)
target_img = utils.resize(target_img, (res_x, res_y), sitk.sitkGaussian)

# source_all_img = [resample_image(x, scale=source_res) for x in source_all_img]
source_all_img = [utils.resize(x, (res_x, res_y)) for x in source_all_img]

# source_sum_img = resample_image(source_sum_img, source_res)
# target_sum_img = resample_image(target_sum_img, target_res)
source_sum_img = utils.resize(source_sum_img, (res_x, res_y), sitk.sitkGaussian)
target_sum_img = utils.resize(target_sum_img, (res_x, res_y), sitk.sitkGaussian)

# bin_source_sum_img = resample_image(bin_source_sum_img, source_res)
# bin_target_sum_img = resample_image(bin_target_sum_img, target_res)
bin_source_sum_img = utils.resize(bin_source_sum_img, (res_x, res_y), sitk.sitkGaussian)
bin_target_sum_img = utils.resize(bin_target_sum_img, (res_x, res_y), sitk.sitkGaussian)

# source_celltype_img = [resample_image_categorical(x, scale=source_res) for x in source_celltype_img]
# target_celltype_img = [resample_image_categorical(x, scale=target_res) for x in target_celltype_img]
source_celltype_img = [utils.resize(x, (res_x, res_y)) for x in source_celltype_img]
target_celltype_img = [utils.resize(x, (res_x, res_y)) for x in target_celltype_img]

# ITK Image Object => Numpy Array
source_img_array = sitk.GetArrayFromImage(source_img).T
target_img_array = sitk.GetArrayFromImage(target_img).T

source_all_img_array = [sitk.GetArrayFromImage(x).T for x in source_all_img]

source_sum_img_array = sitk.GetArrayFromImage(source_sum_img).T
target_sum_img_array = sitk.GetArrayFromImage(target_sum_img).T

bin_source_sum_img_array = sitk.GetArrayFromImage(bin_source_sum_img).T
bin_target_sum_img_array = sitk.GetArrayFromImage(bin_target_sum_img).T

source_celltype_img_array = [sitk.GetArrayFromImage(x).T for x in source_celltype_img]
target_celltype_img_array = [sitk.GetArrayFromImage(x).T for x in target_celltype_img]

# Vectorizing
# source_x_coordinate2, source_y_coordinate2 = np.nonzero(bin_source_sum_img_array)
# target_x_coordinate2, target_y_coordinate2 = np.nonzero(bin_target_sum_img_array)
source_x_coordinate2, source_y_coordinate2 = np.unravel_index(np.arange(source_img_array.size), source_img_array.shape)
target_x_coordinate2, target_y_coordinate2 = np.unravel_index(np.arange(target_img_array.size), target_img_array.shape)

source_img_array_vec = source_img_array[source_x_coordinate2, source_y_coordinate2]
target_img_array_vec = target_img_array[target_x_coordinate2, target_y_coordinate2]

source_sum_img_array_vec = source_sum_img_array[source_x_coordinate2, source_y_coordinate2]
target_sum_img_array_vec = target_sum_img_array[target_x_coordinate2, target_y_coordinate2]

bin_source_sum_img_array_vec = bin_source_sum_img_array[source_x_coordinate2, source_y_coordinate2]
bin_target_sum_img_array_vec = bin_target_sum_img_array[target_x_coordinate2, target_y_coordinate2]

# Celltype Label Vector
## list => Matrix
source_celltype_matrix = np.column_stack([array[source_x_coordinate2, source_y_coordinate2].flatten(order='F') for array in source_celltype_img_array])
target_celltype_matrix = np.column_stack([array[target_x_coordinate2, target_y_coordinate2].flatten(order='F') for array in target_celltype_img_array])

## Matrix => Vector
celltype = source_celltype.columns.to_numpy()

source_index = np.argmax(source_celltype_matrix, axis=1)
target_index = np.argmax(target_celltype_matrix, axis=1)

source_celltype_vec = celltype[source_index]
target_celltype_vec = celltype[target_index]

# Numpy => Pandas
source_celltype_vec = pd.DataFrame(source_celltype_vec)
target_celltype_vec = pd.DataFrame(target_celltype_vec)

# Save
np.savetxt(outfile1, source_img_array_vec)
np.savetxt(outfile2, target_img_array_vec)
np.savetxt(outfile3, source_sum_img_array_vec)
np.savetxt(outfile4, target_sum_img_array_vec)
np.savetxt(outfile5, bin_source_sum_img_array_vec, fmt="%d")
np.savetxt(outfile6, bin_target_sum_img_array_vec, fmt="%d")
source_celltype_vec.to_csv(outfile7, index=False, header=False)
target_celltype_vec.to_csv(outfile8, index=False, header=False)
np.savetxt(outfile9, source_x_coordinate2, fmt="%d")
np.savetxt(outfile10, target_x_coordinate2, fmt="%d")
np.savetxt(outfile11, source_y_coordinate2, fmt="%d")
np.savetxt(outfile12, target_y_coordinate2, fmt="%d")
