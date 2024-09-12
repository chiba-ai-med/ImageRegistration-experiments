# DAG graph
snakemake -s workflow/preprocess.smk --rulegraph | dot -Tpng > plot/preprocess.png
snakemake -s workflow/ir.smk --rulegraph | dot -Tpng > plot/ir.png
snakemake -s workflow/evaluation.smk --rulegraph | dot -Tpng > plot/evaluation.png
snakemake -s workflow/plot.smk --rulegraph | dot -Tpng > plot/plot.png
