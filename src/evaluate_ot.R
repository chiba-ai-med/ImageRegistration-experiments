# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile1 <- commandArgs(trailingOnly=TRUE)[3]
outfile2 <- commandArgs(trailingOnly=TRUE)[4]

# Loading
warped_exp <- read.csv(infile1, header=TRUE)
target_exp <- unlist(read.csv(infile2, header=FALSE))

if((length(grep("public_neg_trs_1", infile1)) != 0) || (length(grep("sma_neg_trs", infile1)) != 0)){
    warped_exp <- warped_exp[, "SHexCer.42.1.2O"]
}
if(length(grep("public_neg_trs_2", infile1)) != 0){
    warped_exp <- warped_exp[, "SHexCer.42.1.3O"]
}
if(length(grep("public_neg_trs_3", infile1)) != 0){
    warped_exp <- warped_exp[, "SHexCer.42.2.3O"]
}

# Correlation
out1 <- cor(warped_exp, target_exp, method="pearson")

# Jaccard index
out2 <- 1

# Save
write.table(out1, outfile1, row.names=FALSE, col.names=FALSE)
write.table(out2, outfile2, row.names=FALSE, col.names=FALSE)
