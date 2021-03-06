###########################################
## Optimization

# Function to minimize
f <- function(x) {
  (x - 3)^2 + 2 * (x - 3)^2 + 3 * (x - 15)^2 + sin(100*x)
}

# Metafunction, minimizes f in the range supplied
optrange <- function(xrange) {
  optimise(f, xrange)
}

# The results
opt1 <- optrange(c(0, 15))
opt2 <- optrange(c(9, 12))
opt3 <- optrange(c(10, 11))

# Create a function for plotting the results
optplot <- function(optobj, ...) {
  points(optobj$minimum, optobj$objective, ...)
}

# Plot curve and points
# Quite obviously, they are local minima!
par(mfrow = c(1,2))
curve(f, from = 0, to = 20)
optplot(opt1)
optplot(opt2, pch = 2)
optplot(opt2, pch = 3)

curve(f, from = 9.2, to = 9.8)
optplot(opt1)
optplot(opt2, pch = 2)
optplot(opt2, pch = 3)
par(mfrow = c(1,1))

###########################################
## Integration

g <- function(x) {
  x * sin(x)
}

# Takes about 8 seconds, but smaller values of subdivisions makes the function not work
integral <- system.time(integrate(g, -7e5, 7e5, subdivisions = 1e7))

# Parallelization, divide it into 14 intervals of length 1e5
library(parallel)
int_divide <- function(w) {
  integrate(function(x) x*sin(x), -7e5 + w, -6e5 + w, subdivisions = 1e7)$value
}

# Create a function of the number of workers to use to time it
timing <- function(workers) {
  cl <- makePSOCKcluster(workers)
  elapsed <- system.time(parSapply(cl, seq(0, 13e5, length.out = 14), int_divide))[3]
  elapsed
}
workers_to_test <- c(2, 4, 8, 16, 24)

## WARNING! This is slow (because of the creation of clusters)
workers_speed <- sapply(workers_to_test, timing)
plot(workers_to_test, workers_speed, type = "b")


###########################################
## Memoisation

library(memoise)
fib <- function(n) {
  if (n < 2) return(1)
  fib(n - 2) + fib(n - 1)
}

fib2 <- memoise(function(n) {
  if (n < 2) return(1)
  fib2(n - 2) + fib2(n - 1)
})

fib3 <- memoise(fib)

## fib2 fast even the first time
## fib3 the second time
first_time  <- c(system.time(fib(28))[3], system.time(fib2(28))[3], system.time(fib3(28))[3])
second_time <- c(system.time(fib(28))[3], system.time(fib2(28))[3], system.time(fib3(28))[3])


#################################################
## ggplot
install.packages("ggplot2")	
library(ggplot2)
data(mpg)
str(mpg)

qplot(displ, hwy , data=mpg)
qplot(displ, hwy , data=mpg, color = drv)
qplot(displ, hwy, data =mpg, geom=c("point","smooth")) 
qplot(displ, hwy, data =mpg, geom=c("point","smooth"),method="lm") 
qplot(displ, hwy, data =mpg, geom=c("point","smooth"),method="lm",color=drv)
gr <- qplot(displ, hwy, data =mpg, geom=c("point","smooth"),method="lm",color=drv)
gr + theme(panel.background = element_rect(colour = "pink"))


## Diamonds

# 1. Load the data set diamonds from ggplot2.
data(diamonds)
str(diamonds)

# 2. Look at the variables carat and price in the dataframe and plot them against each other.
qplot(carat, price, data=diamonds)

# 3. Look at the relation between carat and price for different diamond colors.
qplot(carat, price, data=diamonds, color = color)

# 4. Add a smoother to the plot.
diamondplot <- qplot(carat, price, data=diamonds, geom=c("point","smooth"), color = color)
diamondplot

# 5. Change the title of legend of your plot to "New legends". Tips: look at the theme() help to find out how to change the title of legend.
diamondplot + scale_colour_hue(name = "New legends")

# 6. Find out how to draw a boxplot to check the distribution of price/carat for different colors. 
qplot(factor(color), price, data = diamonds, geom = "boxplot")
qplot(factor(color), carat, data = diamonds, geom = "boxplot")
