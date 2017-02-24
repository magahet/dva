library(GGally)
library(ggplot2)
library(grid)
data(midwest)
data(diamonds)


# 1. Professional Employment by State
q1 <- function() {
  # Using Interpretation B from Piazza
  # Box plot percprof by state
  pm <- ggplot(midwest,aes(
    reorder(state, -percprof, median), percprof)) +
    ggtitle('County % of Adults w/ Professional Employment by State') +
    geom_boxplot() +
    coord_flip() +
    scale_x_discrete("state")
  print(pm)
}


# 2. School and College Education by State
q2 <- function() {
  # Scatter plot perchsd over percollege by state
  pm <- ggplot(midwest, aes(x=perchsd, y=percollege)) +
    ggtitle('percollege over perchsd (log-linear scale)') +
    geom_point(aes(color=state)) +
    scale_y_log10(breaks=seq(10, 50, 10)) +
    stat_smooth(method=lm, se=FALSE)
  print(pm)
  
  # Calculate correlation coefficient for log-linear, log-log, and linear
  cor(midwest$perchsd, log(midwest$percollege))
  cor(log(midwest$perchsd), log(midwest$percollege))
  cor(midwest$perchsd, midwest$percollege)
  
  # Box plot perchsd by state
  pm <- ggplot(midwest,aes(
    reorder(state, -perchsd, median), perchsd)) +
    ggtitle('County % of Adults w/ High School Diploma by State') +
    geom_boxplot() +
    coord_flip() +
    scale_x_discrete("state")
  print(pm)
  
  # Box plot percollege by state
  pm <- ggplot(midwest,aes(
    reorder(state, -percollege, median), percollege)) +
    ggtitle('County % of Adults w/ College Diploma by State') +
    geom_boxplot() +
    coord_flip() +
    scale_x_discrete("state")
  print(pm)
}


# 3. Comparison of Visualization Techniques
q3 <- function() {
  # Box plot with differing distributions
  par(mfrow=c(1,2))
  boxplot(c(0,1,2,3,4,5,6,7,8,9,16))
  boxplot(c(0,1,1,1,4,4,6,7,8,9,16))
  par(mfrow=c(1,1))
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
  df <- data.frame(n=seq(1000, 50000, by = 1000))
  for (suffix in c('ps', 'pdf', 'jpeg', 'png')) {
    df[suffix] <- sapply(df$n, get_sizes, suffix=suffix)
  }
  dev.new()
  return(df)
}

q4_examples <- function(df) {
  par(mfrow=c(2,1))
  plot(runif(100), runif(100))
  plot(runif(1000), runif(1000))
  par(mfrow=c(1,1))
}

q4_plot <- function(df) {
  plot(df$n, df$jpeg, ylim=c(5550, 1300000), type="o", col="red", xlab="Sample Size", ylab="File Size", main="Filesize by sample size")
  lines(x=df$n, y=df$png, type='o', col="blue")
  lines(x=df$n, y=df$pdf, type='o', col="green")
  lines(x=df$n, y=df$ps, type='o', col="black")
  legend(1, 1300000, legend=c('jpeg', 'png', 'ps', 'pdf'),
         col=c("red", "blue", "black", "green"), lty=1:2, cex=0.8)
}


# 5. Diamonds

# Multiple plot function (used by permission from: http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/)
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
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


q5 <- function() {
  # diamonds_sample <- diamonds[sample(1:length(diamonds$price), 2000),]
  # print(ggpairs(diamonds_sample, columns=c('color', 'carat', 'price'), ggplot2::aes(colour=color), legend=1))
  # 
  # print(ggplot(diamonds, aes(color, ..count.., fill=color)) +
  #         geom_histogram(stat="count") +
  #         ggtitle("Histogram of diamonds$color")
  #       )
  # 
  # print(ggplot(diamonds, aes(x=carat, fill=color)) +
  #         geom_histogram(bins=200) +
  #         scale_x_continuous(breaks=pretty(diamonds$carat, n=10), limits=c(NA, 2.5)) +
  #         ggtitle("Histogram of diamond$carat")
  #       )
  # 
  # print(ggplot(diamonds, aes(x=price, fill=color)) +
  #         geom_histogram(bins=300) +
  #         scale_x_continuous(breaks=pretty(diamonds$price, n=10)) +
  #         ggtitle("Histogram of diamond$price")
  #       )
  # 
  # p1 <- ggplot(diamonds, aes(x=carat, y=price, color=color)) +
  #         geom_point() +
  #         ggtitle("price over carat by color (linear scale)")
  # p2 <- ggplot(diamonds, aes(x=carat, y=price, color=color)) +
  #         geom_point() +
  #         scale_y_log10(breaks=pretty(diamonds_sample$price, n=5)) +
  #         scale_x_log10(breaks=pretty(diamonds_sample$carat, n=5)) +
  #         stat_smooth(method="lm", se=F) +
  #         ggtitle("price over carat by color (log-log scale)")
  # multiplot(p1, p2, cols=2)
  # print(summary(lm(log(diamonds$price)~log(diamonds$carat))))
  
  diamonds$price_carat_ratio = diamonds$price / diamonds$carat
  agg = aggregate(diamonds$price_carat_ratio, by=list(diamonds$color), FUN=mean)
  print(agg)
  # Box plot price/carat by color
  print(ggplot(diamonds, aes(color, price_carat_ratio)) +
    ggtitle('Price-carat ratio by color') +
    geom_boxplot() +
    coord_flip() +
    scale_x_discrete("color")
    )
}

# Main
# q1()
# q2()
# q3()
# df <- q4_run_experiments()
# q4_plot(df)
q5()
