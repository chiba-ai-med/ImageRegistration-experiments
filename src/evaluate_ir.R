source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile1 <- commandArgs(trailingOnly=TRUE)[3]
outfile2 <- commandArgs(trailingOnly=TRUE)[4]

# Loading
warped_exp <- unlist(read.table(infile1, header=FALSE))
target_exp <- unlist(read.table(infile2, header=FALSE))

# Correlation
out1 <- cor(warped_exp, target_exp, method="pearson")

# Jaccard index
warped_exp_bin <- ifelse(warped_exp > 0, 1, 0)
target_exp_bin <- ifelse(target_exp > 0, 1, 0)
out2 <- jaccard(warped_exp_bin, target_exp_bin)

# Save
write.table(out1, outfile1, row.names=FALSE, col.names=FALSE)
write.table(out2, outfile2, row.names=FALSE, col.names=FALSE)
