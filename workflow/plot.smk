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

QGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
MERGE_QGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']

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
            sample=SAMPLES, antsmode=ANTSMODES),
        expand('plot/{sample}/{sitkmode}/fixed.png',
            sample=SAMPLES, sitkmode=SITKMODES),
        expand('plot/{sample}/{sitkmode}/moving.png',
            sample=SAMPLES, sitkmode=SITKMODES),
        expand('plot/{sample}/{sitkmode}/warped.png',
            sample=SAMPLES, sitkmode=SITKMODES),
        expand('plot/{sample}/{sitkmode}/warped_overlay.png',
            sample=SAMPLES, sitkmode=SITKMODES),
        expand('plot/{sample}/qgw/{qgwp}/FINISH',
            sample=SAMPLES, qgwp=QGW_PARAMETERS),
        expand('plot/{sample}/merge_qgw/{merge_qgwp}/FINISH',
            sample=SAMPLES, merge_qgwp=MERGE_QGW_PARAMETERS)

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
    wildcard_constraints:
        antsmode='|'.join([re.escape(x) for x in ANTSMODES])
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

rule plot_sitk:
    input:
        'data/{sample}/source/exp_res_fix.nii',
        'data/{sample}/target/exp_res_fix.nii',
        'output/{sitkmode}/{sample}/warped.csv'
    output:
        'plot/{sample}/{sitkmode}/fixed.png',
        'plot/{sample}/{sitkmode}/moving.png',
        'plot/{sample}/{sitkmode}/warped.png',
        'plot/{sample}/{sitkmode}/warped_overlay.png'
    wildcard_constraints:
        sitkmode='|'.join([re.escape(x) for x in SITKMODES])
    container:
        'docker://koki/ir-experiments:20240911'
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/plot_{sample}_{sitkmode}.txt'
    log:
        'logs/plot_{sample}_{sitkmode}.log'
    shell:
        'src/plot_sitk.sh {input} {output} >& {log}'

rule plot_qgw:
    input:
        'output/qgw/{sample}/{qgwp}/warped.txt',
        'data/{sample}/target/x.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/qgw/{qgwp}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20240904'
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/plot_qgw_{sample}_{qgwp}.txt'
    log:
        'logs/plot_qgw_{sample}_{qgwp}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_merge_qgw:
    input:
        'output/merge_qgw/{sample}/{merge_qgwp}/warped.txt',
        'data/{sample}/target/x.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/merge_qgw/{merge_qgwp}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20240904'
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/plot_merge_qgw_{sample}_{merge_qgwp}.txt'
    log:
        'logs/plot_merge_qgw_{sample}_{merge_qgwp}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

