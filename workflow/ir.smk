import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

SAMPLES = ['sma_neg_trs', 'public_neg_trs_1', 'public_neg_trs_2', 'public_neg_trs_3']

# ANTSMODES = ['antspy_rigid', 'antspy_affine', 'antspy_elastic', 'antspy_syn']
ANTSMODES = ['antspy_rigid', 'antspy_affine']
# SITKMODES = ['sitk_rigid', 'sitk_affine', 'sitk_bspline']
SITKMODES = ['sitk_rigid']

container: 'docker://koki/ir-experiments:20240911'

rule all:
    input:
        expand('output/{antsmode}/{sample}/warped.csv',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/warped.pkl',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/tx.pkl',
            antsmode=ANTSMODES, sample=SAMPLES),

        expand('output/{sitkmode}/{sample}/warped.csv',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/warped.pkl',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/tx.pkl',
            sitkmode=SITKMODES, sample=SAMPLES)

rule antspy:
    input:
        'data/{sample}/source/exp_res_fix.nii',
        'data/{sample}/target/exp_res_fix.nii'
    output:
        'output/{antsmode}/{sample}/warped.csv',
        'output/{antsmode}/{sample}/warped.pkl',
        'output/{antsmode}/{sample}/tx.pkl'
    wildcard_constraints:
        antsmode='|'.join([re.escape(x) for x in ANTSMODES])
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/antspy_{antsmode}_{sample}.txt'
    log:
        'logs/antspy_{antsmode}_{sample}.log'
    shell:
        'src/{wildcards.antsmode}.sh {input} {output} >& {log}'

rule sitk:
    input:
        'data/{sample}/source/exp_res_fix.nii',
        'data/{sample}/target/exp_res_fix.nii'
    output:
        'output/{sitkmode}/{sample}/warped.csv',
        'output/{sitkmode}/{sample}/warped.pkl',
        'output/{sitkmode}/{sample}/tx.pkl'
    wildcard_constraints:
        sitkmode='|'.join([re.escape(x) for x in SITKMODES])
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/sitk_{sitkmode}_{sample}.txt'
    log:
        'logs/sitk_{sitkmode}_{sample}.log'
    shell:
        'src/{wildcards.sitkmode}.sh {input} {output} >& {log}'
