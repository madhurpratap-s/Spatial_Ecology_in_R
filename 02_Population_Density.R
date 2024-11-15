# Population Ecology analysis using Spatstat package

# spatstat is an R package used for spatial statistics with a strong focus on analysing spatial point patterns in 2d,
# (with some support for 3D and very basic support for space-time)

# Install and load the required package for point pattern analysis
install.packages("spatstat")
library(spatstat)

# We'll use the 'bei' dataset included in the spatstat package
# It contains the locations of trees in a geographical region
# More details at https://cran.r-project.org/web/packages/spatstat/index.html
bei

# Plot the tree locations
plot(bei)

# Plot the tree locations with a solid circle (pch = 19)
plot(bei, pch=19)

# Modify the plot by changing symbol size (cex)
plot(bei, pch=19, cex=.5)

# Additional dataset: 'bei.extra' which includes elevation and gradient data
bei.extra

# Plot 'elev' (Elevation) and 'grad' (Gradient) images present in bei.extra
plot(bei.extra)

# In order to take only the elevation part of the dataset, let's use $ sign to link
# Extract and plot the elevation data from 'bei.extra'
elevation <- bei.extra$elev
plot(elevation)

# There is an alternative method to extract elements from a list
# We use double brackets here as we want to extract a single element from a list
elevation2 <- bei.extra[[1]]
# For tables or subsets, we use single brackets

# We can create a kernel density estimate of the spatial point pattern
# This density estimate smooths the point pattern into a continous surface, providing an estimate of density of points across the study region
densitymap <- density(bei)
plot(densitymap)
# We can overlay the original tree points on the density map 
points(bei, cex = 0.1)

######## DAY 2

# A multiframe in R is a collection of multiple plots displayed together

# Plotting the elevation and density maps one beside the other
par(mfrow=c(1,2)) # This means we have 1 row and 2 columns
plot(elevation2)
plot(densitymap)

# Exercise: make a multiframe with maps one on top of the other
# Solution: use mfrow=c(2,1) so that we have 2 rows and 1 column
par(mfrow=c(2,1))
plot(elevation2)
plot(densitymap)

# One friend to close the current graphics device, clearing the last plot
dev.off()

# colorRampPalette creates custom color palettes by interpolating between specified colours

# Create a custom color palette with 3 colors and plot density map using cl
cl <- colorRampPalette(c("red", "orange", "yellow"))(3)
plot(densitymap, col=cl)

# Increase the number of colors in the pallete to see improvement in smoothness of plot
cl <- colorRampPalette(c("red", "orange", "yellow"))(10)
plot(densitymap, col=cl)

# Further increase smoothness by going to a 100 colors
cl <- colorRampPalette(c("red", "orange", "yellow"))(100)
plot(densitymap, col=cl)

# To find all available colours, one can search in browser for "colors in R" 
# R colors cheat-sheet by Dr. Ying Wei: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

# Exercise: change the color ramp palette using different colors
# Solution:

cln <- colorRampPalette(c("gold", "darkorchid", "mediumaquamarine", "salmon"))(100)
plot(densitymap, col=cln)

# Exrcise: build a multiframe and plot the densitymap with two different color ramp palettes one beside the other
# Solution:

par(mfrow=c(1,2))

cln <- colorRampPalette(c("turquoise", "coral", "plum", "forestgreen"))(100)
plot(densitymap, col=cln)

clg <- colorRampPalette(c("crimson", "saddlebrown", "slateblue", "goldenrod"))(100)
plot(densitymap, col=clg)

# Color customization: To make maps color-blind friendly, it's important to avoid using certain color combinations
# People with color vision deficiencies (e.g., Daltonism) may have difficulty distinguishing between red, green, and blue
# To ensure inclusivity, consider using color palettes that are distinguishable to everyone
