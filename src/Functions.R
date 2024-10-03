library("Mus.musculus")
library("tagcloud")
library("viridis")
library("ggplot2")
library("fields")

.mycolor <- function(z){
smoothPalette(z,
	palfunc=colorRampPalette(
		viridis(100), alpha=TRUE))
}

.mycolor2 <- function(z){
	factor(z, levels=sort(unique(z)))
}

# Flip y-axis
.plot_tissue_section <- function(x, y, z, cex=1){
	plot(x, -y, col=.mycolor(z), pch=16, cex=cex, xaxt="n", yaxt="n", xlab="", ylab="", axes=FALSE)
}

.plot_tissue_section2 <- function(x, y, z, cex=1, position="topright"){
	plot(x, -y, col=.mycolor2(z), pch=16, cex=cex, xaxt="n", yaxt="n", xlab="", ylab="", axes=FALSE)
	legend(position, legend=sort(unique(z)),
		col=factor(sort(unique(z))), pch=16, cex=2)
}
