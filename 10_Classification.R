# Code for performing Classification process in R using imageRy

# Theory: In remote sensing, pixel classification is the process of classifying image pixels into groups based on their spectral properties to help identify
# specific geographical features, such as snow, vegetation, water bodies, or even specific species. Algorithms such as k-means clustering classify pixels
# into specific groups without any prior knowledge of what those groups represent solely based on their spectral reflectance values.
# This is an example of an unsupervised machine learning task.

# Import the required libraries
library(terra)
library(imageRy)
library(ggplot2)
install.packages("patchwork")
library(patchwork)

# List all available data inside imageRy
im.list()

# Import the image of the sun
sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
# Qualitatively, there are roughly three regions that appear yellow (most bright), brownish (less bright) and black (least bright)

# im.classify is the function used for classification in imageRy with syntax: im.classify(image name, number of clusters you want to make)
sunc <- im.classify(sun, num_clusters=3) # We specify three clusters because we qualitatively can see three regions
# Class with yellow area represents higher energy (most bright) which in this case is 1
# Note: Resulting plot of classified groups may be slightly different each run with different colors and labels due to nature of algorithm

# Let's use Mato Grosso images for Classification

# Import the images from imageRy
m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")

# Divide the 1992 image into 2 clusters
m1992c <- im.classify(m1992, num_clusters=2)
# Class 1 corresponds to human related areas and water and Class 2 represents forest cover

# Divide the 2006 image into 2 clusters
m2006c <- im.classify(m2006, num_clusters=2)
# Class 1 now corresponds to forest cover while Class 2 represents the human related areas and water

# Create a multi-frame to plot both imagees
par(mfrow=c(1,2))
plot(m1992c) # Plot the 1992 image
plot(m2006c) # Plot the 2006 image

# To see how many pixels are classified into each region, we can use the freq() function
f1992 <- freq(m1992c) # Generate the table for 1992 image
f1992 # Print the table
# Extract the total number of pixels from the table
tot1992 <- ncell(m1992c)
tot1992 # Print the total number of pixels
# Percentage: Frequency * 100 / Total
p1992 = f1992 * 100 / tot1992 # Create table for 1992 image with percentages instead of frequency
p1992 # Print the table
# Class 1 = human related areas and water = 17%
# Class 2 = forest = 83%

# Generate table of frequencies for 2006 image
f2006 <- freq(m2006c)
f2006 # Display the table
tot2006 <- ncell(m2006c) # Extract the total number of pixels from the table
tot2006 # Print the total number of pixels
p2006 = f2006 * 100 / tot2006 # Create the table for 2006 image with percentages instead of frequency
p2006 # Print the table
# Class 1 = forest = 45%
# Class 2 = human related areas and water = 55%

# Let's build a dataframe (table) together
# Define the vectors, where each vector represents a column in the dataframe
class <- c("Forest","Human") # Label for each region
y1992 <- c(83, 17) # Data for 1992 image
y2006 <- c(45, 55) # Data for 2006 image

# The data.frame() function in R is used to create a dataframe
tabout <- data.frame(class, y1992, y2006) # List the vectors / columns in the desired order of appearance
tabout # Print the table

# To make bar plots in R, we can use the ggplot() function from ggplot2 library
p1 <- ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100)) # Make Bar plot for 1992 image
p2 <- ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100)) # Make Bar plot for 2006 image
# Note: ggplot() function is an example of object-oriented programming
# We first specify the data source / plot object, then assign aesthetic mappings. Bars are assigned colors based on different class.
# Using geom_bar, we specify that we want a bar plot with identity ensuring the data is displayed as it is without any operation such as mean being performed on it.
# Same y-limits ensure accurate comparison of the relative sizes of the bars for the 2 plots by avoiding misleading visualizations (as done by politicians)

# patchwork package allows us to combine multiple ggplot2 plots into a single layout
p1  + p2 # Shows the plots side by side
p1 / p2 # Shows p1 over p2
