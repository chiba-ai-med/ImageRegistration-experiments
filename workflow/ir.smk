import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

SAMPLES = ['sma_neg_trs', 'public_neg_trs_1', 'public_neg_trs_2', 'public_neg_trs_3']

# ANTSMODES = ['antspy_rigid', 'antspy_affine', 'antspy_elastic', 'antspy_syn']
ANTSMODES = ['antspy_rigid', 'antspy_affine']

container: 'docker://koki/ir-experiments:20240911'

rule all:
    input:
        expand('output/{antsmode}/{sample}/warped.csv',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/warped.pkl',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/tx.pkl',
            antsmode=ANTSMODES, sample=SAMPLES)

rule antspy:
    input:
        'data/{sample}/source/exp_res_fix.nii',
        'data/{sample}/target/exp_res_fix.nii'
    output:
        'output/{antsmode}/{sample}/warped.csv',
        'output/{antsmode}/{sample}/warped.pkl',
        'output/{antsmode}/{sample}/tx.pkl'
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/antspy_{antsmode}_{sample}.txt'
    log:
        'logs/antspy_{antsmode}_{sample}.log'
    shell:
        'src/{wildcards.antsmode}.sh {input} {output} >& {log}'
