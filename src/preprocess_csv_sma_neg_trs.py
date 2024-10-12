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
outfile11 = args[11]
outfile12 = args[12]
outfile13 = args[13]
outfile14 = args[14]

# Loading
source_all_exp = pd.read_csv("data/data_v2/public_lipid(sma)/D1/msi_data_lipid_neg.csv", header=0, low_memory=False)
target_all_exp = pd.read_csv("data/data_v2/public_lipid(sma)/D1/msi_trs_negD1_exp.csv", header=0)
target_celltype = pd.read_csv("data/data_v2/public_lipid(sma)/D1/msi_trs_negD1_celltype.csv", header=0)

source_celltype = source_all_exp.iloc[1:, 0:6]
source_all_exp = source_all_exp.drop(['Astrocytes', 'Microglia', 'Neurons', 'Oligodendrocytes', 'Name'], axis=1).loc[1:,]

# Sort
source_all_exp = source_all_exp.sort_values(by=['X', 'Y'])
target_all_exp = target_all_exp.sort_values(by=['X', 'Y'])
source_celltype = source_celltype.sort_values(by=['X', 'Y'])
target_celltype = target_celltype.sort_values(by=['X', 'Y'])

# Filtering
source_x_coordinate = np.array(source_all_exp['X'].values, dtype=np.int64)
source_y_coordinate = np.array(source_all_exp['Y'].values, dtype=np.int64)
target_x_coordinate = np.array(target_all_exp['X'].values, dtype=np.int64)
target_y_coordinate = np.array(target_all_exp['Y'].values, dtype=np.int64)

source_y_coordinate = max(source_y_coordinate) + min(source_y_coordinate) - source_y_coordinate # Flipping x axis (Only Source)

source_all_exp = source_all_exp.iloc[:, 2:]
target_all_exp = target_all_exp.iloc[:, 2:]

source_exp = source_all_exp.loc[:, ['SHexCer 42:1;2O']]
target_exp = target_all_exp.loc[:, ['Gal3st1']]

source_celltype = source_celltype.iloc[:, 2:]
target_celltype = target_celltype.iloc[:, 2:]

# Summation
source_sum_exp = source_all_exp.to_numpy(dtype=np.float64).sum(axis=1)
target_sum_exp = target_all_exp.to_numpy(dtype=np.float64).sum(axis=1)

# Binarization
bin_source_sum_exp = np.where(source_sum_exp > 0, 1, 0)
bin_target_sum_exp = np.where(target_sum_exp > 0, 1, 0)

# Save
source_exp.to_csv(outfile1, index=False, header=False)
target_exp.to_csv(outfile2, index=False, header=False)
source_all_exp.to_csv(outfile3, index=False)
target_all_exp.to_csv(outfile4, index=False)
np.savetxt(outfile5, source_sum_exp, fmt='%.10f')
np.savetxt(outfile6, target_sum_exp, fmt='%.10f')
np.savetxt(outfile7, bin_source_sum_exp, fmt='%d')
np.savetxt(outfile8, bin_target_sum_exp, fmt='%d')
source_celltype.to_csv(outfile9, index=False)
target_celltype.to_csv(outfile10, index=False)
np.savetxt(outfile11, source_x_coordinate, fmt='%d')
np.savetxt(outfile12, target_x_coordinate, fmt='%d')
np.savetxt(outfile13, source_y_coordinate, fmt='%d')
np.savetxt(outfile14, target_y_coordinate, fmt='%d')