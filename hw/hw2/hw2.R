library(GGally)
library(ggplot2)
data(midwest)



# 1. Professional Employment by State
q1 <- function() {
  # Using Interpretation A from Piazza
  
  # Get number of professionals in each county from percprof and population of adults
  midwest$proftotal = (midwest$percprof / 100) * midwest$popadults
  
  # Group by state, summing the number of professionals and population of adults from each county
  agg_by_state <- aggregate(midwest[c('proftotal', 'popadults')], by=list(state=midwest$state), "sum")
  
  # Calculate the percentage of adults in each state with professional employment
  agg_by_state$percprof_state = 100 * agg_by_state$proftotal / agg_by_state$popadults
  
  print(agg_by_state)
  
  # Plot percentage of adults with professional employment for each state
  ggplot(data=agg_by_state, aes(x=state, y=percprof_state)) +
    geom_bar(stat="identity") +
    ylab('% of state adult population w/ professional employment')
}



# 2. School and College Education by State
q2 <- function() {

  # Plot perchsd against percollege to visualize correlation
  qplot(data=midwest, x=perchsd, y=percollege, color=state)
  
  # Plot perchsd and percollege grouped by state to show distribution of values
  ggplot(midwest,aes(
    reorder(state,-perchsd,median),perchsd)) + #reorder function reorders the classes in
    #order of increasing highway mpg (using the median)
    geom_boxplot() + #adds the boxplot geometry
    coord_flip() + #this makes the box plot lie on its side
    #(as opposed to the default, which is standing up)
    scale_x_discrete("state") #this is required if we want to make the box lying down;
  
  # Plot perchsd and percollege grouped by state to show distribution of values
  ggplot(midwest,aes(
    reorder(state,-percollege,median),percollege)) + #reorder function reorders the classes in
    #order of increasing highway mpg (using the median)
    geom_boxplot() + #adds the boxplot geometry
    coord_flip() + #this makes the box plot lie on its side
    #(as opposed to the default, which is standing up)
    scale_x_discrete("state") #this is required if we want to make the box lying down;
  
  # Calculate correlation coefficient
  cor(midwest$perchsd, midwest$percollege)
  
  # Calculate percentage of adults in each state with a high school diploma. Do the same for college diploma.
  
  midwest$hsdtotal = (midwest$perchsd / 100) * midwest$popadults
  midwest$collegetotal = (midwest$percollege / 100) * midwest$popadults
  agg_by_state <- aggregate(midwest[c('hsdtotal', 'collegetotal', 'popadults')], by=list(state=midwest$state), "sum")
  agg_by_state$perchsd_state = 100 * agg_by_state$hsdtotal / agg_by_state$popadults
  agg_by_state$percollege_state = 100 * agg_by_state$collegetotal / agg_by_state$popadults
  
  print(agg_by_state)
  
  # Plot perchsd_state and percollege_state to compare
  ggplot(data=agg_by_state, aes(reorder(state,-perchsd_state,median), perchsd_state)) +
    geom_bar(stat="identity") +
    xlab('state') +
    ylab('% of state adult population w/ high school diploma')
  
  ggplot(data=agg_by_state, aes(reorder(state,-percollege_state,median), percollege_state)) +
    geom_bar(stat="identity") +
    xlab('state') +
    ylab('% of state adult population w/ college diploma')
}



# 3. Comparison of Visualization Techniques
q3 <- function() {
  # Plot normal distribution with different sample sizes
  par(mfrow=c(1,2))
  boxplot(rnorm(100, 0, 1))
  boxplot(rnorm(100000, 0, 1))
}



# 4. Random Scatterplots
get_sizes <- function(n, suffix) {
  d1 <- runif(n)
  d2 <- runif(n)
  p <- qplot(d1, d2)
  path <- sprintf("/tmp/plot.%s", suffix)
  ggsave(path, plot=p)
  return(file.size(path))
}

q4_run_experiments <- function() {
  dev.off()
  df <- data.frame(n=seq(100, 5000, by = 100))
  for (suffix in c('ps', 'pdf', 'jpeg', 'png')) {
    df[suffix] <- sapply(df$n, get_sizes, suffix=suffix)
  }
  dev.new()
  return(df)
}

q4_plot <- function(df) {
  plot(df$n, df$jpeg, ylim=c(5550, 695610), type="o", col="red", xlab="Sample Size", ylab="File Size")
  lines(x=df$n, y=df$png, type='o', col="blue")
  lines(x=df$n, y=df$pdf, type='o', col="green")
  lines(x=df$n, y=df$ps, type='o', col="black")
  # for (suffix in c('pdf', 'jpeg', 'png')) {
  #   lines(df$n, df[suffix], type='o')
  # }
}


# 5. Diamonds
q5 <- function() {
}



# Main
# q1()
# q2()
# q3()
#df <- q4_run_experiments()
q4_plot(df)
q5()