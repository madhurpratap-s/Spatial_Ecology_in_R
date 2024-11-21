# This script visualizes vegetation indices using satellite imagery

# Load the required packages
library(imageRy)
library(terra)

# List the available images in the working directory
im.list()

# Import the 2006 image of Matogrosso from ASTER
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
# Note the Bands' labelling:
# Band 1 = NIR
# Band 2 = Red
# Band 3 = Green

# Plot the RGB combinations of the 2006 image
im.plotRGB(m2006, r=1, g=2, b=3) # NIR is put on red, everything red reflects NIR
im.plotRGB(m2006, r=3, g=2, b=1) # NIR on blue, vegetation becomes blue, bare soil is yellow
im.plotRGB(m2006, r=3, g=1, b=2) # NIR on green

# Import the ancient data, i.e., the 1992 image of the same location from Landsat 5
m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
im.plotRGB(m1992, r=1, g=2, b=3) # Plot the 1992 image with NIR on red

# Create a multiframe with 1992 and 2006 images for comparison
par(mfrow=c(1,2)) # Create plotting area with 1 row and 2 columns
im.plotRGB(m1992, r=1, g=2, b=3) # Plot the 1992 image with NIR on red
im.plotRGB(m2006, r=1, g=2, b=3) # Plot the 2006 image with NIR on red

# Exercise: Make a multiframe with 6 images in pairs with NIR on the same component
# Solution:

par(mfrow=c(3,2)) # Create plotting area with 3 rows and 2 columns
# First plot 1992 and 2006 images with r = 1
im.plotRGB(m1992, r=1, g=2, b=3)
im.plotRGB(m2006, r=1, g=2, b=3)
# Plot 1992 and 2006 images with g = 1
im.plotRGB(m1992, r=2, g=1, b=3)
im.plotRGB(m2006, r=2, g=1, b=3)
# Plot 1992 and 2006 images with b = 1
im.plotRGB(m1992, r=3, g=2, b=1)
im.plotRGB(m2006, r=3, g=2, b=1)

# DVI (Difference Vegeation Index) is used to estimate vegetation presence and density based on reflectance
# It is calculated as the difference: DVI = NIR - Red

# Calculate the Difference Vegetation Index in 1992
dvi1992 = m1992[[1]] - m1992[[2]]

cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100) # Create color palette for plotting DVI
plot(dvi1992, col=cl) # Plot the DVI values for 1992

# Calculate the Difference Vegetation Index in 2006
dvi2006 = m2006[[1]] - m2006[[2]]
plot(dvi2006, col=cl) # Plot the DVI values for 2006

# Create a multiframe to plot DVI for 1992 and 2006 side by side
par(mfrow=c(1,2)) # Create plotting region with 1 row and 2 columns
plot(dvi1992, col=cl) # Plot the 1992 DVI values
plot(dvi2006, col=cl) # Plot the 2006 DVI values

# Actually, one will face problem comparing DVI values of two images with different reflectance ranges
# For an 8 bit image, 256 unique reflectance values are possible from 0 to 256
# Reflectance is the ratio between incidence and reflected radiance flux. Bits represent information

# We thus define Normalized Difference Vegetation Index (NDVI)
# NDVI = (NIR - RED) / (NIR + RED)

# Calculate the NDVI values for 1992 and 2006
ndvi1992 = dvi1992 / (m1992[[1]] + m1992[[2]])
ndvi2006 = dvi2006 / (m2006[[1]] + m2006[[2]])

# Create a multiframe to plot NDVI for 1992 and 2006 side by side
par(mfrow=c(1,2)) # Create plotting region with 1 row and 2 columns
plot(ndvi1992, col=cl) # Plot the 1992 NDVI values
plot(ndvi2006, col=cl) # Plot the 2006 NDVI values
