import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

SAMPLES = ['sma_neg_trs', 'public_neg_trs_1', 'public_neg_trs_2', 'public_neg_trs_3']
QGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
MERGE_QGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']

container: 'docker://koki/ir-experiments:20240911'

rule all:
    input:
        expand('output/qgw/{sample}/{qgwp}/plan.pkl',
            sample=SAMPLES, qgwp=QGW_PARAMETERS),
        expand('output/qgw/{sample}/{qgwp}/warped.txt',
            sample=SAMPLES, qgwp=QGW_PARAMETERS),
        expand('output/merge_qgw/{sample}/{merge_qgwp}/plan.pkl',
            sample=SAMPLES, merge_qgwp=MERGE_QGW_PARAMETERS),
        expand('output/merge_qgw/{sample}/{merge_qgwp}/warped.txt',
            sample=SAMPLES, merge_qgwp=MERGE_QGW_PARAMETERS),

#############################################
# Quantized Gromov-Wasserstein
#############################################
rule qgw:
    input:
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/target/all_exp.csv'
    output:
        'output/qgw/{sample}/{qgwp}/plan.pkl',
        'output/qgw/{sample}/{qgwp}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/{sample}_qgw_{qgwp}.txt'
    log:
        'logs/{sample}_qgw_{qgwp}.log'
    shell:
        'src/qgw.sh {input} {output} {wildcards.qgwp} >& {log}'

rule merge_qgw:
    input:
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/target/all_exp.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'output/merge_qgw/{sample}/{merge_qgwp}/plan.pkl',
        'output/merge_qgw/{sample}/{merge_qgwp}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/{sample}_merge_qgw_{merge_qgwp}.txt'
    log:
        'logs/{sample}_merge_qgw_{merge_qgwp}.log'
    shell:
        'src/merge_qgw.sh {input} {output} {wildcards.merge_qgwp} >& {log}'
