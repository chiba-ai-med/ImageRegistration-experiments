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
        # Datasets
        expand('plot/{sample}/source/source.png', sample=SAMPLES),
        expand('plot/{sample}/target/target.png', sample=SAMPLES),
        expand('plot/{sample}/source/source_density.png', sample=SAMPLES),
        expand('plot/{sample}/target/target_density.png', sample=SAMPLES),
        expand('plot/{sample}/source/celltype.png', sample=SAMPLES),
        expand('plot/{sample}/target/celltype.png', sample=SAMPLES),
        expand('plot/{sample}/source/res_fix/source.png', sample=SAMPLES),
        expand('plot/{sample}/target/res_fix/target.png', sample=SAMPLES),
        expand('plot/{sample}/source/res_fix/source_density.png', sample=SAMPLES),
        expand('plot/{sample}/target/res_fix/target_density.png', sample=SAMPLES),
        expand('plot/{sample}/source/res_fix/celltype.png', sample=SAMPLES),
        expand('plot/{sample}/target/res_fix/celltype.png', sample=SAMPLES),
        # ANTsPy (R Plot)
        expand('plot/{sample}/{antsmode}/warped_r_1.png',
            sample=SAMPLES, antsmode=ANTSMODES),
        expand('plot/{sample}/{antsmode}/warped_r_2.png',
            sample=SAMPLES, antsmode=ANTSMODES),
        expand('plot/{sample}/{antsmode}/warped_sum_r_1.png',
            sample=SAMPLES, antsmode=ANTSMODES),
        expand('plot/{sample}/{antsmode}/warped_sum_r_2.png',
            sample=SAMPLES, antsmode=ANTSMODES),
        # SimpleITK (R Plot)
        expand('plot/{sample}/{sitkmode}/warped_r_1.png',
            sample=SAMPLES, sitkmode=SITKMODES),
        expand('plot/{sample}/{sitkmode}/warped_r_2.png',
            sample=SAMPLES, sitkmode=SITKMODES),
        expand('plot/{sample}/{sitkmode}/warped_sum_r_1.png',
            sample=SAMPLES, sitkmode=SITKMODES),
        expand('plot/{sample}/{sitkmode}/warped_sum_r_2.png',
            sample=SAMPLES, sitkmode=SITKMODES),
        expand('plot/{sample}/{sitkmode}/warped_bin_sum_r_1.png',
            sample=SAMPLES, sitkmode=SITKMODES),
        expand('plot/{sample}/{sitkmode}/warped_bin_sum_r_2.png',
            sample=SAMPLES, sitkmode=SITKMODES),
        # OT
        expand('plot/{sample}/sk/{skp}/FINISH',
            sample=SAMPLES, skp=SK_PARAMETERS),
        expand('plot/{sample}/gw1/{gw1p}/FINISH',
            sample=SAMPLES, gw1p=GW1_PARAMETERS),
        expand('plot/{sample}/gw2/{gw2p}/FINISH',
            sample=SAMPLES, gw2p=GW2_PARAMETERS),
        expand('plot/{sample}/fgw/{fgwp}/FINISH',
            sample=SAMPLES, fgwp=FGW_PARAMETERS),
        expand('plot/{sample}/merged_gw/{merged_gwp}/FINISH',
            sample=SAMPLES, merged_gwp=MERGED_GW_PARAMETERS),
        expand('plot/{sample}/qgw/{qgwp}/FINISH',
            sample=SAMPLES, qgwp=QGW_PARAMETERS),
        expand('plot/{sample}/merged_qgw/{merged_qgwp}/FINISH',
            sample=SAMPLES, merged_qgwp=MERGED_QGW_PARAMETERS),
        # Evaluation Mesures
        'plot/cc.png',
        'plot/jaccard.png'

