# This project presents an approach to detect and quantify changes in forest cover,
# using the damage caused by the 1980 Mt. St. Helens eruption as an example. 1979 Pre and 1980 Post-eruption images have been
# analyzed via various remote sensing and image processing techniques to quantify changes in the Gifford Pinchot National Forest.

# KEY TECHNIQUES: NDVI Analysis, Principal Component Analysis (PCA) and Image Classification


# ________________________________________________________________________________________________________________ #

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

setwd("C:/Users/madhu/Desktop/") # Set the working directory

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

par(mfrow = c(3,2) # Create plotting area with 3 rows and 2 columns
# Plot all individual bands of the images with labels    
plot(cropped_before[[1]], main = 'Band 1 - NIR')
plot(cropped_after[[1]], main = 'Band 1 - NIR')
plot(cropped_before[[2]], main = 'Band 2 - Red')
plot(cropped_after[[2]], main = 'Band 2 - Red')
plot(cropped_before[[3]], main = 'Band 3 - Green')
plot(cropped_after[[3]], main = 'Band 3 - Green')
    
# ________________________________________________________________________________________________________________ #

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

# Step 5: Find percentage of vegetated area assuming NDVI > 0.2 is for vegetation

# Divide sum of all NDVI > 0.2 values with total no. of pixels and multiply by 100 to get percentage   
vegetated_before <- sum(values(ndvi_before) > 0.2, na.rm = TRUE) / ncell(ndvi_before) * 100
vegetated_after <- sum(values(ndvi_after) > 0.2, na.rm = TRUE) / ncell(ndvi_after) * 100

# Print the vegetated area percentages using cat()    
cat("Percentage of Vegetated Area Before:", vegetated_before, "%\n")
cat("Percentage of Vegetated Area After:", vegetated_after, "%\n")

# Step 6: Find percentage of pixels whose NDVI reduced and plot histogram of NDVI differences

# Calculate NDVI differnce between before and after 
ndvi_diff <- ndvi_after - ndvi_before

# Calculate percentage of pixels with NDVI reduction
ndvi_reduction <- sum(ndvi_diff[] < 0, na.rm = TRUE) / ncell(ndvi_diff) * 100
cat("Percentage of pixels with NDVI reduction:", ndvi_reduction, "%\n") # Print the percentage

par(mfrow = c(1,2)) # Create plotting area with 1 row and 2 columns
plot(ndvi_diff, main = "NDVI Difference (After - Before)") # Plot NDVI differnce
hist(ndvi_diff, main = "Histogram of NDVI Differences", xlab = "NDVI Difference", col = "lightblue") # Plot historgram of NDVI differnces


# ________________________________________________________________________________________________________________ #

# PRINCIPAL COMPONENT ANALYSIS (Block III)

    

before_cl <- im.classify(cropped_before[[3]], num_clusters = 3)

par(mfrow = c(1,2))
plot(cropped_after)
after_cl <- im.classify(cropped_after[[3]], num_clusters = 3)

f1979 <- freq(before_cl)
f1979
f1980 <- freq(after_cl)
f1980








# Step 1: Perform PCA on the 'before' and 'after' images
cropped_before_pca <- im.pca(cropped_before)  # Perform PCA on 'before' image
cropped_after_pca <- im.pca(cropped_after)    # Perform PCA on 'after' image

# Step 2: Extract the first principal component (PC1)
pc1_before <- cropped_before_pca$PC1
pc1_after <- cropped_after_pca$PC1

# Step 3: Normalize the PC1 values (0 to 1 scaling)
pc1_before <- (pc1_before - min(pc1_before[])) / (max(pc1_before[]) - min(pc1_before[]))
pc1_after <- (pc1_after - min(pc1_after[])) / (max(pc1_after[]) - min(pc1_after[]))

# Step 4: Plot PC1 for 'before' and 'after' side by side
par(mfrow = c(1, 2))  # Set up a 1x2 plotting area
plot(pc1_before, main = "PC1 - Before", col = viridis::viridis(255))  # Plot PC1 for 'before'
plot(pc1_after, main = "PC1 - After", col = viridis::viridis(255))    # Plot PC1 for 'after'

pc1_after_resampled <- resample(pc1_after, pc1_before)

# Calculate the difference between PC1 in 'before' and 'after'
pc1_diff <- pc1_before - pc1_after_resampled

# Calculate the percentage of pixels with negative changes in PC1
pc1_reduction <- sum(pc1_diff[] < 0, na.rm = TRUE) / ncell(pc1_diff) * 100

# Print the percentage of reduction
print(paste("Percentage of area with reduction in PC1:", round(pc1_reduction, 2), "%"))
