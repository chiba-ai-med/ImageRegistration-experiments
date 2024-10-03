import pandas as pd
from snakemake.utils import min_version

#################################
# Setting
#################################
min_version("8.10.0")

SAMPLES = ['sma_neg_trs', 'public_neg_trs_1', 'public_neg_trs_2', 'public_neg_trs_3']

container: 'docker://koki/ir-experiments:20241001'

rule all:
    input:
        expand('data/{sample}/source/x.csv', sample=SAMPLES),
        expand('data/{sample}/target/x.csv', sample=SAMPLES),
        expand('data/{sample}/source/y.csv', sample=SAMPLES),
        expand('data/{sample}/target/y.csv', sample=SAMPLES),
        expand('data/{sample}/source/exp.csv', sample=SAMPLES),
        expand('data/{sample}/target/exp.csv', sample=SAMPLES),
        expand('data/{sample}/source/sum_exp.csv', sample=SAMPLES),
        expand('data/{sample}/target/sum_exp.csv', sample=SAMPLES),
        expand('data/{sample}/source/bin_sum_exp.csv', sample=SAMPLES),
        expand('data/{sample}/target/bin_sum_exp.csv', sample=SAMPLES),
        expand('data/{sample}/source/celltype.csv', sample=SAMPLES),
        expand('data/{sample}/target/celltype.csv', sample=SAMPLES),
        
        expand('data/{sample}/source/x_resize.csv', sample=SAMPLES),
        expand('data/{sample}/target/x_resize.csv', sample=SAMPLES),
        expand('data/{sample}/source/y_resize.csv', sample=SAMPLES),
        expand('data/{sample}/target/y_resize.csv', sample=SAMPLES),
        expand('data/{sample}/source/exp_resize.csv', sample=SAMPLES),
        expand('data/{sample}/target/exp_resize.csv', sample=SAMPLES),
        expand('data/{sample}/source/sum_exp_resize.csv', sample=SAMPLES),
        expand('data/{sample}/target/sum_exp_resize.csv', sample=SAMPLES),
        expand('data/{sample}/source/bin_sum_exp_resize.csv', sample=SAMPLES),
        expand('data/{sample}/target/bin_sum_exp_resize.csv', sample=SAMPLES),
        expand('data/{sample}/source/celltype_resize.csv', sample=SAMPLES),
        expand('data/{sample}/target/celltype_resize.csv', sample=SAMPLES)

rule preprocess_csv:
    output:
        'data/{sample}/source/exp.csv',
        'data/{sample}/target/exp.csv',
        'data/{sample}/source/all_exp.csv',
        'data/{sample}/target/all_exp.csv',
        'data/{sample}/source/sum_exp.csv',
        'data/{sample}/target/sum_exp.csv',
        'data/{sample}/source/bin_sum_exp.csv',
        'data/{sample}/target/bin_sum_exp.csv',
        'data/{sample}/source/celltype.csv',
        'data/{sample}/target/celltype.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_csv_{sample}.txt'
    log:
        'logs/preprocess_csv_{sample}.log'
    shell:
        'src/preprocess_csv_{wildcards.sample}.sh {output} >& {log}'

# CSV => PNG (5000 × 5000)
rule preprocess_csv2png:
    input:
        'data/{sample}/source/exp.csv',
        'data/{sample}/target/exp.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/source/source.png',
        'plot/{sample}/target/target.png'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_csv2png_{sample}.txt'
    log:
        'logs/preprocess_csv2png_{sample}.log'
    shell:
        'src/preprocess_csv2png.sh {input} {output} 1 >& {log}'

rule preprocess_csv2png_sum:
    input:
        'data/{sample}/source/sum_exp.csv',
        'data/{sample}/target/sum_exp.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/source/source_sum.png',
        'plot/{sample}/target/target_sum.png'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_csv2png_sum_{sample}.txt'
    log:
        'logs/preprocess_csv2png_sum_{sample}.log'
    shell:
        'src/preprocess_csv2png.sh {input} {output} 1 >& {log}'

