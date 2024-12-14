# Let's use R to do time series analysis

# Load necessary libraries
library(terra)
library(imageRy)

# List all available images in the working directory
im.list()

# Import the data
EN01 <- im.import("EN_01.png")
EN13 <- im.import("EN_13.png")

# Create a multi-frame layout to diplay the images
par(mfrow = c(1,2))
plot(EN01)
plot(EN13)

# Calculate the difference between the two images (for band 1)
difEN = EN01[[1]] - EN13[[1]]
plot(difEN) # Plot the difference

# Example: Temperature in Greenland

# Import all images titled "greenland.~" together
gr <- im.import("greenland") 
# Now we have images from 2000, 2005, 2010 and 2015

# Create a multi-frame layout to diplay images from 2000 and 2015
par(mfrow=c(1,2))
plot(gr[[1]]) # First image corresponds to 2000 data
plot(gr[[4]]) # Fourth image corresponds to 2015 data

# Calculate the difference between 2000 and 2015 images (for band 1)
difgr <- gr[[1]] - gr[[4]]
plot(difgr) # Plot the difference

# Exercise: Make an RGB plot using different years
# Solution:

im.plotRGB(gr, r=1, g=2, b=4) # Assign 2000 to red, 2005 to green and 2015 to blue

# Note that using satellite images of the same region taken over time, we can monitor important changes
