# Overlap: Estimates of Coefficient of Overlapping for Species Activity Pattern
# Code for analyzing temporal activity patterns of different species and their overlap using KDEs

# Download the "overlap" package
install.packages("overlap")

# Load required library
library(overlap)

# Load the kerinci dataset provided by the overlap package
data(kerinci)
summary(kerinci) # Summarize the dataset to understand its structure and contents
head(kerinci) # Diplay the first six rows of the dataset

# Before proceeding, note that the unit of time in dataset is the day, with values from 0 to 1
# Overlap package uses radians for fitting density curves using trignometric functions like sine
# Convert the time to radians first for accurate density calculations
kerinci$Timecirc <- kerinci$Time * 2 * pi

# Select data for the first species: tiger
tiger <- kerinci[kerinci$Sps=="tiger",]
summary(tiger) # Summarize the dataset
tigertime <- tiger$Timecirc # Select time data for tigers in radians

# Plot the density of tiger activity
densityPlot(tigertime)

# Select data for the second species: macaque
macaque <- kerinci[kerinci$Sps=="macaque",]
summary(macaque) # Summarize the dataset
macaquetime <- macaque$Timecirc # Select time data macaques in radians

# Plot the density of macque activity
densityPlot(macaquetime)

# Now we can use overlap to check the activity patterns of tigers and macaques together
# This helps to identify periods when tigers could potentially prey on macaques

# Plot the overlapping density of tiger and macaque activity
overlapPlot(tigertime, macaquetime)
# We observe that there is mainly overlap in activity between 6 AM and 6 PM

# Note: if earlier we wanted to select data of all species that are not macaque, 
# this is how we could do that:

nomacaque <- kerinci[kerinci$Sps!="macaque",]
summary(nomacaque)