# Datasets
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
        'plot/{sample}/source/source.png',
        'plot/{sample}/target/target.png',
        'plot/{sample}/source/source_density.png',
        'plot/{sample}/target/target_density.png',
        'plot/{sample}/source/celltype.png',
        'plot/{sample}/target/celltype.png',
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
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
        'data/{sample}/target/celltype_res_fix.csv',
        'data/{sample}/source/x_res_fix.csv',
        'data/{sample}/target/x_res_fix.csv',
        'data/{sample}/source/y_res_fix.csv',
        'data/{sample}/target/y_res_fix.csv'
    output:
        'plot/{sample}/source/res_fix/source.png',
        'plot/{sample}/target/res_fix/target.png',
        'plot/{sample}/source/res_fix/source_density.png',
        'plot/{sample}/target/res_fix/target_density.png',
        'plot/{sample}/source/res_fix/celltype.png',
        'plot/{sample}/target/res_fix/celltype.png'
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_{sample}_res_fix.txt'
    log:
        'logs/plot_{sample}_res_fix.log'
    shell:
        'src/plot_{wildcards.sample}.sh {input} {output} >& {log}'

# ANTsPy
rule plot_antspy_r:
    input:
        'output/{antsmode}/{sample}/warped.csv',
        'output/{antsmode}/{sample}/warped_vec.csv',
        'data/{sample}/target/x_res_fix.csv',
        'data/{sample}/target/y_res_fix.csv'
    output:
        'plot/{sample}/{antsmode}/warped_r_1.png',
        'plot/{sample}/{antsmode}/warped_r_2.png'
    wildcard_constraints:
        antsmode='|'.join([re.escape(x) for x in ANTSMODES])
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_antspy_r_{sample}_{antsmode}.txt'
    log:
        'logs/plot_antspy_r_{sample}_{antsmode}.log'
    shell:
        'src/plot_ir_r.sh {input} {output} >& {log}'

rule plot_antspy_sum_r:
    input:
        'output/{antsmode}/{sample}/warped_sum.csv',
        'output/{antsmode}/{sample}/warped_sum_vec.csv',
        'data/{sample}/target/x_res_fix.csv',
        'data/{sample}/target/y_res_fix.csv'
    output:
        'plot/{sample}/{antsmode}/warped_sum_r_1.png',
        'plot/{sample}/{antsmode}/warped_sum_r_2.png'
    wildcard_constraints:
        antsmode='|'.join([re.escape(x) for x in ANTSMODES])
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_antspy_sum_r_{sample}_{antsmode}.txt'
    log:
        'logs/plot_antspy_sum_r_{sample}_{antsmode}.log'
    shell:
        'src/plot_ir_r.sh {input} {output} >& {log}'

rule plot_antspy_bin_sum_r:
    input:
        'output/{antsmode}/{sample}/warped_bin_sum.csv',
        'output/{antsmode}/{sample}/warped_bin_sum_vec.csv',
        'data/{sample}/target/x_res_fix.csv',
        'data/{sample}/target/y_res_fix.csv'
    output:
        'plot/{sample}/{antsmode}/warped_bin_sum_r_1.png',
        'plot/{sample}/{antsmode}/warped_bin_sum_r_2.png'
    wildcard_constraints:
        antsmode='|'.join([re.escape(x) for x in ANTSMODES])
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_antspy_bin_sum_r_{sample}_{antsmode}.txt'
    log:
        'logs/plot_antspy_bin_sum_r_{sample}_{antsmode}.log'
    shell:
        'src/plot_ir_r.sh {input} {output} >& {log}'

# SimpleITK
rule plot_sitk_r:
    input:
        'output/{sitkmode}/{sample}/warped.csv',
        'output/{sitkmode}/{sample}/warped_vec.csv',
        'data/{sample}/target/x_res_fix.csv',
        'data/{sample}/target/y_res_fix.csv'
    output:
        'plot/{sample}/{sitkmode}/warped_r_1.png',
        'plot/{sample}/{sitkmode}/warped_r_2.png'
    wildcard_constraints:
        sitkmode='|'.join([re.escape(x) for x in SITKMODES])
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_sitk_r_{sample}_{sitkmode}.txt'
    log:
        'logs/plot_sitk_r_{sample}_{sitkmode}.log'
    shell:
        'src/plot_ir_r.sh {input} {output} >& {log}'

