import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

SAMPLES = ['sma_neg_trs', 'public_neg_trs_1', 'public_neg_trs_2', 'public_neg_trs_3']

container: 'docker://koki/ir-experiments:20240911'

rule all:
    input:
        expand('data/{sample}/source/exp_res_fix.csv',
            sample=SAMPLES),
        expand('data/{sample}/source/exp_res_fix.nii',
            sample=SAMPLES),
        expand('data/{sample}/target/exp_res_fix.csv',
            sample=SAMPLES),
        expand('data/{sample}/target/exp_res_fix.nii',
            sample=SAMPLES),
        expand('data/{sample}/source/all_exp_res_fix_np.pkl',
            sample=SAMPLES),
        expand('data/{sample}/source/all_exp_res_fix_nii.pkl',
            sample=SAMPLES),
        expand('data/{sample}/source/celltype_res_fix.csv',
            sample=SAMPLES),
        expand('data/{sample}/source/celltype_res_fix_np.pkl',
            sample=SAMPLES),
        expand('data/{sample}/source/celltype_res_fix_nii.pkl',
            sample=SAMPLES),
        expand('data/{sample}/target/celltype_res_fix.csv',
            sample=SAMPLES),
        expand('data/{sample}/target/celltype_res_fix_np.pkl',
            sample=SAMPLES),
        expand('data/{sample}/target/celltype_res_fix_nii.pkl',
            sample=SAMPLES)

rule preprocess_csv:
    output:
        'data/{sample}/source/exp.csv',
        'data/{sample}/target/exp.csv',
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/target/all_exp.csv',
        'data/{sample}/source/celltype.csv',
        'data/{sample}/target/celltype.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/preprocess_csv_{sample}.txt'
    log:
        'logs/preprocess_csv_{sample}.log'
    shell:
        'src/preprocess_csv_{wildcards.sample}.sh {output} >& {log}'

rule preprocess_res_fix:
    input:
        'data/{sample}/source/exp.csv',
        'data/{sample}/target/exp.csv',
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/source/celltype.csv',
        'data/{sample}/target/celltype.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'data/{sample}/source/exp_res_fix.csv',
        'data/{sample}/source/exp_res_fix.nii',
        'data/{sample}/target/exp_res_fix.csv',
        'data/{sample}/target/exp_res_fix.nii',
        'data/{sample}/source/all_exp_res_fix_np.pkl',
        'data/{sample}/source/all_exp_res_fix_nii.pkl',
        'data/{sample}/source/celltype_res_fix.csv',
        'data/{sample}/source/celltype_res_fix_np.pkl',
        'data/{sample}/source/celltype_res_fix_nii.pkl',
        'data/{sample}/target/celltype_res_fix.csv',
        'data/{sample}/target/celltype_res_fix_np.pkl',
        'data/{sample}/target/celltype_res_fix_nii.pkl'
    resources:
        mem_mb=500000
    benchmark:
        'benchmarks/preprocess_res_fix_{sample}.txt'
    log:
        'logs/preprocess_res_fix_{sample}.log'
    shell:
        'src/preprocess_res_fix.sh {input} {output} >& {log}'