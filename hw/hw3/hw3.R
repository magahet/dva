#!/usr/bin/Rscript

# GT account name: mmendiola3

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

my_logr <- function(x, y, alpha, threshold, vectorized=FALSE) {
  # Add featur for bias term
  x <- rbind(x, rep(1, ncol(x)))
  # Difference between theta
  del_theta <- as.matrix(1)
  # theta
  theta <- as.matrix(runif(nrow(x)))
  theta_old <- as.matrix(rep(0, nrow(x)))
  
  # Normalize
  theta <- theta/norm(theta)
  count <- 0
  
  # Compute gradient
  while(norm(del_theta) > threshold) {
    count = count + 1
    if (count %% 10 == 0) {
      print(paste('Training iterations: ', count))
      print(paste('norm(del_theta): ', norm(del_theta)))
    }
    
    if (vectorized) {
      yx = y * x
      h = t(x) %*% theta
      error = -y * h
      gradient <- rowSums(sweep(yx, 2, (1 + exp(error)), `/`), 1)
    } else {
      gradient <- as.vector(rep(0, nrow(x)))
      for (i in 1:ncol(x)) {
        yx = y[i] * x[,i]
        h = t(theta) %*% x[,i]
        gradient <- gradient + yx / (1 + exp(-y[i] * h))
      }
    }
    
    # Update theta
    theta <- theta_old - alpha * (1 / ncol(x)) * gradient
    theta <- theta / norm(theta)
    # print(theta[1:10,])
    del_theta <- as.matrix(theta_old - theta)
    theta_old <- theta
  }
  print(paste('Training iterations: ', count))
  return(theta)
}

classify <- function(theta, x) {
  if (length(theta) == nrow(x) + 1) {
    x <- rbind(x, rep(1, ncol(x)))
  }
  h <- t(x) %*% theta
  h[h < 0.0] <- -1
  h[h > 0.0] <- 1
  h[h == 0.0] <- NA
  return(h)
}

test_fit <- function(p, y) {
  cp <- t(p) * y
  return(sum(cp[cp == 1])/ncol(cp))
}

accuracy <- function(theta, x, y) {
  if (length(theta) == nrow(x) + 1) {
    x <- rbind(x, rep(1, ncol(x)))
  }
  p = classify(theta, x)
  return(test_fit(p, y))
}

theta.final <- my_logr(train_0_1, true_label_train_0_1, 0.1, 0.000001, TRUE)
accuracy(theta.final, test_0_1, true_label_test_0_1)

theta.final <- my_logr(train_0_1, true_label_train_0_1, 0.1, 0.000001, FALSE)
accuracy(theta.final, test_0_1, true_label_test_0_1)

theta.final <- my_logr(train_3_5, true_label_train_3_5, 0.1, 0.000001, TRUE)
accuracy(theta.final, test_3_5, true_label_test_3_5)

theta.final <- my_logr(train_3_5, true_label_train_3_5, 0.05, 0.05, FALSE)
accuracy(theta.final, test_3_5, true_label_test_3_5)
accuracy(theta.final, train_3_5, true_label_train_3_5)

s_x = train_3_5[,6122:6142]
s_y = true_label_train_3_5[6122:6142]

h = t(theta.final) %*% rbind(s_x, rep(1, ncol(s_x)))
p = classify(theta.final, s_x)



# 3. Training

# 4. Evaluation

# 5. Learning Curves