import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

SAMPLES = ['sma_neg_trs', 'public_neg_trs_1', 'public_neg_trs_2', 'public_neg_trs_3']

# ANTSMODES = ['antspy_rigid', 'antspy_affine', 'antspy_elastic', 'antspy_syn']
ANTSMODES = ['antspy_rigid', 'antspy_affine']

rule all:
    input:
        expand('plot/{sample}/source/FINISH',
            sample=SAMPLES),
        expand('plot/{sample}/target/FINISH',
            sample=SAMPLES),
        expand('plot/{sample}/source/FINISH_res_fix',
            sample=SAMPLES),
        expand('plot/{sample}/target/FINISH_res_fix',
            sample=SAMPLES),
        expand('plot/{sample}/{antsmode}/fixed.png',
            sample=SAMPLES, antsmode=ANTSMODES),
        expand('plot/{sample}/{antsmode}/moving.png',
            sample=SAMPLES, antsmode=ANTSMODES),
        expand('plot/{sample}/{antsmode}/warped.png',
            sample=SAMPLES, antsmode=ANTSMODES),
        expand('plot/{sample}/{antsmode}/warped_overlay.png',
            sample=SAMPLES, antsmode=ANTSMODES)

rule plot_datasets:
    input:
        'data/{sample}/source/exp.csv',
        'data/{sample}/target/exp.csv',
        'data/{sample}/source/celltype.csv',
        'data/{sample}/target/celltype.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/source/FINISH',
        'plot/{sample}/target/FINISH'
    container:
        'docker://koki/ir-experiments-r:20240904'
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/plot_{sample}.txt'
    log:
        'logs/plot_{sample}.log'
    shell:
        'src/plot_{wildcards.sample}.sh {input} {output} >& {log}'

rule plot_datasets_res_fix:
    input:
        'data/{sample}/source/exp_res_fix.csv',
        'data/{sample}/target/exp_res_fix.csv',
        'data/{sample}/source/celltype_res_fix.csv',
        'data/{sample}/target/celltype_res_fix.csv'
    output:
        'plot/{sample}/source/FINISH_res_fix',
        'plot/{sample}/target/FINISH_res_fix'
    container:
        'docker://koki/ir-experiments-r:20240904'
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/plot_{sample}_res_fix.txt'
    log:
        'logs/plot_{sample}_res_fix.log'
    shell:
        'src/plot_{wildcards.sample}_res_fix.sh {input} {output} >& {log}'

rule plot_antspy:
    input:
        'data/{sample}/source/exp_res_fix.nii',
        'data/{sample}/target/exp_res_fix.nii',
        'output/{antsmode}/{sample}/warped.csv'
    output:
        'plot/{sample}/{antsmode}/fixed.png',
        'plot/{sample}/{antsmode}/moving.png',
        'plot/{sample}/{antsmode}/warped.png',
        'plot/{sample}/{antsmode}/warped_overlay.png'
    container:
        'docker://koki/ir-experiments:20240911'
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/plot_{sample}_{antsmode}.txt'
    log:
        'logs/plot_{sample}_{antsmode}.log'
    shell:
        'src/plot_antspy.sh {input} {output} >& {log}'
