# -*- coding: utf-8 -*-
import os
import sys
import pandas as pd
import numpy as np

# Arguments
args = sys.argv
outfile1 = args[1]
outfile2 = args[2]
outfile3 = args[3]
outfile4 = args[4]
outfile5 = args[5]
outfile6 = args[6]
outfile7 = args[7]
outfile8 = args[8]
outfile9 = args[9]
outfile10 = args[10]

# Loading
source_all_exp = pd.read_csv("data/data_v2/same_sec_lipid/data_lipid_neg.csv", header=0)
target_all_exp = pd.read_csv("data/public_trs/data_trs_exp.csv", header=0)
target_celltype = pd.read_csv("data/public_trs/data_trs_celltype.csv", header=0)

source_celltype = source_all_exp.iloc[1:, 0:6]
source_all_exp = source_all_exp.drop(['Astrocytes', 'Microglia', 'Neurons', 'Oligodendrocytes', 'Name'], axis=1).loc[1:,]

# Sorting
cols = list(target_all_exp.columns)
cols[0], cols[1] = cols[1], cols[0]
target_all_exp = target_all_exp[cols]

# Only Source
source_all_exp['Y'] = max(source_all_exp['Y']) - source_all_exp['Y']

source_all_exp = source_all_exp.sort_values(by=['X', 'Y'])
target_all_exp = target_all_exp.sort_values(by=['x', 'y'])
source_celltype = source_celltype.sort_values(by=['X', 'Y'])
target_celltype = target_celltype.sort_values(by=['x', 'y'])

# Filtering
source_x_coordinate = np.array(source_all_exp['X'].values, dtype=np.int64)
source_y_coordinate = np.array(source_all_exp['Y'].values, dtype=np.int64)
target_x_coordinate = np.array(target_all_exp['x'].values, dtype=np.int64)
target_y_coordinate = np.array(target_all_exp['y'].values, dtype=np.int64)

source_all_exp = source_all_exp.iloc[:, 2:]
target_all_exp = target_all_exp.iloc[:, 2:]

source_exp = source_all_exp.loc[:, 'SHexCer 42:2;3O']
target_exp = target_all_exp.loc[:, 'Gal3st1']

source_celltype = source_celltype.iloc[:, 2:]
target_celltype = target_celltype.iloc[:, 2:]

# Filtering (Source)
index = np.where(source_x_coordinate > 36)[0]
source_x_coordinate = source_x_coordinate[index]
source_y_coordinate = source_y_coordinate[index]
source_exp = source_exp.iloc[index]
source_all_exp = source_all_exp.iloc[index, :]
source_celltype = source_celltype.iloc[index, :]

# Modifying Cell type names (Target)
target_celltype.columns = ['Neurons', 'Astrocytes', 'Microglia', 'Oligodendrocytes']

# Save
source_exp.to_csv(outfile1, index=False)
target_exp.to_csv(outfile2, index=False)
source_all_exp.to_csv(outfile3, index=False)
target_all_exp.to_csv(outfile4, index=False)
source_celltype.to_csv(outfile5, index=False)
target_celltype.to_csv(outfile6, index=False)
np.savetxt(outfile7, source_x_coordinate, fmt='%d')
np.savetxt(outfile8, target_x_coordinate, fmt='%d')
np.savetxt(outfile9, source_y_coordinate, fmt='%d')
np.savetxt(outfile10, target_y_coordinate, fmt='%d')
