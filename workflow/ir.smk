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

container: 'docker://koki/ir-experiments:20241001'

rule all:
    input:
        # ANTsPy
        expand('output/{antsmode}/{sample}/warped.csv',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/warped_vec.csv',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/warped.pkl',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/tx.pkl',
            antsmode=ANTSMODES, sample=SAMPLES),

        expand('output/{antsmode}/{sample}/warped_sum.csv',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/warped_sum_vec.csv',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/warped_sum.pkl',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/tx_sum.pkl',
            antsmode=ANTSMODES, sample=SAMPLES),

        expand('output/{antsmode}/{sample}/warped_bin_sum.csv',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/warped_bin_sum_vec.csv',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/warped_bin_sum.pkl',
            antsmode=ANTSMODES, sample=SAMPLES),
        expand('output/{antsmode}/{sample}/tx_bin_sum.pkl',
            antsmode=ANTSMODES, sample=SAMPLES),

        # SimpleITK
        expand('output/{sitkmode}/{sample}/warped.csv',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/warped_vec.csv',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/warped.pkl',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/tx.pkl',
            sitkmode=SITKMODES, sample=SAMPLES),

        expand('output/{sitkmode}/{sample}/warped_sum.csv',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/warped_sum_vec.csv',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/warped_sum.pkl',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/tx_sum.pkl',
            sitkmode=SITKMODES, sample=SAMPLES),

        expand('output/{sitkmode}/{sample}/warped_bin_sum.csv',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/warped_bin_sum_vec.csv',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/warped_bin_sum.pkl',
            sitkmode=SITKMODES, sample=SAMPLES),
        expand('output/{sitkmode}/{sample}/tx_bin_sum.pkl',
            sitkmode=SITKMODES, sample=SAMPLES)

rule antspy:
    input:
        'data/{sample}/source/exp_resize.csv',
        'data/{sample}/target/exp_resize.csv',
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    output:
        'output/{antsmode}/{sample}/warped.csv',
        'output/{antsmode}/{sample}/warped_vec.csv',
        'output/{antsmode}/{sample}/warped.pkl',
        'output/{antsmode}/{sample}/tx.pkl'
    wildcard_constraints:
        antsmode='|'.join([re.escape(x) for x in ANTSMODES])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/antspy_{antsmode}_{sample}.txt'
    log:
        'logs/antspy_{antsmode}_{sample}.log'
    shell:
        'src/{wildcards.antsmode}.sh {input} {output} >& {log}'

rule antspy_sum:
    input:
        'data/{sample}/source/sum_exp_resize.csv',
        'data/{sample}/target/sum_exp_resize.csv',
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    output:
        'output/{antsmode}/{sample}/warped_sum.csv',
        'output/{antsmode}/{sample}/warped_sum_vec.csv',
        'output/{antsmode}/{sample}/warped_sum.pkl',
        'output/{antsmode}/{sample}/tx_sum.pkl'
    wildcard_constraints:
        antsmode='|'.join([re.escape(x) for x in ANTSMODES])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/antspy_sum_{antsmode}_{sample}.txt'
    log:
        'logs/antspy_sum_{antsmode}_{sample}.log'
    shell:
        'src/{wildcards.antsmode}.sh {input} {output} >& {log}'

rule antspy_bin_sum:
    input:
        'data/{sample}/source/bin_sum_exp_resize.csv',
        'data/{sample}/target/bin_sum_exp_resize.csv',
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    output:
        'output/{antsmode}/{sample}/warped_bin_sum.csv',
        'output/{antsmode}/{sample}/warped_bin_sum_vec.csv',
        'output/{antsmode}/{sample}/warped_bin_sum.pkl',
        'output/{antsmode}/{sample}/tx_bin_sum.pkl'
    wildcard_constraints:
        antsmode='|'.join([re.escape(x) for x in ANTSMODES])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/antspy_bin_sum_{antsmode}_{sample}.txt'
    log:
        'logs/antspy_bin_sum_{antsmode}_{sample}.log'
    shell:
        'src/{wildcards.antsmode}.sh {input} {output} >& {log}'

rule sitk:
    input:
        'data/{sample}/source/exp_resize.csv',
        'data/{sample}/target/exp_resize.csv',
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    output:
        'output/{sitkmode}/{sample}/warped.csv',
        'output/{sitkmode}/{sample}/warped_vec.csv',
        'output/{sitkmode}/{sample}/warped.pkl',
        'output/{sitkmode}/{sample}/tx.pkl'
    wildcard_constraints:
        sitkmode='|'.join([re.escape(x) for x in SITKMODES])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/sitk_{sitkmode}_{sample}.txt'
    log:
        'logs/sitk_{sitkmode}_{sample}.log'
    shell:
        'src/{wildcards.sitkmode}.sh {input} {output} >& {log}'

rule sitk_sum:
    input:
        'data/{sample}/source/sum_exp_resize.csv',
        'data/{sample}/target/sum_exp_resize.csv',
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    output:
        'output/{sitkmode}/{sample}/warped_sum.csv',
        'output/{sitkmode}/{sample}/warped_sum_vec.csv',
        'output/{sitkmode}/{sample}/warped_sum.pkl',
        'output/{sitkmode}/{sample}/tx_sum.pkl'
    wildcard_constraints:
        sitkmode='|'.join([re.escape(x) for x in SITKMODES])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/sitk_sum_{sitkmode}_{sample}.txt'
    log:
        'logs/sitk_sum_{sitkmode}_{sample}.log'
    shell:
        'src/{wildcards.sitkmode}.sh {input} {output} >& {log}'

rule sitk_bin_sum:
    input:
        'data/{sample}/source/bin_sum_exp_resize.csv',
        'data/{sample}/target/bin_sum_exp_resize.csv',
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    output:
        'output/{sitkmode}/{sample}/warped_bin_sum.csv',
        'output/{sitkmode}/{sample}/warped_bin_sum_vec.csv',
        'output/{sitkmode}/{sample}/warped_bin_sum.pkl',
        'output/{sitkmode}/{sample}/tx_bin_sum.pkl'
    wildcard_constraints:
        sitkmode='|'.join([re.escape(x) for x in SITKMODES])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/sitk_bin_sum_{sitkmode}_{sample}.txt'
    log:
        'logs/sitk_bin_sum_{sitkmode}_{sample}.log'
    shell:
        'src/{wildcards.sitkmode}.sh {input} {output} >& {log}'

