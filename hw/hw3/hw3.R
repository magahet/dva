#!/usr/bin/Rscript

library(ggplot2)
library(reshape2)

# GT aciterations name: mmendiola3

# 0. Data Preprocessing
# a. Download the CSV files for the provided dataset. 
# b. Read mnist_train.csv and mnist_test.csv separately. 
# Note: There is no header row in the data; set header = FALSE when reading, e.g.: 
print('Reading Data')
train <- as.matrix(read.csv('mnist_train.csv', header = FALSE))
test <- as.matrix(read.csv('mnist_test.csv', header = FALSE))

# c. Partition the training set for classification of 0, 1 and 3, 5 classes based on the class 
# label (last row 785): train_0_1, train_3_5. 

print('Seperating Training sets')

train_0_1 <- train[,train[785,] <=1]
train_0_1 <- train_0_1[1:784,]

train_3_5 <- train[,train[785,] >=3]
train_3_5 <- train_3_5[1:784,]

# d. Do the same for the test set: test_0_1, test_3_5. 

print('Seperating Test sets')

test_0_1 <- test[,test[785,] <=1]
test_0_1 <- test_0_1[1:784,]

test_3_5 <- test[,test[785,] >=3]
test_3_5 <- test_3_5[1:784,]

# e. Separate the class label from all the partitions created
# (remove row 785 from the actual data and store it as a separate vector). 

print('Seperating Training labels and relabelling to -1/1')
true_label_train_0_1 <- train[785, train[785,] <=1]
true_label_train_0_1[true_label_train_0_1 == 0] <- -1

true_label_train_3_5 <- train[785, train[785,] >=3]
true_label_train_3_5[true_label_train_3_5 == 3] <- -1
true_label_train_3_5[true_label_train_3_5 == 5] <- 1

print('Seperating Test labels')
true_label_test_0_1 <- test[785, test[785,] <=1]
true_label_test_0_1[true_label_test_0_1 == 0] <- -1

true_label_test_3_5 <- test[785, test[785,] >=3]
true_label_test_3_5[true_label_test_3_5 == 3] <- -1
true_label_test_3_5[true_label_test_3_5 == 5] <- 1

# f. You will finally have two sets of data and their corresponding true labels: 
# - for classification of digits 0, 1: (train_0_1, test_0_1)  and (true_label_train_0_1, true_label_test_0_1);   
# - for classification of digits 3, 5: (train_3_5, test_3_5) and (true_label_train_3_5, true_label_test_3_5); 

# TRUE

# g. Visualize 1 image from each class to ensure you have read in the data correctly. You 
# will have 4 images corresponding to 0, 1, 3 and 5. You need to convert the 1D image 
# data into 2D for visualisation. 

print('Printing image samples from each set')

show_image <- function(row) {
  image(t(apply(matrix(row, 28, 28), 2, rev)), col=gray.colors(256))
}

par(mfrow=c(2,2))
show_image(train_0_1[,1])
title(main="train_0_1[,1]")
show_image(train_3_5[, 11000])
title(main="train_3_5[,11000]")
show_image(test_0_1[,1])
title(main="test_0_1[,1]")
show_image(test_3_5[,nrow(test_3_5)])
title(main="test_3_5[,nrow(test_3_5)]")
par(mfrow=c(1,1))


# 1. Theory

# NO CODE REQUIRED

# 2. Implementation

compute.theta <- function(x, y, theta, alpha) {
  # Stocastic gradient decent
  i <- sample(1:ncol(x), 1)
  yx = y[i] * x[,i]
  h = t(theta) %*% x[,i]
  gradient <- yx / (1 + exp(-y[i] * h))
  return(theta - alpha * gradient)
}

