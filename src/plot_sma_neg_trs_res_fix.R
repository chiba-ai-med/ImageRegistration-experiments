source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
infile4 <- commandArgs(trailingOnly=TRUE)[4]
outfile1 <- commandArgs(trailingOnly=TRUE)[5]
outfile2 <- commandArgs(trailingOnly=TRUE)[6]
# infile1 = 'data/sma_neg_trs/source/exp_res_fix.csv'
# infile2 = 'data/sma_neg_trs/target/exp_res_fix.csv'
# infile3 = 'data/sma_neg_trs/source/celltype_res_fix.csv'
# infile4 = 'data/sma_neg_trs/target/celltype_res_fix.csv'

# Loading
source_exp <- read.table(infile1, header=FALSE)
target_exp <- read.table(infile2, header=FALSE)
source_celltype <- read.csv(infile3, header=FALSE)
target_celltype <- read.csv(infile4, header=FALSE)

# Pre-processing
source_coordinate <- expand.grid(seq(nrow(source_exp)), seq(ncol(source_exp)))
source_x_coordinate <- source_coordinate[, 1]
source_y_coordinate <- source_coordinate[, 2]

target_coordinate <- expand.grid(seq(nrow(target_exp)), seq(ncol(target_exp)))
target_x_coordinate <- target_coordinate[, 1]
target_y_coordinate <- target_coordinate[, 2]

source_exp <- unlist(source_exp)
target_exp <- unlist(target_exp)

source_exp <- log10(source_exp + 1)
target_exp <- log10(target_exp + 1)

source_celltype <- unlist(source_celltype)
target_celltype <- unlist(target_celltype)

# Non-zero Values
source_index <- which(source_exp != 0)
source_exp <- source_exp[source_index]
source_x_coordinate <- source_x_coordinate[source_index]
source_y_coordinate <- source_y_coordinate[source_index]
source_celltype <- source_celltype[source_index]

target_index <- which(target_exp != 0)
target_exp <- target_exp[target_index]
target_x_coordinate <- target_x_coordinate[target_index]
target_y_coordinate <- target_y_coordinate[target_index]
target_celltype <- target_celltype[target_index]

# Plot
outdir_source <- gsub("FINISH_res_fix", "", outfile1)
outdir_target <- gsub("FINISH_res_fix", "", outfile2)

print("Plot (Source)")
outfile_source <- paste0(outdir_source, "SHexCer_res_fix.png")
png(outfile_source, width=1200, height=1200, bg="transparent")
.plot_tissue_section(source_x_coordinate, source_y_coordinate,
    source_exp, cex=2)
dev.off()

print("Plot (Target)")
outfile_target <- paste0(outdir_target, "Gal3st1_res_fix.png")
png(outfile_target, width=1000, height=1000, bg="transparent")
.plot_tissue_section(target_x_coordinate, target_y_coordinate,
    target_exp, cex=2)
dev.off()

print("Plot (Source <Celltype>)")
outfile_source_celltype <- paste0(outdir_source, "celltype_res_fix.png")
png(outfile_source_celltype, width=1200, height=1200, bg="transparent")
.plot_tissue_section2(source_x_coordinate, source_y_coordinate,
	source_celltype, cex=1, position="topright")
dev.off()

print("Plot (Target <Celltype>)")
outfile_target_celltype <- paste0(outdir_target, "celltype_res_fix.png")
png(outfile_target_celltype, width=1000, height=1000, bg="transparent")
.plot_tissue_section2(target_x_coordinate, target_y_coordinate,
	target_celltype, cex=1, position="topleft")
dev.off()

# Save
file.create(outfile1)
file.create(outfile2)
