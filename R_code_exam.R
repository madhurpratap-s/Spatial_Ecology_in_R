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