rule preprocess_csv2png_bin_sum:
    input:
        'data/{sample}/source/bin_sum_exp.csv',
        'data/{sample}/target/bin_sum_exp.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/source/bin_source_sum.png',
        'plot/{sample}/target/bin_target_sum.png'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_csv2png_bin_sum_{sample}.txt'
    log:
        'logs/preprocess_csv2png_bin_sum_{sample}.log'
    shell:
        'src/preprocess_csv2png.sh {input} {output} 0 >& {log}'

rule preprocess_csv2png_celltype:
    input:
        'data/{sample}/source/celltype.csv',
        'data/{sample}/target/celltype.csv',
        'data/{sample}/source/x.csv',
        'data/{sample}/target/x.csv',
        'data/{sample}/source/y.csv',
        'data/{sample}/target/y.csv'
    output:
        'plot/{sample}/source/FINISH_celltype',
        'plot/{sample}/target/FINISH_celltype'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_csv2png_celltype_{sample}.txt'
    log:
        'logs/preprocess_csv2png_celltype_{sample}.log'
    shell:
        'src/preprocess_csv2png_celltype.sh {input} {output} >& {log}'

# PNG => CSV
rule preprocess_png2csv_coordinate:
    input:
        'plot/{sample}/source/bin_source_sum.png',
        'plot/{sample}/target/bin_target_sum.png'
    output:
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_png2csv_coordinate_{sample}.txt'
    log:
        'logs/preprocess_png2csv_coordinate_{sample}.log'
    shell:
        'src/preprocess_png2csv_coordinate.sh {input} {output} >& {log}'

rule preprocess_png2csv:
    input:
        'plot/{sample}/source/source.png',
        'plot/{sample}/target/target.png',
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    output:
        'data/{sample}/source/exp_resize.csv',
        'data/{sample}/target/exp_resize.csv'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_png2csv_{sample}.txt'
    log:
        'logs/preprocess_png2csv_{sample}.log'
    shell:
        'src/preprocess_png2csv.sh {input} {output} >& {log}'

rule preprocess_png2csv_sum:
    input:
        'plot/{sample}/source/source_sum.png',
        'plot/{sample}/target/target_sum.png',
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    output:
        'data/{sample}/source/sum_exp_resize.csv',
        'data/{sample}/target/sum_exp_resize.csv'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_png2csv_sum_{sample}.txt'
    log:
        'logs/preprocess_png2csv_sum_{sample}.log'
    shell:
        'src/preprocess_png2csv.sh {input} {output} >& {log}'

rule preprocess_png2csv_bin_sum:
    input:
        'plot/{sample}/source/bin_source_sum.png',
        'plot/{sample}/target/bin_target_sum.png',
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    output:
        'data/{sample}/source/bin_sum_exp_resize.csv',
        'data/{sample}/target/bin_sum_exp_resize.csv'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_png2csv_bin_sum_{sample}.txt'
    log:
        'logs/preprocess_png2csv_bin_sum_{sample}.log'
    shell:
        'src/preprocess_png2csv.sh {input} {output} >& {log}'

rule preprocess_png2csv_celltype:
    input:
        'plot/{sample}/source/FINISH_celltype',
        'plot/{sample}/target/FINISH_celltype',
        'data/{sample}/source/x_resize.csv',
        'data/{sample}/target/x_resize.csv',
        'data/{sample}/source/y_resize.csv',
        'data/{sample}/target/y_resize.csv'
    output:
        'data/{sample}/source/celltype_resize.csv',
        'data/{sample}/target/celltype_resize.csv'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_png2csv_celltype_{sample}.txt'
    log:
        'logs/preprocess_png2csv_celltype_{sample}.log'
    shell:
        'src/preprocess_png2csv_celltype.sh {input} {output} >& {log}'