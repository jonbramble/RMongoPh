library(ggplot2)

E1 <- c(0.58,0.87,1.11,1.45)
X <- c(0.2,0.3,0.4,0.5) 

Xl <- c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1) 
E1f <- 2.7*Xl
dat <- data.frame(X,E1,"data")
colnames(dat) <- c("X","E1","description")
f <- data.frame(Xl,E1f,"ruby")
colnames(f) <- c("X","E1","description")
j = rbind(dat,f)

p <- ggplot() 
p + geom_point(data = dat, aes(x=X, y= E1, description='data')) + geom_line(data = f, aes(x=X, y=E1)) + scale_x_continuous(limits = c(0, 1)) + scale_y_continuous(limits = c(0, 3))
#p2 <- ggplot(dat, aes( X, E1p ))
#p2 + geom_line() + scale_x_continuous(limits = c(0, 1)) + scale_y_continuous(limits = c(0, 3))
