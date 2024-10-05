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
outfile3 <- commandArgs(trailingOnly=TRUE)[11]
outfile4 <- commandArgs(trailingOnly=TRUE)[12]

# Loading
source_exp <- read.csv(infile1, header=TRUE)
target_exp <- read.csv(infile2, header=TRUE)
source_celltype <- read.csv(infile3, header=TRUE)
target_celltype <- read.csv(infile4, header=TRUE)
source_x_coordinate <- unlist(read.csv(infile5, header=FALSE))
target_x_coordinate <- unlist(read.csv(infile6, header=FALSE))
source_y_coordinate <- unlist(read.csv(infile7, header=FALSE))
target_y_coordinate <- unlist(read.csv(infile8, header=FALSE))

print(length(source_exp))
print(length(target_exp))
print(dim(source_celltype))
print(dim(target_celltype))
print(length(source_x_coordinate))
print(length(target_x_coordinate))
print(length(source_y_coordinate))
print(length(target_y_coordinate))

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
png(outfile1, width=1200, height=1200, bg="transparent")
.plot_tissue_section(source_x_coordinate, source_y_coordinate,
    source_exp, cex=3)
dev.off()

png(outfile2, width=1200, height=1200, bg="transparent")
.plot_tissue_section(target_x_coordinate, target_y_coordinate,
    target_exp, cex=2)
dev.off()

png(outfile3, width=1200, height=1200, bg="transparent")
.plot_tissue_section2(source_x_coordinate, source_y_coordinate,
	source_celltype, cex=3, position="topright")
dev.off()

png(outfile4, width=1200, height=1200, bg="transparent")
.plot_tissue_section2(target_x_coordinate, target_y_coordinate,
	target_celltype, cex=2, position="topright")
dev.off()
