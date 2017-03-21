#!/usr/bin/Rscript

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

# e. Separate the class label from all the partitions created (remove row 785 from the 
#                                                              actual data and store it as a separate vector). 
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
#   - for classification of digits 0, 1: (train_0_1, test_0_1)  and (true_label_train_0_1, true_label_test_0_1);   
#   - for classification of digits 3, 5: (train_3_5, test_3_5) and (true_label_train_3_5, true_label_test_3_5); 

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

compute.theta <- function(x, y, theta, alpha, vectorized=FALSE, stocastic=TRUE) {
  if (stocastic == TRUE) {
    # Stocastic gradient decent
    i <- sample(1:ncol(x), 1)
    yx = y[i] * x[,i]
    h = t(theta) %*% x[,i]
    gradient <- yx / (1 + exp(-y[i] * h))
    sample_size = 1
  } else if (vectorized) {
    # Vectorized batch gradient decent
    yx = y * x
    h = t(x) %*% theta
    error = -y * h
    gradient <- rowSums(sweep(yx, 2, (1 + exp(error)), `/`), 1)
    sample_size = ncol(x)
  } else {
    # Semi-vectorized batch gradient decent
    gradient <- as.vector(rep(0, nrow(x)))
    for (i in 1:ncol(x)) {
      yx = y[i] * x[,i]
      h = t(theta) %*% x[,i]
      gradient <- gradient + yx / (1 + exp(-y[i] * h))
    }
    sample_size = ncol(x)
  }
  return(theta - (1 / sample_size) * alpha * gradient)
}

logistic.regression <- function(x, y, alpha=0.1, delta_alpha=0.9, epsilon=1e-4, vectorized=FALSE, stocastic=TRUE, adaptive_alpha=TRUE, max_time=60, max_iterations=10000) {
  print(paste('Starting logistic regression on ', ncol(x), ' samples with ', nrow(x), ' features'))
  # Add feature for bias term
  x <- rbind(x, rep(1, ncol(x)))
  
  # Initialize theta with random values between 0 and 1
  theta <- as.matrix(runif(nrow(x)))
  theta_old <- as.matrix(rep(0, nrow(x)))
  
  # Start timer and iterations
  start.time <- Sys.time()
  last.time <- Sys.time()
  iterations <- 0
  cost.log <- as.vector(cost(x, y, theta))
  delta_cost <- 1
  
  # Continue training iterations until the l1-norm of delta_theta is below the epsilon or max_time has elapsed
  # Also continue if gradiant is zero to prevent premature exit
  while(delta_cost > epsilon && iterations < max_iterations) {
    iterations = iterations + 1
    # Print periodic updates
    if (as.numeric(Sys.time() - last.time) > 3) {
      print(paste('Training iterations: ', iterations))
      print(paste('Delta cost: ', delta_cost))
      print(paste('Training accuracy: ', accuracy(theta, x, y)))
      last.time <- Sys.time()
    }
    
    # Update theta
    theta <- compute.theta(x, y, theta, alpha)
    
    # Update cost.log
    if (iterations %% 100 == 0) {
      cost.log <- c(cost.log, cost(x, y, theta))
      delta_cost <- abs(diff(tail(cost.log, 2))) / tail(cost.log, 2)[1]
    }
  }
  
  plot(cost.log, type='l', main="Learning curve", xlab="iterations (00s)", ylab="cost")
  
  print(paste('Training iterations: ', iterations))
  print(paste('Delta cost: ', delta_cost))
  print(paste('Elapsed time: ', round(as.numeric(Sys.time() - start.time)), ' sec'))
  print(paste('Training accuracy: ', accuracy(theta, x, y)))
  return(theta)
}


# Cost Function... negative log likelyhood

cost <- function(x, y, theta) {
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
accuracy <- function(theta, x, y) {
  if (length(theta) == nrow(x) + 1) {
    x <- rbind(x, rep(1, ncol(x)))
  }
  p = classify(theta, x)
  return(test_fit(p, y))
}

# 3. Training

# a. Train 2 models, one on the train_0_1 set and another on train_3_5, and report the training and test accuracies. 
theta_0_1 <- logistic.regression(train_0_1, true_label_train_0_1, alpha=0.03, epsilon=1e-4, stocastic=TRUE, max_iterations=10000)
print(paste('test_0_1 accuracy: ', accuracy(theta_0_1, test_0_1, true_label_test_0_1)))

theta_3_5 <- logistic.regression(train_3_5, true_label_train_3_5, alpha=0.03, epsilon=1e-4, stocastic=TRUE, max_iterations=10000)
print(paste('test_3_5 accuracy: ', accuracy(theta_3_5, test_3_5, true_label_test_3_5)))

# b. Repeat 3a 10 times, i.e. you should obtain 10 train and test accuracies for each set. Calculate the average train and test accuracies over the 10 runs, and report them. 

sum_accuracy_3_5 <- 0
for (i in 1:10) {
  theta <- logistic.regression(train_3_5, true_label_train_3_5, alpha=0.03, epsilon=1e-4, stocastic=TRUE, max_iterations=10000)
  sum_accuracy_3_5 <- sum_accuracy_3_5 + accuracy(theta_3_5, test_3_5, true_label_test_3_5)
}
# c. For 0,1 and 3,5 cases, explain if you observe any difference you in accuracy. Also, explain why do you think this difference might be. 

# d. This assignment deals with binary classification. Explain what you would do if you had more than two classes to classify, using logistic regression. 

s_x = rbind(train_3_5[,6122:6142], rep(1, ncol(s_x)))
s_y = true_label_train_3_5[6122:6142]
h <- 1 / (1 + exp(t(s_x) %*% theta_3_5))
p = classify(theta_3_5, s_x)
test_fit(p, s_y)




# 4. Evaluation

# 5. Learning Curves