# -*- coding: utf-8 -*-

# Package Loading
import sys
import numpy as np
import pandas as pd
import ot
from scipy.spatial import distance
from sklearn.cluster import KMeans
import pickle

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
epsilon = float(args[9])

# Loading Data
source_all_exp = pd.read_csv(infile1, header=0)
target_all_exp = pd.read_csv(infile2, header=0)
source_x_coordinate = np.loadtxt(infile3)
target_x_coordinate = np.loadtxt(infile4)
source_y_coordinate = np.loadtxt(infile5)
target_y_coordinate = np.loadtxt(infile6)

# Column Names
source_cols = source_all_exp.columns.to_numpy()

# Distance (Expression)
C1_exp = distance.cdist(source_all_exp, source_all_exp)
C2_exp = distance.cdist(target_all_exp, target_all_exp)

# Distance (Coordinate)
source_coordinate = np.stack([source_x_coordinate, source_y_coordinate], axis=1)
target_coordinate = np.stack([target_x_coordinate, target_y_coordinate], axis=1)
C1_cord = distance.cdist(source_coordinate, source_coordinate)
C2_cord = distance.cdist(target_coordinate, target_coordinate)

# Distance (Merge)
w1, w2 = 0.9, 0.1
C1 = w1 * C1_exp / np.max(C1_exp) + w2 * C1_cord / np.max(C1_cord)
C2 = w1 * C2_exp / np.max(C2_exp) + w2 * C2_cord / np.max(C2_cord)

# Merginal Distribution
p = np.ones(C1.shape[0]) / C1.shape[0]
q = np.ones(C2.shape[0]) / C2.shape[0]

# Gromov-Wasserstein Distance
P = ot.gromov.entropic_gromov_wasserstein(C1, C2, p, q, 'square_loss', epsilon=epsilon)

if P.max() != 0:
    row_sums = P.sum(axis=1)
    P = P / row_sums[:, np.newaxis]

# Transportation
t_source_all_exp = np.matmul(P.T, source_all_exp)

# Save
with open(outfile1, 'wb') as f:
    pickle.dump(P, f)

out = pd.DataFrame(t_source_all_exp)
out.columns = source_cols
out.to_csv(outfile2, index=False)
