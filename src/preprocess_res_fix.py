# -*- coding: utf-8 -*-
import os
import sys
import pandas as pd
import numpy as np
import SimpleITK as sitk
import SimpleITK.utilities as utils
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from src.functions import apply_function_to_columns, csv2img_eachcol, res_source, res_target, csv2img, resample_image, resample_image_categorical
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
outfile1 = args[10]
outfile2 = args[11]
outfile3 = args[12]
outfile4 = args[13]
outfile5 = args[14]
outfile6 = args[15]
outfile7 = args[16]
outfile8 = args[17]
outfile9 = args[18]
outfile10 = args[19]
outfile11 = args[20]
outfile12 = args[21]
# infile1 = 'data/sma_neg_trs/source/exp.csv'
# infile2 = 'data/sma_neg_trs/target/exp.csv'
# infile3 = 'data/sma_neg_trs/source/all_exp.csv'
# infile4 = 'data/sma_neg_trs/source/celltype.csv'
# infile5 = 'data/sma_neg_trs/target/celltype.csv'
# infile6 = 'data/sma_neg_trs/source/x.csv'
# infile7 = 'data/sma_neg_trs/target/x.csv'
# infile8 = 'data/sma_neg_trs/source/y.csv'
# infile9 = 'data/sma_neg_trs/target/y.csv'

# Loading
source_exp = pd.read_csv(infile1, header=0)
target_exp = pd.read_csv(infile2, header=0)
source_all_exp = pd.read_csv(infile3, header=0)
source_celltype = pd.read_csv(infile4, header=0)
target_celltype = pd.read_csv(infile5, header=0)
source_x_coordinate = np.loadtxt(infile6, dtype='int')
target_x_coordinate = np.loadtxt(infile7, dtype='int')
source_y_coordinate = np.loadtxt(infile8, dtype='int')
target_y_coordinate = np.loadtxt(infile9, dtype='int')

# CSV => Numpy Array
source_img_array = csv2img(source_x_coordinate, source_y_coordinate, source_exp)
target_img_array = csv2img(target_x_coordinate, target_y_coordinate, target_exp)

source_all_img_array = apply_function_to_columns(source_all_exp, csv2img_eachcol, x=source_x_coordinate, y=source_y_coordinate)

source_celltype_img_array = apply_function_to_columns(source_celltype, csv2img_eachcol, x=source_x_coordinate, y=source_y_coordinate)
target_celltype_img_array = apply_function_to_columns(target_celltype, csv2img_eachcol, x=target_x_coordinate, y=target_y_coordinate)

# Numpy Array => ITK Image Object
source_img = sitk.GetImageFromArray(source_img_array.T)
target_img = sitk.GetImageFromArray(target_img_array.T)

source_all_img = [sitk.GetImageFromArray(x.T) for x in source_all_img_array]

source_celltype_img = [sitk.GetImageFromArray(x.T) for x in source_celltype_img_array]
target_celltype_img = [sitk.GetImageFromArray(x.T) for x in target_celltype_img_array]

# Change Resolution
## ITK Image Object
# source_res = res_source(infile1)
# target_res = res_target(infile2)

# source_img = resample_image(source_img, source_res)
# target_img = resample_image(target_img, target_res)
source_img = utils.resize(source_img, (150, 170), sitk.sitkGaussian)
target_img = utils.resize(target_img, (150, 170), sitk.sitkGaussian)

# source_all_img = [resample_image(x, scale=source_res) for x in source_all_img]
source_all_img = [utils.resize(x, (150, 170)) for x in source_all_img]

# source_celltype_img = [resample_image_categorical(x, scale=source_res) for x in source_celltype_img]
# target_celltype_img = [resample_image_categorical(x, scale=target_res) for x in target_celltype_img]
source_celltype_img = [utils.resize(x, (150, 170)) for x in source_celltype_img]
target_celltype_img = [utils.resize(x, (150, 170)) for x in target_celltype_img]

# ITK Image Object => Numpy Array
source_img_array = sitk.GetArrayFromImage(source_img).T
target_img_array = sitk.GetArrayFromImage(target_img).T

source_all_img_array = [sitk.GetArrayFromImage(x).T for x in source_all_img]

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

source_celltype_vec.to_csv(outfile7, index=False, header=False)

with open(outfile8, "wb") as f:
    pkl.dump(source_celltype_img_array, f)

with open(outfile9, "wb") as f:
    pkl.dump(source_celltype_img, f)

target_celltype_vec.to_csv(outfile10, index=False, header=False)

with open(outfile11, "wb") as f:
    pkl.dump(target_celltype_img_array, f)

with open(outfile12, "wb") as f:
    pkl.dump(target_celltype_img, f)
