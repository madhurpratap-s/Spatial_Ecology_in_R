# In this project I will analyze the vegetation loss due to Mt St Helena eruption.
# I am posting rough code in the beginning and then will organize it properly.


crop_extent <- extent(2500, 3500, 700, 1700)
# Crop the raster
cropped_before <- crop(before, crop_extent)
plot(cropped_before)

crop_extent <- extent(2550, 3550, 700, 1700)
# Crop the raster
cropped_after <- crop(after, crop_extent)
plot(cropped_after)
