source('~/dva/hw/hw1/hw1.r')

sum_lgamma <- function(n) {
  if (n < 1) {
    stop("value out of range")
  }
  sum <- 0
  for (i in seq(1, n, 1)) {
    sum <- sum + lgamma(i)
  }
  return(sum)
}

for (i in c(1, 5)) {
  stopifnot(all.equal(log_gamma_loop(i), lgamma(i)))
  stopifnot(all.equal(log_gamma_recursive(i), lgamma(i)))
  stopifnot(all.equal(sum_log_gamma_loop(i), sum_lgamma(i)))
  stopifnot(all.equal(sum_log_gamma_recursive(i), sum_lgamma(i)))
}

print("Tests passed!")