logistic.regression <- function(x, y, alpha=0.03, epsilon=1e-3, max_iterations=10000,
                                theta=NULL, alternate_stop=FALSE, verbose=FALSE, plot=FALSE) {
  
  print(paste('Starting logistic regression on', ncol(x), 'samples with', nrow(x), 'features'))
  
  # Add feature for bias term
  x <- rbind(x, rep(1, ncol(x)))
  
  # Initialize theta with random values between 0 and 1
  if (is.null(theta)) {
    theta <- as.matrix(runif(nrow(x)))
  }
  theta_old <- as.matrix(rep(0, nrow(x)))
  
  # Start timer and iterations
  start.time <- Sys.time()
  last.time <- Sys.time()
  iterations <- 0
  cost.log <- as.vector(cost(x, y, theta))
  delta_cost <- 1
  
  # Continue training iterations until the delta_cost is below the epsilon or max_iterations has been reached
  while((delta_cost > epsilon && iterations < max_iterations) || alternate_stop) {
    iterations = iterations + 1
    # Print periodic updates
    if (verbose && as.numeric(Sys.time() - last.time) > 3) {
      print(paste('Training iterations:', iterations))
      print(paste('Delta cost:', delta_cost))
      print(paste('Training accuracy:', accuracy(x, y, theta)))
      last.time <- Sys.time()
    }
    
    # Update theta
    theta <- compute.theta(x, y, theta, alpha)
    
    # Update cost.log
    if (iterations %% 100 == 0) {
      cost.log <- c(cost.log, cost(x, y, theta))
      delta_cost <- abs(diff(tail(cost.log, 2))) / tail(cost.log, 2)[1]
      
      if (plot) {
        flush.console()
        plot(cost.log, type='l', main="Learning curve", xlab="iterations (00s)", ylab="cost")
      }
    }
    
    # Alternative stopping criteria
    if (alternate_stop) {
      delta_theta <- theta - theta_old
      if (norm(delta_theta) < epsilon) {
        break
      }
      theta_old <- theta
    }
    
  }
  
  if (plot) {
    flush.console()
    plot(cost.log, type='l', main="Learning curve", xlab="iterations (00s)", ylab="cost")
  }
  
  print(paste('Training iterations:', iterations))
  print(paste('Delta cost:', delta_cost))
  print(paste('Elapsed time:', round(as.numeric(Sys.time() - start.time)), ' sec'))
  print(paste('Training accuracy:', accuracy(x, y, theta)))
  return(theta)
}

# Cost Function... negative log likelyhood

cost <- function(x, y, theta) {
  if (length(theta) == nrow(x) + 1) {
    x <- rbind(x, rep(1, ncol(x)))
  }
  return(mean(log(1 + exp(y * t(x) %*% theta))))
}

# Create labels for a set of samples given a theta
classify <- function(theta, x) {
  if (length(theta) == nrow(x) + 1) {
    x <- rbind(x, rep(1, ncol(x)))
  }
  h <- 1 / (1 + exp(t(x) %*% theta))
  h[h < 0.5] <- -1
  h[h > 0.5] <- 1
  h[h == 0.5] <- NA
  return(h)
}

# Calculate the ratio of correctly classified labels
test_fit <- function(p, y) {
  cp <- t(p) * y
  return(sum(cp[cp == 1])/ncol(cp))
}

# Calculate the accuracy of a given theta against a set of samples
accuracy <- function(x, y, theta) {
  if (length(theta) == nrow(x) + 1) {
    x <- rbind(x, rep(1, ncol(x)))
  }
  p = classify(theta, x)
  return(test_fit(p, y))
}

# 3. Training

# a. Train 2 models, one on the train_0_1 set and another on train_3_5, and report the training and test accuracies. 

theta_0_1 <- logistic.regression(train_0_1, true_label_train_0_1)
theta_3_5 <- logistic.regression(train_3_5, true_label_train_3_5)

print(paste('train_0_1 accuracy:', accuracy(train_0_1, true_label_train_0_1, theta_0_1)))
print(paste('test_0_1 accuracy:', accuracy(test_0_1, true_label_test_0_1, theta_0_1)))

print(paste('train_3_5 accuracy:', accuracy(train_3_5, true_label_train_3_5, theta_3_5)))
print(paste('test_3_5 accuracy:', accuracy(test_3_5, true_label_test_3_5, theta_3_5)))

