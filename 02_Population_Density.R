# How to calculate the density of individuals in a population

# Installing the spatstat package
install.packages("spatstat")

# Recalling the package
library(spatstat)

# dataset
bei

plot(bei)
plot(bei, pch=19)
plot(bei, pch=19, cex=.5)

bei.extra
plot(bei.extra)

# Extracting data
elevation <- bei.extra$elev
plot(elevation)

elevation <- bei.extra[[1]]

# Density map starting from points
densitymap <- density(bei)
densitymap

plot(densitymap)
points(bei, col="green")

# Plotting the maps one beside the other
par(mfrow=c(1,2))
plot(elevation2)
plot(densitymap)

# Exercise: make a multiframe with maps one on top of the other
par(mfrow=c(2,1))
plot(elevation2)
plot(densitymap)

# one frined to clear graphs
dev.off()
plot(elevation2)

# Changin colors to maps
cl <- colorRampPalette(c("red", "orange", "yellow"))(3)
plot(densitymap, col=cl)

cl <- colorRampPalette(c("red", "orange", "yellow"))(10)
plot(densitymap, col=cl)

cl <- colorRampPalette(c("red", "orange", "yellow"))(100)
plot(densitymap, col=cl)

# search your browser for "colors in R" 
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

# Exercise: change the color ramp palette using different colors

cln <- colorRampPalette(c("purple1", "orchid2", "palegreen3", "paleturquoise"))(100)
plot(densitymap, col=cln)

# Exrcise: build a multiframe and plot the densitymap with two different color ramp palettes one beside the other

par(mfrow=c(1,2))

cln <- colorRampPalette(c("purple1", "orchid2", "palegreen3", "paleturquoise"))(100)
plot(densitymap, col=cln)

clg <- colorRampPalette(c("green4", "green3", "green2", "green1", "green"))(100)
plot(densitymap, col=clg)

dev.off()
