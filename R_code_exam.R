# In this project I will analyze the vegetation loss due to Mt St Helena eruption.
# I am posting rough code in the beginning and then will organize it properly.

library(raster)
library(terra)
library(imageRy)

setwd("C:/Users/madhu/Desktop/")

nrow(before)
ncol(before)

crop_extent <- extent(2500, 3400, 700, 1430)
# Crop the raster
cropped_before <- crop(before, crop_extent)
plot(cropped_before)

crop_extent <- extent(2550, 3450, 700, 1430)
# Crop the raster
cropped_after <- crop(after, crop_extent)
plot(cropped_after)

# Band 1 - NIR, Band 3 - Red, Band 2 - Blue
par(mfrow=c(3,2))
plot(cropped_before[[1]])
plot(cropped_after[[1]])
plot(cropped_before[[3]])
plot(cropped_after[[3]])
plot(cropped_before[[2]])
plot(cropped_after[[2]])

par(mfrow = c(1,2))
plot(cropped_before)
before_cl <- im.classify(cropped_before[[3]], num_clusters = 3)

par(mfrow = c(1,2))
plot(cropped_after)
after_cl <- im.classify(cropped_after[[3]], num_clusters = 3)

f1979 <- freq(before_cl)
f1979
f1980 <- freq(after_cl)
f1980

par(mfrow = c(1,2))
ndvi_before <- (cropped_before[[1]] - cropped_before[[3]]) / (cropped_before[[1]] + cropped_before[[3]])
plot(ndvi_before, main = "NDVI (Before)")

ndvi_after <- (cropped_after[[1]] - cropped_after[[3]]) / (cropped_after[[1]] + cropped_after[[3]])
plot(ndvi_after, main = "NDVI (After)")

# Summary Statistics
mean_before <- as.numeric(global(ndvi_before, mean, na.rm = TRUE))
mean_after <- as.numeric(global(ndvi_after, mean, na.rm = TRUE))
cat("Mean NDVI Before:", mean_before, "\n")
cat("Mean NDVI After:", mean_after, "\n")

#Density plot NDVI
plot(density(values(ndvi_before), na.rm = TRUE), col = "blue", main = "NDVI Density Comparison", xlab = "NDVI Value")
# Add the density of ndvi_after
lines(density(values(ndvi_after), na.rm = TRUE), col = "green")
# Add labels directly on the plot
text(x = 0.6, y = 1.5, labels = "Before", col = "blue", cex = 1.0)
text(x = -0.3, y = 1.5, labels = "After", col = "green", cex = 1.0)



par(mfrow = c(1,2))
dvi_before <- cropped_before[[1]] - cropped_before[[3]]
plot(dvi_before, main = "DVI (Before)")
dvi_after <- cropped_after[[1]] - cropped_after[[3]]
plot(dvi_after, main = "DVI (After)")

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