rule plot_sitk_sum_r:
    input:
        'output/{sitkmode}/{sample}/warped_sum.csv',
        'output/{sitkmode}/{sample}/warped_sum_vec.csv',
        'data/{sample}/target/x_res_fix.csv',
        'data/{sample}/target/y_res_fix.csv'
    output:
        'plot/{sample}/{sitkmode}/warped_sum_r_1.png',
        'plot/{sample}/{sitkmode}/warped_sum_r_2.png'
    wildcard_constraints:
        sitkmode='|'.join([re.escape(x) for x in SITKMODES])
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_sitk_sum_r_{sample}_{sitkmode}.txt'
    log:
        'logs/plot_sitk_sum_r_{sample}_{sitkmode}.log'
    shell:
        'src/plot_ir_r.sh {input} {output} >& {log}'

rule plot_sitk_bin_sum_r:
    input:
        'output/{sitkmode}/{sample}/warped_bin_sum.csv',
        'output/{sitkmode}/{sample}/warped_bin_sum_vec.csv',
        'data/{sample}/target/x_res_fix.csv',
        'data/{sample}/target/y_res_fix.csv'
    output:
        'plot/{sample}/{sitkmode}/warped_bin_sum_r_1.png',
        'plot/{sample}/{sitkmode}/warped_bin_sum_r_2.png'
    wildcard_constraints:
        sitkmode='|'.join([re.escape(x) for x in SITKMODES])
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_sitk_bin_sum_r_{sample}_{sitkmode}.txt'
    log:
        'logs/plot_sitk_bin_sum_r_{sample}_{sitkmode}.log'
    shell:
        'src/plot_ir_r.sh {input} {output} >& {log}'

# OT
rule plot_sk:
    input:
        'output/sk/{sample}/{skp}/warped.txt',
        'data/{sample}/target/x.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/sk/{skp}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_sk_{sample}_{skp}.txt'
    log:
        'logs/plot_sk_{sample}_{skp}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_gw1:
    input:
        'output/gw1/{sample}/{gw1p}/warped.txt',
        'data/{sample}/target/x.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/gw1/{gw1p}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_gw1_{sample}_{gw1p}.txt'
    log:
        'logs/plot_gw1_{sample}_{gw1p}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_gw2:
    input:
        'output/gw2/{sample}/{gw2p}/warped.txt',
        'data/{sample}/target/x.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/gw2/{gw2p}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_gw2_{sample}_{gw2p}.txt'
    log:
        'logs/plot_gw2_{sample}_{gw2p}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_fgw:
    input:
        'output/fgw/{sample}/{fgwp}/warped.txt',
        'data/{sample}/target/x.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/fgw/{fgwp}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_fgw_{sample}_{fgwp}.txt'
    log:
        'logs/plot_fgw_{sample}_{fgwp}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_merged_gw:
    input:
        'output/merged_gw/{sample}/{merged_gwp}/warped.txt',
        'data/{sample}/target/x.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/merged_gw/{merged_gwp}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_merged_gw_{sample}_{merged_gwp}.txt'
    log:
        'logs/plot_merged_gw_{sample}_{merged_gwp}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_qgw:
    input:
        'output/qgw/{sample}/{qgwp}/warped.txt',
        'data/{sample}/target/x.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/qgw/{qgwp}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_qgw_{sample}_{qgwp}.txt'
    log:
        'logs/plot_qgw_{sample}_{qgwp}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_merged_qgw:
    input:
        'output/merged_qgw/{sample}/{merged_qgwp}/warped.txt',
        'data/{sample}/target/x.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/merged_qgw/{merged_qgwp}/FINISH'
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_merged_qgw_{sample}_{merged_qgwp}.txt'
    log:
        'logs/plot_merged_qgw_{sample}_{merged_qgwp}.log'
    shell:
        'src/plot_ot.sh {input} {output} >& {log}'

rule plot_cc:
    output:
        'plot/cc.png'
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_cc.txt'
    log:
        'logs/plot_cc.log'
    shell:
        'src/plot_cc.sh {output} >& {log}'

rule plot_jaccard:
    output:
        'plot/jaccard.png'
    container:
        'docker://koki/ir-experiments-r:20240929'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/plot_jaccard.txt'
    log:
        'logs/plot_jaccard.log'
    shell:
        'src/plot_jaccard.sh {output} >& {log}'
