# Let's explore the spatial distribution of a species using the SDM package and other tools
# Recall that when installing a package, we use quotes around package name but when loading the library, quotes are not required.
# Note that I do not add dev.off() in code because I followed the course in R Notebooks 

# Load the required libraries
library(sdm) # SDM package is used for species distribution modelling
library(terra) # Terra package is used for spatial data manipulation and reading files

# system.file is a useful tool for locating the path to a specified file within the package
file <- system.file("external/species.shp", package="sdm") # "external" is the folder, "species" is the file name, and "shp" is the extension for shape files
# The full path on my PC is "C:/Users/madhu/AppData/Local/R/win-library/4.4/sdm/external/species.shp"

# vect function in terra reads vector files (series of coordinates)
rana <- vect(file) # Read the vector file

# Display the occurence data
rana$Occurrence
# Occurence column: 0 represents absence, 1 represents presence of species (Rana here)
# Additionally note that there is an uncertainity related with reporting absence of a species in a region
# Perhaps, the data collector did not look long enough, or misses the species due to a mistake (many reasons possible)

# Plot the species data
plot(rana)

# Select and plot only the presences
pres <- rana[rana$Occurrence==1]

# Exercise: plot in a multiframe the rana dataset beside the pres dataset
# Solution:

par(mfrow=c(1,2)) # Create plotting area with one row and two columns to show the plots side by side
plot(rana) # Plot the species data
plot(pres) # Plot presences

# Exercise: select and plot data from rana with only absences
# Solution:

abse <- rana[rana$Occurrence==0] # putting rana$Occurence = 0 to select absences
plot(abse) # Plot absences

# Exercise: plot in a multiframe presences beside absences
# Solution:

par(mfrow=c(1,2)) ## Create plotting area with one row and two columns to show the plots side by side
plot(pres) # Plot presences
plot(abse) # Plot absences

# Exercise: plot in a multiframe presences on top of absences
# Solution:

par(mfrow=c(2,1)) # Create plotting area with two rows and one column to show the plots on top of each other
plot(pres) # Plot presences first so it appears on top
plot(abse) # Plot absences second so it appears below presences

# Excercise: plot the presences in blue together with absences in red
# Solution:

plot(pres, col="blue", pch=19, cex=2) # Plot presences with col = "blue"
points(abse, col="red", pch=19, cex=2) # Plot absences with col = "red"

# Load environmental predictor variables (rasters)
# Elevation predictor
elev <- system.file("external/elevation.asc", package="sdm") # Find the path for "elevation.asc" file
# The full path on my PC is "C:/Users/madhu/AppData/Local/R/win-library/4.4/sdm/external/elevation.asc"

# rast function in terra package is used to create or read raster objects (gride of cells - pixels)
elevmap <- rast(elev)
# Plot the elevation map
plot(elevmap)

# Exercise: change the colors of the elevation map by the colorRampPalette function
# Solution:

cl <- colorRampPalette(c("green","hotpink","mediumpurple"))(100) # Use colorRampPalette to create custom color palette
plot(elevmap, col=cl) # Plot elevation map

# Exercise: plot the presences together with elevation map
# Solution:

plot(elevmap, col = cl) # First plot the elvation map with any color palette 
points(pres, pch=19) # Then add points of the presences
