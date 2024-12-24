# Code to measure RS based variability

# Load the necessary packages
library(imageRy) # For image import and manipulation
library(terra)   # For raster data processing
library(viridis) # For creating perceptually uniform color palettes

# List all available images in the imageRy package
im.list()

# Import the sentinel image 
sent <- im.import("sentinel.png")
# Band 1 - NIR (Near-Infrared), Band 2 - Red, Band 3 - Green

# Plot the image using different RGB combinations
im.plotRGB(sent, r=1, g=2, b=3) 
im.plotRGB(sent, r=2, g=1, b=3)
im.plotRGB(sent, r=2, g=3, b=1)

# Extract the NIR band from the Sentinal image
nir <- sent[[1]]
plot(nir)

# focal() function in terra package is used to apply a function to a moving window over a raster image
# This allows us to carry out neighborhood-based computations, such as smoothing, filtering,
# or compute statistics such as mean, median or variance
sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd) # Calculate the std. dev. for each 3x3 neighborhood for nir
# Note: 1/9 above ensures that the weights are equal

plot(sd3)
plot(sd3, col = magma(100)) # Plot using magma palette with 100 colors

# Exercise: Calculate standard deviation over 7x7 pixels (moving window)
# Solution:
# Change the matrix size to 7x7 with every element having value 1/49 (equal weight)
sd7 <- focal(nir, matrix(1/49, 7, 7), fun=sd)
plot(sd7)

plot(sd7, col = inferno(100)) # Plot using inferno palette with 100 colors

# Create a multiframe to plot the 3x3 and 7x7 standard deviation
par(mfrow=c(1,2))
plot(sd3)
plot(sd7)

# Create a multiframe to plot the original image and 7x7 standard deviation
par(mfrow=c(1,2))
im.plotRGB(sent, r=2, g=1, b=3)
plot(sd7)
