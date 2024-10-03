# -*- coding: utf-8 -*-
import os
import sys
import pandas as pd
import numpy as np
import SimpleITK as sitk
import SimpleITK.utilities as utils
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from src.functions import apply_function_to_columns, csv2img_eachcol, res_source, res_target, csv2img, csv2img3, resample_image, resample_image_categorical
import pickle as pkl

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
outfile1 = args[12]
outfile2 = args[13]
outfile3 = args[14]
outfile4 = args[15]
outfile5 = args[16]
outfile6 = args[17]
outfile7 = args[18]
outfile8 = args[19]
outfile9 = args[20]
outfile10 = args[21]
outfile11 = args[22]
outfile12 = args[23]
outfile13 = args[24]
outfile14 = args[25]
outfile15 = args[26]
outfile16 = args[27]
# infile1 = 'data/public_neg_trs_1/source/exp.csv'
# infile2 = 'data/public_neg_trs_1/target/exp.csv'
# infile3 = 'data/public_neg_trs_1/source/all_exp.csv'
# infile4 = 'data/public_neg_trs_1/source/sum_exp.csv'
# infile5 = 'data/public_neg_trs_1/target/sum_exp.csv'
# infile6 = 'data/public_neg_trs_1/source/celltype.csv'
# infile7 = 'data/public_neg_trs_1/target/celltype.csv'
# infile8 = 'data/public_neg_trs_1/source/x.csv'
# infile9 = 'data/public_neg_trs_1/target/x.csv'
# infile10 = 'data/public_neg_trs_1/source/y.csv'
# infile11 = 'data/public_neg_trs_1/target/y.csv'

# Loading
source_exp = np.loadtxt(infile1)
target_exp = np.loadtxt(infile2)
source_all_exp = pd.read_csv(infile3, header=0)
source_sum_exp = np.loadtxt(infile4)
target_sum_exp = np.loadtxt(infile5)
source_celltype = pd.read_csv(infile6, header=0)
target_celltype = pd.read_csv(infile7, header=0)
source_x_coordinate = np.loadtxt(infile8, dtype='int')
target_x_coordinate = np.loadtxt(infile9, dtype='int')
source_y_coordinate = np.loadtxt(infile10, dtype='int')
target_y_coordinate = np.loadtxt(infile11, dtype='int')

# Re-numbering
source_x_coordinate = np.argsort(np.argsort(source_x_coordinate))
target_x_coordinate = np.argsort(np.argsort(target_x_coordinate))
source_y_coordinate = np.argsort(np.argsort(source_y_coordinate))
target_y_coordinate = np.argsort(np.argsort(target_y_coordinate))

# CSV => Numpy Array
source_img_array = csv2img3(source_x_coordinate, source_y_coordinate, source_exp)
target_img_array = csv2img3(target_x_coordinate, target_y_coordinate, target_exp)

source_all_img_array = apply_function_to_columns(source_all_exp, csv2img_eachcol, x=source_x_coordinate, y=source_y_coordinate)

source_sum_exp = pd.DataFrame(source_sum_exp)
target_sum_exp = pd.DataFrame(target_sum_exp)

source_sum_img_array = csv2img(source_x_coordinate, source_y_coordinate, source_sum_exp)
target_sum_img_array = csv2img(target_x_coordinate, target_y_coordinate, target_sum_exp)

source_celltype_img_array = apply_function_to_columns(source_celltype, csv2img_eachcol, x=source_x_coordinate, y=source_y_coordinate)
target_celltype_img_array = apply_function_to_columns(target_celltype, csv2img_eachcol, x=target_x_coordinate, y=target_y_coordinate)

# Numpy Array => ITK Image Object
source_img = sitk.GetImageFromArray(source_img_array.T)
target_img = sitk.GetImageFromArray(target_img_array.T)

source_sum_img = sitk.GetImageFromArray(source_sum_img_array.T)
target_sum_img = sitk.GetImageFromArray(target_sum_img_array.T)

source_all_img = [sitk.GetImageFromArray(x.T) for x in source_all_img_array]

source_celltype_img = [sitk.GetImageFromArray(x.T) for x in source_celltype_img_array]
target_celltype_img = [sitk.GetImageFromArray(x.T) for x in target_celltype_img_array]

# Change Resolution
## ITK Image Object
# source_res = res_source(infile1)
# target_res = res_target(infile2)

# source_img = resample_image(source_img, source_res)
# target_img = resample_image(target_img, target_res)
source_img = utils.resize(source_img, (200, 200), sitk.sitkGaussian)
target_img = utils.resize(target_img, (200, 200), sitk.sitkGaussian)

# source_all_img = [resample_image(x, scale=source_res) for x in source_all_img]
source_all_img = [utils.resize(x, (200, 200)) for x in source_all_img]

# source_sum_img = resample_image(source_sum_img, source_res)
# target_sum_img = resample_image(target_sum_img, target_res)
source_sum_img = utils.resize(source_sum_img, (200, 200), sitk.sitkGaussian)
target_sum_img = utils.resize(target_sum_img, (200, 200), sitk.sitkGaussian)

# source_celltype_img = [resample_image_categorical(x, scale=source_res) for x in source_celltype_img]
# target_celltype_img = [resample_image_categorical(x, scale=target_res) for x in target_celltype_img]
source_celltype_img = [utils.resize(x, (200, 200)) for x in source_celltype_img]
target_celltype_img = [utils.resize(x, (200, 200)) for x in target_celltype_img]

# ITK Image Object => Numpy Array
source_img_array = sitk.GetArrayFromImage(source_img).T
target_img_array = sitk.GetArrayFromImage(target_img).T

source_all_img_array = [sitk.GetArrayFromImage(x).T for x in source_all_img]

source_sum_img_array = sitk.GetArrayFromImage(source_sum_img).T
target_sum_img_array = sitk.GetArrayFromImage(target_sum_img).T

source_celltype_img_array = [sitk.GetArrayFromImage(x).T for x in source_celltype_img]
target_celltype_img_array = [sitk.GetArrayFromImage(x).T for x in target_celltype_img]

# Celltype Label Vector
## list => Matrix
source_celltype_matrix = np.column_stack([array.flatten(order='F') for array in source_celltype_img_array])
target_celltype_matrix = np.column_stack([array.flatten(order='F') for array in target_celltype_img_array])

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
np.savetxt(outfile1, source_img_array)
sitk.WriteImage(source_img, outfile2)

np.savetxt(outfile3, target_img_array)
sitk.WriteImage(target_img, outfile4)

with open(outfile5, "wb") as f:
    pkl.dump(source_all_img_array, f)

with open(outfile6, "wb") as f:
    pkl.dump(source_all_img, f)

np.savetxt(outfile7, source_sum_img_array)
sitk.WriteImage(source_sum_img, outfile8)

np.savetxt(outfile9, target_sum_img_array)
sitk.WriteImage(target_sum_img, outfile10)

source_celltype_vec.to_csv(outfile11, index=False, header=False)

with open(outfile12, "wb") as f:
    pkl.dump(source_celltype_img_array, f)

with open(outfile13, "wb") as f:
    pkl.dump(source_celltype_img, f)

target_celltype_vec.to_csv(outfile14, index=False, header=False)

with open(outfile15, "wb") as f:
    pkl.dump(target_celltype_img_array, f)

with open(outfile16, "wb") as f:
    pkl.dump(target_celltype_img, f)
