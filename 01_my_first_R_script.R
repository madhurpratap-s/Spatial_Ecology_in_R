# This script is created after the Population_Density.R file as I joined the course on 10-10-2024

# Here I can write anything I want!
# First, we look at some basic R operations and plotting examples

# We can use R as a calculator
2 + 3 # This is my first operation in R (Simple Addition)

# There are five important concepts that we should know:
# 1. Objects
# 2. The assignment (<-)
# 3. Comments (like this one!)
# 4. Functions
# 5. Arrays

# It is important to make use of objects
madhur <- 2 + 3  # The result of the operation is assigned to an object called madhur
madhur # Display the value of 'madhur'

maria <- 4 + 2 # Assign another addition result to an object
maria # Display the value of 'maria'

madhur + maria # This displays the sum of the values assigned to 'madhur' and 'maria'

madhur ^ maria # This displays the outcome of raising the value assigned to 'madhur' to the value assigned to 'maria'

(madhur + maria) ^ madhur # Another example of an operation we can perform

# Creating arrays (vectors) for plotting
andrea <- c(10, 15, 20, 50, 70) # in a function arguments are separated by commas  
andrea # Display 'andrea' array

sofia <- c(100, 200, 300, 400, 500) # another array
sofia # Display 'sofia' array

# Make a scatter plot with 'sofia' on the x-axis and 'andrea' on the y-axis
plot(sofia, andrea)

# pch parameter in plot function specifies the plotting character we can use
plot(sofia, andrea, pch=19) # Plot with solid circles as plotting symbol
# The link given below has a list of the most commonly used pch values in R and additional plotting tips:
# https://www.datanovia.com/en/blog/pch-in-r-best-tips/

# cex paramter in plot function is used to control the size of the elements in the plot
plot(sofia, andrea, pch=19, cex=2) # Plot with points 2 times the default size
plot(sofia, andrea, pch=19, cex=0.5) # Plot with points 0.5 times the default size
plot(sofia, andrea, pch=19, cex=.5) # We can write .5 instead of 0.5 without any problem

# col parameter in the plot function is used to set the colour of the elements in the plot
plot(sofia, andrea, pch=19, cex=2, col="blue") # Example with blue colored elements
# The link below displays more than 100 colors that can be called by a name in R:
# https://r-graph-gallery.com/42-colors-names.html

# xlab and ylab parameters are used to label the x-axis and y-axis of the plot respectively
plot(sofia, andrea, pch=19, cex=2, col="blue", xlab="CO2", ylab="Amount of Fruits")
