import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

SAMPLES = ['sma_neg_trs', 'public_neg_trs_1', 'public_neg_trs_2', 'public_neg_trs_3']
SK_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
GW1_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
GW2_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
FGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
MERGED_GW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
QGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
MERGED_QGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']

rule all:
    input:
        # SK
        expand('output/sk/{sample}/{skp}/plan.pkl',
            sample=SAMPLES, skp=SK_PARAMETERS),
        expand('output/sk/{sample}/{skp}/warped.txt',
            sample=SAMPLES, skp=SK_PARAMETERS),
        # GW1
        expand('output/gw1/{sample}/{gw1p}/plan.pkl',
            sample=SAMPLES, gw1p=GW1_PARAMETERS),
        expand('output/gw1/{sample}/{gw1p}/warped.txt',
            sample=SAMPLES, gw1p=GW1_PARAMETERS),
        # GW2
        expand('output/gw2/{sample}/{gw2p}/plan.pkl',
            sample=SAMPLES, gw2p=GW2_PARAMETERS),
        expand('output/gw2/{sample}/{gw2p}/warped.txt',
            sample=SAMPLES, gw2p=GW2_PARAMETERS),
        # Fused GW
        expand('output/fgw/{sample}/{fgwp}/plan.pkl',
            sample=SAMPLES, fgwp=FGW_PARAMETERS),
        expand('output/fgw/{sample}/{fgwp}/warped.txt',
            sample=SAMPLES, fgwp=FGW_PARAMETERS),
        # Merged GW
        expand('output/merged_gw/{sample}/{merged_gwp}/plan.pkl',
            sample=SAMPLES, merged_gwp=MERGED_GW_PARAMETERS),
        expand('output/merged_gw/{sample}/{merged_gwp}/warped.txt',
            sample=SAMPLES, merged_gwp=MERGED_GW_PARAMETERS),
        # qGW
        expand('output/qgw/{sample}/{qgwp}/plan.pkl',
            sample=SAMPLES, qgwp=QGW_PARAMETERS),
        expand('output/qgw/{sample}/{qgwp}/warped.txt',
            sample=SAMPLES, qgwp=QGW_PARAMETERS),
        # Merged qGW
        expand('output/merged_qgw/{sample}/{merged_qgwp}/plan.pkl',
            sample=SAMPLES, merged_qgwp=MERGED_QGW_PARAMETERS),
        expand('output/merged_qgw/{sample}/{merged_qgwp}/warped.txt',
            sample=SAMPLES, merged_qgwp=MERGED_QGW_PARAMETERS)

#############################################
# Sinkhorn-Knopp
#############################################
rule sk:
    input:
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/source/exp.csv',
        'data/{sample}/target/exp.csv'
    output:
        'output/sk/{sample}/{skp}/plan.pkl',
        'output/sk/{sample}/{skp}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/{sample}_sk_{skp}.txt'
    log:
        'logs/{sample}_sk_{skp}.log'
    shell:
        'src/sk.sh {input} {output} {wildcards.skp} >& {log}'

#############################################
# Gromov-Wasserstein
#############################################
rule gw1:
    input:
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/target/all_exp.csv'
    output:
        'output/gw1/{sample}/{gw1p}/plan.pkl',
        'output/gw1/{sample}/{gw1p}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/{sample}_gw1_{gw1p}.txt'
    log:
        'logs/{sample}_gw1_{gw1p}.log'
    shell:
        'src/gw1.sh {input} {output} {wildcards.gw1p} >& {log}'

rule gw2:
    input:
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'output/gw2/{sample}/{gw2p}/plan.pkl',
        'output/gw2/{sample}/{gw2p}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/{sample}_gw2_{gw2p}.txt'
    log:
        'logs/{sample}_gw2_{gw2p}.log'
    shell:
        'src/gw2.sh {input} {output} {wildcards.gw2p} >& {log}'

rule fgw:
    input:
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/target/all_exp.csv',
        'data/{sample}/source/exp.csv',
        'data/{sample}/target/exp.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'output/fgw/{sample}/{fgwp}/plan.pkl',
        'output/fgw/{sample}/{fgwp}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/{sample}_fgw_{fgwp}.txt'
    log:
        'logs/{sample}_fgw_{fgwp}.log'
    shell:
        'src/fgw.sh {input} {output} {wildcards.fgwp} >& {log}'

rule merged_gw:
    input:
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/target/all_exp.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'output/merged_gw/{sample}/{merged_gwp}/plan.pkl',
        'output/merged_gw/{sample}/{merged_gwp}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/{sample}_merged_gw_{merged_gwp}.txt'
    log:
        'logs/{sample}_merged_gw_{merged_gwp}.log'
    shell:
        'src/merged_gw.sh {input} {output} {wildcards.merged_gwp} >& {log}'

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

rule merged_qgw:
    input:
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/target/all_exp.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'output/merged_qgw/{sample}/{merged_qgwp}/plan.pkl',
        'output/merged_qgw/{sample}/{merged_qgwp}/warped.txt'
    container:
        'docker://koki/ot-experiments:20240719'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/{sample}_merged_qgw_{merged_qgwp}.txt'
    log:
        'logs/{sample}_merged_qgw_{merged_qgwp}.log'
    shell:
        'src/merged_qgw.sh {input} {output} {wildcards.merged_qgwp} >& {log}'
