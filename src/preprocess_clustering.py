# -*- coding: utf-8 -*-
import os
import sys
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans

# Arguments
args = sys.argv
infile1 = args[1]
infile2 = args[2]
outfile1 = args[3]
outfile2 = args[4]
# infile1 = 'data/public_neg_trs_1/source/sum_exp_res_fix.csv'
# infile2 = 'data/public_neg_trs_1/target/sum_exp_res_fix.csv'

# Loading
source_sum_exp = np.loadtxt(infile1)
target_sum_exp = np.loadtxt(infile2)

# Log-Transform
source_sum_exp = np.log10(source_sum_exp - np.min(source_sum_exp) + 1)
target_sum_exp = np.log10(target_sum_exp - np.min(target_sum_exp) + 1)

# Clustering
source_kmeans = KMeans(n_clusters=2, random_state=0, n_init="auto").fit(source_sum_exp)
target_kmeans = KMeans(n_clusters=2, random_state=0, n_init="auto").fit(target_sum_exp)

# クラスタ中心の取得
source_centroids = source_kmeans.cluster_centers_
target_centroids = target_kmeans.cluster_centers_

# 各クラスタ中心の原点からの距離を計算
source_distances = np.linalg.norm(source_centroids, axis=1)
target_distances = np.linalg.norm(target_centroids, axis=1)

# 原点からの距離が近い順に並べ替え
source_sorted_indices = np.argsort(source_distances)
target_sorted_indices = np.argsort(target_distances)

# 新しいラベルを生成
source_new_labels = np.zeros_like(source_kmeans.labels_)
target_new_labels = np.zeros_like(target_kmeans.labels_)

for new_label, old_label in enumerate(source_sorted_indices):
    source_new_labels[source_kmeans.labels_ == old_label] = new_label

for new_label, old_label in enumerate(target_sorted_indices):
    target_new_labels[target_kmeans.labels_ == old_label] = new_label

# 新しいラベル
print(new_labels)

# Save
np.savetxt(outfile1, source_new_labels, fmt='%d')
np.savetxt(outfile2, target_new_labels, fmt='%d')
