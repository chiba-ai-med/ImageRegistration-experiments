source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
infile4 <- commandArgs(trailingOnly=TRUE)[4]
outfile1 <- commandArgs(trailingOnly=TRUE)[5]
outfile2 <- commandArgs(trailingOnly=TRUE)[6]

# Loading
t_source_exp <- as.matrix(read.table(infile1, header=FALSE))
t_source_exp_vec <- as.vector(read.csv(infile2, header=FALSE))[[1]]
target_x_coordinate <- unlist(read.csv(infile3, header=FALSE))
target_y_coordinate <- unlist(read.csv(infile4, header=FALSE))

# Plot
png(outfile1, width=1200, height=1200)
image.plot(t(t_source_exp[nrow(t_source_exp):1, ]))
dev.off()

png(outfile2, width=1200, height=1200, bg="transparent")
.plot_tissue_section(target_x_coordinate, target_y_coordinate, t_source_exp_vec, cex=1)
dev.off()
