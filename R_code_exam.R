# This project presents an approach to detect and quantify changes in forest cover,
# using the damage caused by the 1980 Mt. St. Helens eruption as an example. 1979 Pre and 1980 Post-eruption images have been
# analyzed via various remote sensing and image processing techniques to quantify changes in the Gifford Pinchot National Forest.

# KEY TECHNIQUES: NDVI Analysis, Principal Component Analysis (PCA) and Image Classification


# _____________________________________________________________________________________________________________________________________________ #

# PREPARATION (Block I)

# Step 1: Install required packages (Skip if already done)

install.packages(c("terra", "raster", "patchwork", "ggplot2", "devtools"))

library(devtools) # Load the devtools package to download packages from Github
devtools::install_github("ducciorocchini/imageRy") # Install the imageRy package from Github

# Step 2: Load all the required packages for the project 

library(terra)     # for loading the raster data
library(raster)    # for cropping the original images
library(imageRy)   # for image processing
library(ggplot2)   # for creating plots
library(patchwork) # for combining multiple ggplot2 plots

# Step 3: Set working directory to the folder where the images are stored and load them

setwd("C:/Users/madhu/Desktop/Spatial Ecology") # Set the working directory

before <- rast("1979_St_Helens.tif") # Load the pre-eruption 1979 image as before
after <- rast("1980_St_Helens.tif") # Load the post-eruption 1980 image as after

# The images are sourced from NASA Visible Earth: https://visibleearth.nasa.gov/images/77957/eruption-of-mount-st-helens/77958l
# Band 1: NIR, Band 2: Red and Band 3: Green (Images captured using Landsat 3 satellite)

plotRGB(before, r = 1, g = 2, b = 3) # Plot before image
plotRGB(after, r = 1, g = 2, b = 3) # Plot after image

# Step 4: Crop the images with appropriate extent to focus on Mt. St. Helens and surrounding forest cover

crop_extent <- extent(2500, 3400, 700, 1430) # Define the crop extent
cropped_before <- crop(before, crop_extent) # Crop the 'before' image
cropped_after <- crop(after, crop_extent) # Crop the 'after' image

# Step 5: Plot the cropped images and their bands in separate multi-frames

par(mfrow = c(1,2)) # Create plotting area with 1 row and 2 columns
plot(cropped_before) # Plot the "cropped_before" image
plot(cropped_after) # Plot the "cropped_after" image

par(mfrow = c(3,2)) # Create plotting area with 3 rows and 2 columns
# Plot all individual bands of the images with labels    
plot(cropped_before[[1]], main = 'Band 1 - NIR')
plot(cropped_after[[1]], main = 'Band 1 - NIR')
plot(cropped_before[[2]], main = 'Band 2 - Red')
plot(cropped_after[[2]], main = 'Band 2 - Red')
plot(cropped_before[[3]], main = 'Band 3 - Green')
plot(cropped_after[[3]], main = 'Band 3 - Green')
    
# _____________________________________________________________________________________________________________________________________________ #

# NDVI ANALYSIS (BLOCK II)

# Step 1: Find DVI and NDVI for the cropped before and after images

# Find DVI by subtracting the Red band from the NIR band
dvi_before <- (cropped_before[[1]] - cropped_before[[2]]) 
dvi_after <- (cropped_after[[1]] - cropped_after[[2]]) 

# Find NDVI by normalizing the DVI with NIR + Red   
ndvi_before <- (cropped_before[[1]] - cropped_before[[2]]) / (cropped_before[[1]] + cropped_before[[2]])    
ndvi_after <- (cropped_after[[1]] - cropped_after[[2]]) / (cropped_after[[1]] + cropped_after[[2]])
    
# Step 2: Visualize the DVI and NDVI for the images in multiframe

par(mfrow = c(2,2)) # Create plotting area with 2 rows and 2 columns
plot(dvi_before, main = "DVI (Before)") # Plot DVI before
plot(dvi_after, main = "DVI (After)") # Plot DVI after    
plot(ndvi_before, main = "NDVI (Before)") # Plot NDVI before
plot(ndvi_after, main = "NDVI (After)") # Plot NDVI after

# Step 3: Make density plot of NDVI before and after values for qualitative analysis

# Make density plot of NDVI before values
plot(density(values(ndvi_before), na.rm = TRUE), col = "blue", main = "NDVI Density Comparison", xlab = "NDVI Value")
lines(density(values(ndvi_after), na.rm = TRUE), col = "green") # Add data for NDVI after values 
text(x = 0.6, y = 1.5, labels = "Before", col = "blue", cex = 1.0) # Add text to the plot to indicate colour of before
text(x = -0.3, y = 1.5, labels = "After", col = "green", cex = 1.0) # Add text to the plot to indicate colour of after
    
