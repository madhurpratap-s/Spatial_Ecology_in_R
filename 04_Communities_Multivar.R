# This code is for multivariate analysis of species x plot data in communities using the vegan package

# Load the vegan package
library(vegan)

# Load the dune dataset, which contains vegetation data
data(dune)

# Display the first 6 rows of the dataset to understand its structure
head(dune)

# The decorana function is used for multivariate analysis
# It performs Detrended Correspondence Analysis (DCA), which helps simplify complex ecological data
multivar <- decorana(dune)

# Display the DCA results
mulivar

# Define the lengths of DCA axes obtained from the decorana plot
dca1 <- 3.7004
dca2 <- 3.1166
dca3 <- 1.30055
dca4 <- 1.47888

# Calculate the total length of all DCA axes
total <- dca1 + dca2 + dca3 + dca4

# Calculate the proportion of contribution of each DCA axis to the toal variation
prop1 = dca1/total
prop2 = dca2/total
prop3 = dca3/total
prop4 = dca4/total

# Calculate the percentage contribution of each DCA axis to the total variation
perc1 = prop1*100
perc2 = prop2*100
perc3 = prop3*100
perc4 = prop4*100

# Calculate and display the sum of the first two DCA axes' percentages
perc1+perc2 
# We find that the first two axes explain ~71% of the variability

# Plot the DCA results to visualize the relationship between species and samples
plot(multivar)

# Example species to plot and interpret their positions in the ordination plot
# Achillea - representative of grassland areas
# Bromus hordeaceus - a typical species of dunes

# To interpret the ordination plot, note that the position of species and samples indicates their ecological relationship
# Species that are close together in the plot tend to occur together in the same samples
# The graph helps to visualize which species are associated with each other and the different habitat types they represent
