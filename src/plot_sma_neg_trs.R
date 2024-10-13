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
outfile5 <- commandArgs(trailingOnly=TRUE)[13]
outfile6 <- commandArgs(trailingOnly=TRUE)[14]

# Loading
source_exp <- read.csv(infile1, header=FALSE)
target_exp <- read.csv(infile2, header=FALSE)
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
## Slice Plot (Expression)
png(outfile1, width=1200, height=1200, bg="transparent")
.plot_tissue_section(source_x_coordinate, source_y_coordinate,
    source_exp, cex=2)
dev.off()

png(outfile2, width=1000, height=1000, bg="transparent")
.plot_tissue_section(target_x_coordinate, target_y_coordinate,
    target_exp, cex=2)
dev.off()

## Density Plot (Expression)
source_exp <- data.frame(Expression = source_exp)
g1 <- ggplot(source_exp, aes(x = Expression)) +
	geom_density(fill="red", alpha = 0.5) +
	labs(x = "Log10(Expression + 1)", y = "Density")
ggsave(outfile3, plot=g1, width = 12, height = 6, bg = "transparent")

target_exp <- data.frame(Expression = target_exp)
g2 <- ggplot(target_exp, aes(x = Expression)) +
	geom_density(fill="blue", alpha = 0.5) +
	labs(x = "Log10(Expression + 1)", y = "Density")
ggsave(outfile4, plot=g2, width = 12, height = 6, bg = "transparent")

## Slice Plot (Celltype)
png(outfile5, width=1200, height=1200, bg="transparent")
.plot_tissue_section2(source_x_coordinate, source_y_coordinate,
	source_celltype, cex=2, position="topleft")
dev.off()

png(outfile6, width=1000, height=1000, bg="transparent")
.plot_tissue_section2(target_x_coordinate, target_y_coordinate,
	target_celltype, cex=2, position="topleft")
dev.off()
