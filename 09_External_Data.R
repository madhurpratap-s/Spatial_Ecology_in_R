# Let's practise how to import external data

# Load the terra library
library(terra)

# Set the working directory based on where your data files are located
# Replace "your path" with the actual path of your data folder
setwd("C:/Users/madhu/Downloads")
# The path to the folder will depend on the OS of your computer
# Note that in windows, the path you get from windows explorer has opposite slashes that you need to change

# Now use "rast" function from terra package to import the raster image
naja <- rast("najafiraq_etm_2003140_lrg.jpg")  

# Plot the RGB image after assigning r, g and b according to your image bands 
plotRGB(naja, r=1, g=2, b=3) 

# Exercise: Download the second image from the same site and import it in R
# Solution:

# After downloading the file, load the file using "rast" function
najaaug <- rast("najafiraq_oli_2023219_lrg.jpg")
plotRGB(najaaug, r=1, g=2, b=3) # Plot the RGB image

# Create a multi-frame plot to compare the two images
par(mfrow=c(2,1))
plotRGB(naja, r=1, g=2, b=3) # Plot image 1
plotRGB(najaaug, r=1, g=2, b=3) # Plot image 2

# Exercise: Multitemporal change detection
# Solution:

najadif = naja[[1]] - najaaug[[1]] # Calculate the difference between the two images (band 1)
cl <- colorRampPalette(c("brown", "grey", "orange")) (100) # Create color palette for plotting the difference
plot(najadif, col=cl) # Plot the difference with cl

# The Mato Grosso image can be downloaded directly from the NASA Earth Observatory website
mato <- rast("matogrosso_l5_1992219_lrg.jpg") # Load the image
# Plot the different RGB band combinations
plotRGB(mato, r=1, g=2, b=3) 
plotRGB(mato, r=2, g=1, b=3) 

# Exercise: Download your own preferred image and load for practise:
# Solution:

# Downloaded the image of Kaziranga National Park located in North-East India
kaziranga <- rast("kaziranga_etm_2000036.jpg") # Load the image
# Plot the Kaziranga image with different RGB band combinations
plotRGB(kaziranga, r=1, g=2, b=3)
plotRGB(kaziranga, r=2, g=1, b=3)
plotRGB(kaziranga, r=3, g=2, b=1)