# Step 4: Find and compare mean NDVI

# Find mean values using global() and convert them to numeric values for cat()
mean_before <- as.numeric(global(ndvi_before, mean, na.rm = TRUE)) 
mean_after <- as.numeric(global(ndvi_after, mean, na.rm = TRUE)) 

# Print the mean values 
cat("Mean NDVI (Before Image):", mean_before, "\n")
cat("Mean NDVI (After Image):", mean_after, "\n")

# Mean NDVI: Before = 0.19, After = 0.10 => 47.37 % Reduction

# Step 5: Find percentage of vegetated area assuming NDVI > 0.4 is for vegetation

# Divide sum of all NDVI > 0.4 values with total no. of pixels and multiply by 100 to get percentage   
vegetated_before <- sum(values(ndvi_before) > 0.4, na.rm = TRUE) / ncell(ndvi_before) * 100
vegetated_after <- sum(values(ndvi_after) > 0.4, na.rm = TRUE) / ncell(ndvi_after) * 100

# Print the vegetated area percentages using cat()    
cat("Percentage of Vegetated Area Before:", vegetated_before, "%\n")
cat("Percentage of Vegetated Area After:", vegetated_after, "%\n")

# Using 0.4 NDVI Threshold, Forest Area: before = 18 %, after = 10.4 % => 42.2 % Reduction

# Step 6: Find percentage of pixels whose NDVI reduced and plot histogram of NDVI differences

# Calculate NDVI differnce between before and after 
ndvi_diff <- ndvi_after - ndvi_before

# Calculate percentage of pixels with NDVI reduction
ndvi_reduction <- sum(ndvi_diff[] < 0, na.rm = TRUE) / ncell(ndvi_diff) * 100
cat("Percentage of pixels with NDVI reduction:", ndvi_reduction, "%\n") # Print the percentage

# Percentage of pixels whose NDVI reduced: 62.5 % (making increased = 37.5 %)

par(mfrow = c(1,2)) # Create plotting area with 1 row and 2 columns
plot(ndvi_diff, main = "NDVI Difference (After - Before)") # Plot NDVI differnce
hist(ndvi_diff, main = "Histogram of NDVI Differences", xlab = "NDVI Difference", col = "lightblue") # Plot historgram of NDVI differnces

# _____________________________________________________________________________________________________________________________________________ #

# PRINCIPAL COMPONENT ANALYSIS (Block III)

# Step 1: Perform PCA on the images using the im.pca() function and extract PC1 and PC2

cropped_before_pca <- im.pca(cropped_before)  # Perform PCA on cropped before image
cropped_after_pca <- im.pca(cropped_after)  # Perform PCA on cropped after image

pc1_before <- cropped_before_pca$PC1 # Extract PC1 in before image
pc1_after <- cropped_after_pca$PC1 # Extract PC1 in after image
pc2_before <- cropped_before_pca$PC2 # Extract PC2 in before image
pc2_after <- cropped_after_pca$PC2 # Extract PC2 in after image

# Step 2: Normalize the PC1 and PC2 values (0 to 1 scaling)

pc1_before <- (pc1_before - min(pc1_before[])) / (max(pc1_before[]) - min(pc1_before[]))
pc1_after <- (pc1_after - min(pc1_after[])) / (max(pc1_after[]) - min(pc1_after[]))
pc2_before <- (pc2_before - min(pc2_before[])) / (max(pc2_before[]) - min(pc2_before[]))
pc2_after <- (pc2_after - min(pc2_after[])) / (max(pc2_after[]) - min(pc2_after[]))

# Step 3: Plot PC1 and PC2 for cropped_before and cropped_after side by side

par(mfrow = c(2, 2))  # Create a plotting area with 2 rows and 2 columns
plot(pc1_before, main = "PC1 - Before")  # Plot PC1 for before
plot(pc1_after, main = "PC1 - After")  # Plot PC1 for after
plot(pc2_before, main = "PC2 - Before")  # Plot PC2 for before
plot(pc2_after, main = "PC2 - After")  # Plot PC2 for after

# Step 4: Find the difference for PC1 and PC2 before and after and quantize negative change

pc1_diff <- pc1_after - pc1_before  # PC1 difference
pc2_diff <- pc2_after - pc2_before  # PC2 difference

# Plot the differences
par(mfrow = c(1, 2))  # Create a plotting area with 1 row and 2 columns
plot(pc1_diff, main = "PC1 Difference")  # Plot PC1 difference
plot(pc2_diff, main = "PC2 Difference")  # Plot PC2 difference

