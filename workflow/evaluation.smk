import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

SAMPLES = ['sma_neg_trs', 'public_neg_trs_1', 'public_neg_trs_2', 'public_neg_trs_3']

ANTSMODES = ['antspy_rigid', 'antspy_affine']
SITKMODES = ['sitk_rigid']

SK_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
GW1_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
GW2_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
FGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
MERGED_GW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
QGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']
MERGED_QGW_PARAMETERS = ['1E+8','1E+9','1E+10','1E+11','1E+12','1E+13','1E+14']

rule all:
    input:
        # Image Registration
        expand("output/{irmethod}/{sample}/cc.csv",
            irmethod=ANTSMODES + SITKMODES, sample=SAMPLES),
        expand("output/{irmethod}/{sample}/jaccard.csv",
            irmethod=ANTSMODES + SITKMODES, sample=SAMPLES),
        # Optimal Transport
        expand("output/sk/{sample}/{skp}/cc.csv",
            sample=SAMPLES, skp=SK_PARAMETERS),
        expand("output/sk/{sample}/{skp}/jaccard.csv",
            sample=SAMPLES, skp=SK_PARAMETERS),
        expand("output/gw1/{sample}/{gw1p}/cc.csv",
            sample=SAMPLES, gw1p=GW1_PARAMETERS),
        expand("output/gw1/{sample}/{gw1p}/jaccard.csv",
            sample=SAMPLES, gw1p=GW1_PARAMETERS),
        expand("output/gw2/{sample}/{gw2p}/cc.csv",
            sample=SAMPLES, gw2p=GW2_PARAMETERS),
        expand("output/gw2/{sample}/{gw2p}/jaccard.csv",
            sample=SAMPLES, gw2p=GW2_PARAMETERS),
        expand("output/fgw/{sample}/{fgwp}/cc.csv",
            sample=SAMPLES, fgwp=FGW_PARAMETERS),
        expand("output/fgw/{sample}/{fgwp}/jaccard.csv",
            sample=SAMPLES, fgwp=FGW_PARAMETERS),
        expand("output/merged_gw/{sample}/{merged_gwp}/cc.csv",
            sample=SAMPLES, merged_gwp=MERGED_GW_PARAMETERS),
        expand("output/merged_gw/{sample}/{merged_gwp}/jaccard.csv",
            sample=SAMPLES, merged_gwp=MERGED_GW_PARAMETERS),
        expand("output/qgw/{sample}/{qgwp}/cc.csv",
            sample=SAMPLES, qgwp=QGW_PARAMETERS),
        expand("output/qgw/{sample}/{qgwp}/jaccard.csv",
            sample=SAMPLES, qgwp=QGW_PARAMETERS),
        expand("output/merged_qgw/{sample}/{merged_qgwp}/cc.csv",
            sample=SAMPLES, merged_qgwp=MERGED_QGW_PARAMETERS),
        expand("output/merged_qgw/{sample}/{merged_qgwp}/jaccard.csv",
            sample=SAMPLES, merged_qgwp=MERGED_QGW_PARAMETERS),
        expand("output/sk/{sample}/{skp}/cc.csv",
            sample=SAMPLES, skp=SK_PARAMETERS),
        expand("output/sk/{sample}/{skp}/jaccard.csv",
            sample=SAMPLES, skp=SK_PARAMETERS)

rule evaluate_ir:
    input:
        "output/{irmethod}/{sample}/warped_vec.csv",
        "data/{sample}/target/exp_res_fix.csv"
    output:
        "output/{irmethod}/{sample}/cc.csv",
        "output/{irmethod}/{sample}/jaccard.csv"
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_{irmethod}_{sample}.txt'
    log:
        'logs/evaluate_{irmethod}_{sample}.log'
    shell:
        'src/evaluate_ir.sh {input} {output} >& {log}'

rule evaluate_sk:
    input:
        "output/sk/{sample}/{skp}/warped.txt",
        "data/{sample}/target/exp.csv"
    output:
        "output/sk/{sample}/{skp}/cc.csv",
        "output/sk/{sample}/{skp}/jaccard.csv"
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_sk_{sample}_{skp}.txt'
    log:
        'logs/evaluate_sk_{sample}_{skp}.log'
    shell:
        'src/evaluate_ot.sh {input} {output} >& {log}'

rule evaluate_gw1:
    input:
        "output/gw1/{sample}/{gw1p}/warped.txt",
        "data/{sample}/target/exp.csv"
    output:
        "output/gw1/{sample}/{gw1p}/cc.csv",
        "output/gw1/{sample}/{gw1p}/jaccard.csv"
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_gw1_{sample}_{gw1p}.txt'
    log:
        'logs/evaluate_gw1_{sample}_{gw1p}.log'
    shell:
        'src/evaluate_ot.sh {input} {output} >& {log}'

rule evaluate_gw2:
    input:
        "output/gw2/{sample}/{gw2p}/warped.txt",
        "data/{sample}/target/exp.csv"
    output:
        "output/gw2/{sample}/{gw2p}/cc.csv",
        "output/gw2/{sample}/{gw2p}/jaccard.csv"
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_gw2_{sample}_{gw2p}.txt'
    log:
        'logs/evaluate_gw2_{sample}_{gw2p}.log'
    shell:
        'src/evaluate_ot.sh {input} {output} >& {log}'

rule evaluate_fgw:
    input:
        "output/fgw/{sample}/{fgwp}/warped.txt",
        "data/{sample}/target/exp.csv"
    output:
        "output/fgw/{sample}/{fgwp}/cc.csv",
        "output/fgw/{sample}/{fgwp}/jaccard.csv"
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_fgw_{sample}_{fgwp}.txt'
    log:
        'logs/evaluate_fgw_{sample}_{fgwp}.log'
    shell:
        'src/evaluate_ot.sh {input} {output} >& {log}'

rule evaluate_merged_gw:
    input:
        "output/merged_gw/{sample}/{merged_gwp}/warped.txt",
        "data/{sample}/target/exp.csv"
    output:
        "output/merged_gw/{sample}/{merged_gwp}/cc.csv",
        "output/merged_gw/{sample}/{merged_gwp}/jaccard.csv"
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_merged_gw_{sample}_{merged_gwp}.txt'
    log:
        'logs/evaluate_merged_gw_{sample}_{merged_gwp}.log'
    shell:
        'src/evaluate_ot.sh {input} {output} >& {log}'

rule evaluate_qgw:
    input:
        "output/qgw/{sample}/{qgwp}/warped.txt",
        "data/{sample}/target/exp.csv"
    output:
        "output/qgw/{sample}/{qgwp}/cc.csv",
        "output/qgw/{sample}/{qgwp}/jaccard.csv"
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_qgw_{sample}_{qgwp}.txt'
    log:
        'logs/evaluate_qgw_{sample}_{qgwp}.log'
    shell:
        'src/evaluate_ot.sh {input} {output} >& {log}'

rule evaluate_merged_qgw:
    input:
        "output/merged_qgw/{sample}/{merged_qgwp}/warped.txt",
        "data/{sample}/target/exp.csv"
    output:
        "output/merged_qgw/{sample}/{merged_qgwp}/cc.csv",
        "output/merged_qgw/{sample}/{merged_qgwp}/jaccard.csv"
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/evaluate_merged_qgw_{sample}_{merged_qgwp}.txt'
    log:
        'logs/evaluate_merged_qgw_{sample}_{merged_qgwp}.log'
    shell:
        'src/evaluate_ot.sh {input} {output} >& {log}'
