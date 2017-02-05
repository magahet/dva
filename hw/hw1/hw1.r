#!/usr/bin/Rscript

# GT account name: mmendiola3

options(expressions=500000)


# 2. Log Gamma (Loop)
log_gamma_loop <- function(n) {
  sum <- 0
  for (i in seq(n - 1)) {
    if (i >= 1) {
      sum <- sum + log(i)
    }
  }
  return(sum)
}


# 3. Log Gamma (Recursive)
log_gamma_recursive <- function(n) {
  if (n <= 2) {
    return(0)
  } else {
    return(log(n - 1) + log_gamma_recursive(n - 1))
  }
}


# 4. Sum of Log Gamma
sum_log_gamma_loop <- function(n) {
  return(sum(sapply(seq(n), log_gamma_loop)))
}

sum_log_gamma_recursive <- function(n) {
  return(sum(sapply(seq(n), log_gamma_recursive)))
}

sum_log_gamma_r <- function(n) {
  return(sum(sapply(seq(n), lgamma)))
}


# 5. Compare Results to Built-In R Function
time_execution <- function(func, arg) {
  return(system.time(func(arg))[1])
}

experiment <- function(func, iterations, step) {
  n_vector <- seq(step, iterations, by=step)
  time_vector <- sapply(n_vector, time_execution, func=func)
  return(data.frame(n=n_vector, time=time_vector))
}

run_experiments <- function() {
  # Run experiments
  e_loop <- experiment(sum_log_gamma_loop, 2000, 100)
  e_recursive <- experiment(sum_log_gamma_recursive, 1000, 100)
  e_r <- experiment(sum_log_gamma_r, 2000, 100)
  return(list(loop=e_loop, recursive=e_recursive, r=e_r))
} 

plot_data <- function(data) {
  e_loop <- data[['loop']]
  e_recursive <- data[['recursive']]
  e_r <- data[['r']]
  
  # Plot data
  plot(e_loop, col='green', type='l')
  lines(e_recursive, col='red')
  lines(e_r, col='blue')
  title(main="lgamma implimentation runtimes")
  legend(100, max(e_loop['time']), c("recursive", 'loop', 'r'), cex=0.8, 
         col=c("red","green", "blue"), lty=1);
}

