source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
infile4 <- commandArgs(trailingOnly=TRUE)[4]
infile5 <- commandArgs(trailingOnly=TRUE)[5]
infile6 <- commandArgs(trailingOnly=TRUE)[6]
infile7 <- commandArgs(trailingOnly=TRUE)[7]
infile8 <- commandArgs(trailingOnly=TRUE)[8]
outfile1 <- commandArgs(trailingOnly=TRUE)[9]
outfile2 <- commandArgs(trailingOnly=TRUE)[10]
# infile1 = 'data/sma_neg_trs/source/exp.csv'
# infile2 = 'data/sma_neg_trs/target/exp.csv'
# infile3 = 'data/sma_neg_trs/source/celltype.csv'
# infile4 = 'data/sma_neg_trs/target/celltype.csv'
# infile5 = 'data/sma_neg_trs/source/x.csv'
# infile6 = 'data/sma_neg_trs/target/x.csv'
# infile7 = 'data/sma_neg_trs/source/y.csv'
# infile8 = 'data/sma_neg_trs/target/y.csv'

# Loading
source_exp <- read.csv(infile1, header=TRUE)
target_exp <- read.csv(infile2, header=TRUE)
source_celltype <- read.csv(infile3, header=TRUE)
target_celltype <- read.csv(infile4, header=TRUE)
source_x_coordinate <- unlist(read.csv(infile5, header=FALSE))
target_x_coordinate <- unlist(read.csv(infile6, header=FALSE))
source_y_coordinate <- unlist(read.csv(infile7, header=FALSE))
target_y_coordinate <- unlist(read.csv(infile8, header=FALSE))

# Pre-processing
source_exp <- unlist(source_exp)
target_exp <- unlist(target_exp)

source_exp <- log10(source_exp + 1)
target_exp <- log10(target_exp + 1)

source_celltype <- apply(source_celltype, 1, function(x){
	colnames(source_celltype)[which(x == max(x))[1]]
})
target_celltype <- apply(target_celltype, 1, function(x){
	colnames(target_celltype)[which(x == max(x))[1]]
})

# Plot
outdir_source <- gsub("FINISH", "", outfile1)
outdir_target <- gsub("FINISH", "", outfile2)

print("Plot (Source)")
outfile_source <- paste0(outdir_source, "SHexCer.png")
png(outfile_source, width=1200, height=1200, bg="transparent")
.plot_tissue_section(source_x_coordinate, source_y_coordinate,
    source_exp, cex=2)
dev.off()

print("Plot (Target)")
outfile_target <- paste0(outdir_target, "Gal3st1.png")
png(outfile_target, width=1000, height=1000, bg="transparent")
.plot_tissue_section(target_x_coordinate, target_y_coordinate,
    target_exp, cex=2)
dev.off()

print("Plot (Source <Celltype>)")
outfile_source_celltype <- paste0(outdir_source, "celltype.png")
png(outfile_source_celltype, width=1200, height=1200, bg="transparent")
.plot_tissue_section2(source_x_coordinate, source_y_coordinate,
	source_celltype, cex=2, position="topright")
dev.off()

print("Plot (Target <Celltype>)")
outfile_target_celltype <- paste0(outdir_target, "celltype.png")
png(outfile_target_celltype, width=1000, height=1000, bg="transparent")
.plot_tissue_section2(target_x_coordinate, target_y_coordinate,
	target_celltype, cex=2, position="topleft")
dev.off()

# Save
file.create(outfile1)
file.create(outfile2)
