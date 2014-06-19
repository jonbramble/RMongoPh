E1 <- c(0.13,0.9,1.22)
X <- c(0.2,0.3,0.4) 
E1p <- 2.7*X
dat <- data.frame(X,E1)

p <- ggplot(dat, aes( X, E1 )) 
p + geom_point() + scale_x_continuous(limits = c(0, 1)) + scale_y_continuous(limits = c(0, 3))
p2 <- ggplot(dat, aes( X, E1p ))
p2 + geom_line() + scale_x_continuous(limits = c(0, 1)) + scale_y_continuous(limits = c(0, 3))
