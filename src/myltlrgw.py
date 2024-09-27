# -*- coding: utf-8 -*-

# Package Loading
import sys
import numpy as np
import pandas as pd
import ot
import pickle

# Arguments
args = sys.argv
infile1 = args[1]
infile2 = args[2]
outfile1 = args[3]
outfile2 = args[4]
epsilon = float(args[5])

# Loading Data
source_exp = pd.read_csv(infile1, header=0)
target_exp = pd.read_csv(infile2, header=0)

# Column Names
source_cols = source_exp.columns.to_numpy()

# Log-Transformation
source_exp = np.log10(source_exp.to_numpy() + 1)
target_exp = np.log10(target_exp.to_numpy() + 1)

# Compute the low rank sqeuclidean cost decompositions
A1, A2 = ot.lowrank.compute_lr_sqeuclidean_matrix(source_exp, source_exp, rescale_cost=False)
B1, B2 = ot.lowrank.compute_lr_sqeuclidean_matrix(target_exp, target_exp, rescale_cost=False)

# Low-rank GW
Q, R, g, log = ot.lowrank_gromov_wasserstein_samples(
    source_exp, target_exp,
    reg=epsilon, rank=10, rescale_cost=False, cost_factorized_Xs=(A1, A2),
    cost_factorized_Xt=(B1, B2), seed_init=49, numItermax=100, log=True, stopThr=1e-6)

# Transportation
t_source_exp = R @ np.diag(1/g) @ (Q.T @ source_exp)

# Save
with open(outfile1, 'wb') as f:
    pickle.dump(Q, f)
    pickle.dump(g, f)
    pickle.dump(R, f)

out = pd.DataFrame(t_source_exp)
out.columns = source_cols
out.to_csv(outfile2, index=False)