# b. Repeat 3a 10 times, i.e. you should obtain 10 train and test accuracies for each set.
# Calculate the average train and test accuracies over the 10 runs, and report them. 

avg_reg <- function(x, y, test_x, test_y, theta=NULL, epsilon=1e-3, alternate_stop=FALSE, return_cost=FALSE) {
  result_train <- vector()
  result_test <- vector()
  
  for (i in 1:10) {
    print(paste('Running experiment', i))
    theta <- logistic.regression(x, y, theta=theta, epsilon=epsilon, alternate_stop=alternate_stop)
    if (return_cost) {
      result_train <- c(result_train, cost(x, y, theta))
      result_test <- c(result_test, cost(test_x, test_y, theta))
    } else {
      result_train <- c(result_train, accuracy(x, y, theta))
      result_test <- c(result_test, accuracy(test_x, test_y, theta))
    }
  }
  
  return(list(train=mean(result_train), test=mean(result_test)))
}
  
accuracy_0_1 <- avg_reg(train_0_1, true_label_train_0_1, test_0_1, true_label_test_0_1)
accuracy_3_5 <- avg_reg(train_3_5, true_label_train_3_5, test_3_5, true_label_test_3_5)

print(paste('Average train_0_1 accuracy:', mean(accuracy_0_1$train)))
print(paste('Average test_0_1 accuracy:', mean(accuracy_0_1$test)))

print(paste('Average train_3_5 accuracy:', mean(accuracy_3_5$train)))
print(paste('Average test_3_5 accuracy:', mean(accuracy_3_5$test)))


# c. For 0,1 and 3,5 cases, explain if you observe any difference you in accuracy.
# Also, explain why do you think this difference might be. 

# d. This assignment deals with binary classification.
# Explain what you would do if you had more than two classes to classify, using logistic regression. 


# 4. Evaluation
# 3/5 ONLY

# a. Experiment with different initializations of the parameter used for gradient descent.
# Clearly mention the initial values of the parameter tried, run the same experiment 
# as 3b using this initialization, report the average test and train accuracies obtained 
# by using this initialization, mention which is set of initializations is the better. 

# NOTES FROM PIAZZA
# Ananya Raval 
# 1. Q4a: A , different initialisations of weight parameters ONLY.
# 2. Q4b: convergence criteria refers to how to choose to stop your gradient descent. One way is number of iterations as you mentioned. then choose another way to stop gradient descent.
# 3. yes, total 2 X 10 runs. you only need to compare (EXPERIMENT vs BASELINE), see which is better and write a few comments of why you think that is.

theta <- as.matrix(rep(1e-9, nrow(train_3_5) + 1))
accuracy_alternate_theta <- avg_reg(train_3_5, true_label_train_3_5, test_3_5, true_label_test_3_5, theta=theta)
print(paste('Average alternate theta train_3_5 accuracy:', mean(accuracy_alternate_theta$train)))
print(paste('Average alternate theta test_3_5 accuracy:', mean(accuracy_alternate_theta$test)))

# b. Experiment with different convergence criteria for gradient descent. Clearly mention 
# the new criteria tried, run the same experiment as 3b using this new criteria, report 
# average test and train accuracies obtained using this criteria, mention which set of 
# criteria is better. 

accuracy_alternate_stop <- avg_reg(train_3_5, true_label_train_3_5, test_3_5, true_label_test_3_5, epsilon=1e-12, alternate_stop=TRUE)
print(paste('Average alternate stop train_3_5 accuracy:', mean(accuracy_alternate_stop$train)))
print(paste('Average alternate stop test_3_5 accuracy:', mean(accuracy_alternate_stop$test)))


# 5. Learning Curves

