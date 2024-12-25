# Code for doing Principal Component Analysis on Image data

# Load the necessary packages
library(imageRy) # For image import and manipulation
library(terra)   # For raster data processing
library(viridis) # For creating perceptually uniform color palettes

# List all available images in the imageRy package
im.list()

# Load the sentinel image
sent <- im.import("sentinel.png")

# The pairs() function is used to create a scatterplot matrix, allowing us to visualize correlations between multiple variables in a dataset
# A correlation coefficient of 1 indicates a perfect positive correlation, while -1 indicates a perfect negative correlation
pairs(sent)

# Perform PCA on the Sentinel image
sentpc <- im.pca(sent)

# Isolate PC1
pc1 <- sentpc$PC1
plot(pc1) # Plot PC1

# Create color palette for plotting
viridisc <- colorRampPalette(viridis(7))(255)
plot(pc1, col=viridisc) # Plot PC1 with viridisc color palette

# Calculation of standard deviation on top of PC1 using a 3x3 moving window
pc1sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)
plot(pc1sd3, col=viridisc) # Plot with viridisc color palette

# Calculation of standard deviation on top of PC1 using a 7x7 moving window
pc1sd7 <- focal(pc1, matrix(1/49, 7, 7), fun=sd)
plot(pc1sd7, col=viridisc)  # Plot with viridisc color palette

# Recalculating standard deviation as done in 11_Variability.R
nir <- sent[[1]] # Extract the NIR band from the Sentinal image
sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd) # Calculate the std. dev. for each 3x3 neighborhood for nir
sd7 <- focal(nir, matrix(1/49, 7, 7), fun=sd) # Calculate the std. dev. for each 7x7 neighborhood for nir

# Plot all the graphs together using multi-frame
par(mfrow=c(2,3)) # Set up plotting area with 2 rows and 3 columns
im.plotRGB(sent, r=2, g=1, b=3) # Plot the original Sentinel image using bands 2, 1, and 3
plot(sd3, col=viridisc)
plot(sd7, col=viridisc)
plot(pc1, col=viridisc)
plot(pc1sd3, col=viridisc)
plot(pc1sd7, col=viridisc)

# Stack all standard deviation layers 
sdstack <- c(sd3, sd7, pc1sd3, pc1sd7)
plot(sdstack, col=viridisc) # Plot the stack with viridisc color scale

# Assign names to the layers in the stack
names(sdstack) <- c("sd3", "sd7", "pc1sd3", "pc1sd7")
plot(sdstack, col=viridisc) # Plot the named stack with viridisc color scale
