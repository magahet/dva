options(expressions=500000)

library(ggplot2)


log_factorial <- function (n) {
  # Return the log of factorial(n) for any integer n > 0
  if (n <= 1)
    return (0)
  return (log(n) + log_factorial(n - 1))
}

sum_log_factorial <- function (n) {
  # Return the sum of log_factorial(i) for i in 1..n
  sum <- 0
  for(i in seq(1, n, 1)) {
    sum <- sum + log_factorial(i)
  }
  return (sum)
}

fibonacci <- function(n) {
  # Return nth Fibonacci number
  if (n <= 1)
    return (n)
  return (fibonacci(n - 1) + fibonacci(n - 2))
}

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

experiment <- function(func, iterations, step) {
  n_vector <- seq(step, iterations, by=step)
  time_vector <- sapply(n_vector, avg_time_execution, func=func)
  return(data.frame(n=n_vector, runtime=time_vector))
}

time_execution <- function(func, arg) {
  return(system.time(func(arg))[1])
}

avg_time_execution <- function(func, arg, n=5) {
  return(mean(replicate(n, func(arg))))
}

df_l <- experiment(log_factorial, 1000, 100)
df_s <- experiment(sum_log_factorial, 1000, 100)
df_f <- experiment(fibonacci, 20, 1)

ggplot(df_l, aes(x=n, y=runtime)) +
  geom_point() +
  geom_line() +
  ggtitle("log_factorial running time (linear scale)")

p1 <- ggplot(df_s, aes(x=n, y=runtime)) +
  geom_point() +
  geom_line() +
  ggtitle("sum_log_factorial running time (linear scale)")

p2 <- ggplot(df_s, aes(x=n, y=runtime)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(trans="log") +
  scale_y_continuous(trans="log") +
  ggtitle("sum_log_factorial running time (log-log scale)")

multiplot(p1, p2)

p1 <- ggplot(df_f[], aes(x=n, y=runtime)) +
  geom_point() +
  geom_line() +
  ggtitle("fibonacci running time (linear scale)")

p2 <- ggplot(df_f[], aes(x=n, y=runtime)) +
  geom_point() +
  geom_line() +
  scale_y_continuous(trans="log") +
  ggtitle("fibonacci running time (log-linear scale)")

multiplot(p1, p2)