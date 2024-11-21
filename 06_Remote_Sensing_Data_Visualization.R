# This script is for loading and visualizing satellite imagery / remote sensing (RS) data
# We use the terra and imageRy packages

install.packages("terra") # Install the terra package first
install.packages("devtools") # Install the devtools package, which is used to install packages from Github

library(devtools) # Load devtools package

# install the imageRy package from GitHub
install_github("ducciorocchini/imageRy")  # from devtools

library(imageRy) # Load imageRy package, used for handling satellite imagery
library(terra) # Load terra

# List the available images in the working directory
im.list()

# Let's import satellite data
# Import the blue band (B2) from Sentinel-2 image
b2 <- im.import("sentinel.dolomites.b2.tif") 
# b2 represents the blue wavelength band from the Sentinel-2 satellite image

cl <- colorRampPalette(c("black", "grey", "light grey")) (100) # Create color palette for plotting
plot(b2, col=cl) # Plot b2 using cl color palette

# Import the green band (B3) from Sentinel-2 image
b3 <- im.import("sentinel.dolomites.b3.tif") 
plot(b3, col=cl) # Plot b3 using cl color palette

# Import the red band (B4) from Sentinel-2 image
b4 <- im.import("sentinel.dolomites.b4.tif") 
plot(b4, col=cl) # Plot b4 using cl color palette

# Import the Near-Infrared (NIR) band from Sentinel-2 image
b8 <- im.import("sentinel.dolomites.b8.tif") 
plot(b8, col=cl) # Plot b8 using cl color palette

# Create a multiframe of 2 rows and 2 columns with all the images
par(mfrow=c(2,2))
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)
# Associate the bands with components


# Stack the imported bands into a single image stack
stacksent <- c(b2, b3, b4, b8)
plot(stacksent, col=cl) # Plot the stacked image with the cl color scheme

# We can also plot single layers of the stacked images
plot(stacksent[[4]], col=cl) # This will select the fourth image b8

# Exercise: Plot in a multiframe the bands with different color ramps
# Solution:

par(mfrow=c(2,2)) # Set up plotting area with 2 rows and 2 columns 

clb <- colorRampPalette(c("dark blue", "blue", "light blue")) (100) # Create blue based color palette
plot(b2, col=clb) # Plot b2 with blue based color palette

clg <- colorRampPalette(c("dark green", "green", "light green")) (100) # Create green based color palette
plot(b3, col=clg) # Plot b3 with green based color palette

clr <- colorRampPalette(c("dark red", "red", "pink")) (100) # Create red based color palette
plot(b4, col=clr) # Plot b4 with red based color palette

cln <- colorRampPalette(c("brown", "orange", "yellow")) (100) # Create another red based color palette
plot(b8, col=cln) # Plot b8 with a different red based color palette

# RGB space visualization
# Create RGB images by mapping different bands to the RGB channels

# sentstack[[1]] = blue
# sentstack[[2]] = green
# sentstack[[3]] = red
# sentstack[[4]] = NIR

# Standard RGB visualization: Red = b4, Green = b3, Blue = b2
im.plotRGB(stacksent, r=3, g=2, b=1)

# Enhanced RGB visualization with NIR: Red = NIR, Green = Red, Blue = Green
im.plotRGB(stacksent, r=4, g=3, b=2)

# Visualization with NIR as green: Red = Red, Green = NIR, Blue = Green
im.plotRGB(stacksent, r=3, g=4, b=2)
# Violet indicates bare soil, green indicates trees, and black indicates shadows

# Visualization with NIR as blue: Red = Red, Green = Green, Blue = NIR
im.plotRGB(stacksent, r=3, g=2, b=4)
# Moving NIR from green to blue shows all vegetation as blue

# These visualizations show the colors of reflectance, which is the ratio between incidence and radiance

# Correlation analysis between bands
# pairs() function can calculate the correlation between bands
pairs(stacksent)
# Scatter plots represent the correlation, more linear means more correlated
# The graphs represent how many times a certain reflectance value is observed
