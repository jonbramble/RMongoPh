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

p <- ggplot(f_ph_all, aes( R, ph, color=X )) 
p + geom_line() + scale_x_continuous(limits = c(-0.1, 3.8))

q <- ggplot(f_eh_all, aes( R, eh, color=X )) 
q + geom_line() + scale_x_continuous(limits = c(-0.1, 3.8))

