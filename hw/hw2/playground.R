n=seq(1, 10)
plot(n, n^2, log="xy", type='l', col="blue", main="log-log")
lines(n, 2^n, col="red")
lines(n, n^log(n), col="green")

plot(n, n^2, log="y", type='l', col="blue", main="log-linear")
lines(n, 2^n, col="red")
lines(n, n^log(n), col="green")

plot(n, log(n^2), log="xy", type='l', col="blue", main="log-log-log")
lines(n, log(2^n), col="red")
lines(n, log(n^log(n)), col="green")

plot(n, log(n^2), log="y", type='l', col="blue", main="log-log-linear")
lines(n, log(2^n), col="red")
lines(n, log(n^log(n)), col="green")