# Step 5: Calculate the percentage of pixels with negative changes in PC1 and PC2

pc1_reduction <- sum(pc1_after[] < pc1_before[], na.rm = TRUE) / ncell(pc1_diff) * 100
pc2_reduction <- sum(pc2_after[] < pc2_before[], na.rm = TRUE) / ncell(pc2_diff) * 100

# Print the percentages of pixels with reductions
print(paste("Percentage of area with reduction in PC1:", round(pc1_reduction, 2), "%"))
print(paste("Percentage of area with reduction in PC2:", round(pc2_reduction, 2), "%")) 

# Percentage of area with reduction in PC1: 48.01
# Percentage of area with reduction in PC2: 91.82

# Step 6: Calculate the mean values of PC1 and PC2 for before and after

mean_pc1_before <- mean(pc1_before[], na.rm = TRUE)  # Mean PC1 for before
mean_pc1_after <- mean(pc1_after[], na.rm = TRUE)  # Mean PC1 for after
mean_pc2_before <- mean(pc2_before[], na.rm = TRUE)  # Mean PC2 for before
mean_pc2_after <- mean(pc2_after[], na.rm = TRUE)  # Mean PC2 for after

# Print the mean values
print(paste("Mean PC1 (Before):", round(mean_pc1_before, 3)))
print(paste("Mean PC1 (After):", round(mean_pc1_after, 3)))
print(paste("Mean PC2 (Before):", round(mean_pc2_before, 3)))
print(paste("Mean PC2 (After):", round(mean_pc2_after, 3)))

# Mean PC1 values: Before = 0.291, After = 0.364
# Mean PC2 values: Before = 0.702, After = 0.481

# _____________________________________________________________________________________________________________________________________________ #

# IMAGE CLASSIFICATION (Block IV)

# Step 1: Classify pixels in the images into 3 clusters   

# Classification has been done on Band 3 (Green) into three clusters, since qualitatively it gave the best results in terms of
# identifying forest area. So one cluster represents forest but the second and third together represent non-forest area
    
before_cl <- im.classify(cropped_before[[3]], num_clusters = 3) # Classify in before
par(mfrow = c(1,2)) # Create plotting area with 1 row and 2 columns
plot(cropped_before, main = "Original 'Before' Image") # Plot original cropped before image
plot(before_cl, main = "Classified 'Before'") # Plot the classification outcome of cropped before

after_cl <- im.classify(cropped_after[[3]], num_clusters = 3) # Classify in after
par(mfrow = c(1,2)) # Create plotting area with 1 row and 2 columns
plot(cropped_after, main = "Original 'After' Image") # Plot original cropped after image
plot(after_cl, main = "Classified 'After'") # Plot the classification outcome of cropped after
    
# Step 2: Make summary tables with frequency / percentage of each class using freq()

f1979 <- freq(before_cl) # Get the frequency of each class in 1979 image
f1979 # Print the table with frequency
tot1979 <- ncell(before_cl) # Extract total number of pixels in before_cl

f1980 <- freq(after_cl) # Get the frequency of each class in 1980 image
f1980 # Print the table with frequency
tot1980 <- ncell(after_cl) # Extract total number of pixels in after_cl

# Total number of pixels in both before_cl and after_cl should be same 

# Convert both tables so that they show percentage of each class
p1979 <- f1979 * 100 / tot1979 # Get percentage table of 1979
p1979 # Print the percentage table for 1979
p1980 <- f1980 * 100 / tot1980 # Get percentage table of 1980
p1980 # Print the percentage table for 1980

# Step 3: Identiy which cluster is forest and make final data frame

class <- c("Forest","Other") # Make the row containg column names
y1979 <- c(77.8, 22.2) # Add data for 1979
y1980 <- c(54.5, 45.5) # Add data for 1980

tabout <- data.frame(class, y1979, y1980) # Make the data frame
print(tabout) # Print the final dataframe

# Step 4: Make bar plots for the final data frame and combine them

# Make plot for 1979 data    
p1 <- ggplot(tabout, aes(x=class, y=y1979, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100)) +
      labs(x = "Class", y = "Cover Percentage in 1979") # Add labels for the axes

# Make plot for 1980 data
p2 <- ggplot(tabout, aes(x=class, y=y1980, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100)) + 
      labs(x = "Class", y = "Cover Percentage in 1980") # Add labels for the axes

# Note that in both plots, ylim is already set from 0 to 100 since we want fair comparison of data

p1 + p2 # Finally, combine the bar plots using the patchwork package syntax and finish the project.

# _____________________________________________________________________________________________________________________________________________ #
