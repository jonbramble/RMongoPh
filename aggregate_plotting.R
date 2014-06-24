library(ggplot2)
source('theme_white.R')

load('f_ph_SPY0006.Rda')
f_ph_all <- f_ph
load('f_ph_SPY0003.Rda')
f_ph_all <- rbind(f_ph_all,f_ph)
load('f_ph_SPY0004.Rda')
f_ph_all <- rbind(f_ph_all,f_ph)
load('f_ph_SPY0005.Rda')
f_ph_all <- rbind(f_ph_all,f_ph)

load('f_eh_SPY0006.Rda')
f_eh_all <- f_eh
load('f_eh_SPY0003.Rda')
f_eh_all <- rbind(f_eh_all,f_eh)
load('f_eh_SPY0004.Rda')
f_eh_all <- rbind(f_eh_all,f_eh)
load('f_eh_SPY0005.Rda')
f_eh_all <- rbind(f_eh_all,f_eh)

theme_set(theme_bw(base_size = 22))
theme_white()

p <- ggplot(f_ph_all, aes( R, ph, color=X )) + geom_line() + scale_x_continuous(limits = c(-0.1, 3.5))
ggsave(p, file="ph1.eps", width=8, height=3)

q <- ggplot(f_eh_all, aes( R, eh, color=X )) + geom_line() + scale_x_continuous(limits = c(-0.1, 3.5))
ggsave(q, file="ph2.eps", width=8, height=3)