# a. For each set of classes (0,1 and 3,5), choose the following sizes to train on: 5%, 10%, 
# 15% ... 100% (i.e. 20 training set sizes). For each training set size, sample that many 
# inputs from the respective complete training set (i.e. train_0_1 or train_3_5). Train 
# your model on each subset selected, test it on the corresponding test set (i.e. 
# test_0_1 or test_3_5), and graph the training and test set accuracy over each split 
# (you should end up with TWO graphs - one showing training & test accuracy for 0,1 
# and another for 3,5 set). Remember to average the accuracy over 10 different 
# divisions of the data each of the above sizes so the graphs will be less noisy. 
# Comment on the trends of accuracy values you observe for each set. 

build_training_sample <- function(train_x, train_y, ratio) {
  indecies <- sample(1:ncol(train_x),  as.integer(ratio * ncol(train_x)))
  return(list(x=train_x[,indecies], y=train_y[indecies]))
}

plot_sub_data <- function(df, title, data_type) {
  df <- melt(df, id.vars='size')
  print(ggplot(df, aes(size, value, color=variable)) +
    geom_line() +
    geom_point() +
    ggtitle(title) +
    labs(x='Sample size (ratio of original training sample)', y=data_type))
}

accuracy_sub_0_1 <- data.frame()
accuracy_sub_3_5 <- data.frame()
for (i in seq(0.05, 1.0, 0.05)) {
  sample_0_1 <- build_training_sample(train_0_1, true_label_train_0_1, i)
  accuracy_sub_0_1 <- rbind(accuracy_sub_0_1,
                            c(avg_reg(sample_0_1$x, sample_0_1$y, test_0_1, true_label_test_0_1), size=i))
  
  sample_3_5 <- build_training_sample(train_3_5, true_label_train_3_5, i)
  accuracy_sub_3_5 <- rbind(accuracy_sub_3_5,
                            c(avg_reg(sample_3_5$x, sample_3_5$y, test_3_5, true_label_test_3_5), size=i))
  
  flush.console()
  plot_sub_data(accuracy_sub_3_5, '3/5 Accuracy vs. Sample size', 'Accuracy')
}

flush.console()
plot_sub_data(accuracy_sub_0_1, '0/1 Accuracy vs. Sample size', 'Accuracy')
plot_sub_data(accuracy_sub_3_5, '3/5 Accuracy vs. Sample size', 'Accuracy')

# b. Repeat 5a, but instead of plotting accuracies, plot the logistic loss/negative log 
# likelihood when training and testing, for each size. Comment on the trends of loss 
# values you observe for each set. 

neg_log_likelyhood_sub_0_1 <- data.frame()
neg_log_likelyhood_sub_3_5 <- data.frame()
for (i in seq(0.05, 1.0, 0.05)) {
  sample_0_1 <- build_training_sample(train_0_1, true_label_train_0_1, i)
  neg_log_likelyhood_sub_0_1 <- rbind(neg_log_likelyhood_sub_0_1,
                                      c(avg_reg(sample_0_1$x, sample_0_1$y, test_0_1, true_label_test_0_1, return_cost=TRUE), size=i))
  
  sample_3_5 <- build_training_sample(train_3_5, true_label_train_3_5, i)
  neg_log_likelyhood_sub_3_5 <- rbind(neg_log_likelyhood_sub_3_5,
                                      c(avg_reg(sample_3_5$x, sample_3_5$y, test_3_5, true_label_test_3_5, return_cost=TRUE), size=i))
  
  flush.console()
  plot_sub_data(neg_log_likelyhood_sub_3_5, '3/5 Negative Log Likelyhood vs. Sample size', 'Negative Log Likelyhood')
}

flush.console()
plot_sub_data(neg_log_likelyhood_sub_0_1, '0/1 Negative Log Likelyhood vs. Sample size', 'Negative Log Likelyhood')
plot_sub_data(neg_log_likelyhood_sub_3_5, '3/5 Negative Log Likelyhood vs. Sample size', 'Negative Log Likelyhood')


# MISC
s_x = rbind(train_3_5[,6122:6142], rep(1, ncol(s_x)))
s_y = true_label_train_3_5[6122:6142]
h <- 1 / (1 + exp(t(s_x) %*% theta_3_5))
p = classify(theta_3_5, s_x)
test_fit(p, s_y)