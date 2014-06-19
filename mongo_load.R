library(rmongodb)
library(ggplot2)
library(lubridate)
library(plyr)

source('multiplot.R')

theme_white <- function() {
  theme_update(panel.background = element_blank(),
               panel.grid.major = element_blank())
}

#time conversion function
unix2POSIXlt  <-  function (time)   
  structure(time, class = c("POSIXt", "POSIXlt")) 

# mongo db connection, over internet doesn't work well so copy to local first
host <- "localhost:27017"
db <- "phdata"
#get password from ~.REnviron file
username <- Sys.getenv("MONGODBUSER")
password <- Sys.getenv("MONGODBPWD")

#set the experiment name
experiment_name <- "SPY0005"

namespace_ph <- paste(db, "ph_points", sep=".")
namespace_eh <- paste(db, "eh_points", sep=".")

#create the db connection
mongo <- mongo.create(host=host , db=db, username=username, password=password)

#create the buffer for the data
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "experiment", experiment_name)
query <- mongo.bson.from.buffer(buf)

#get the length of the data arrays
count_ph <- mongo.count(mongo, namespace_ph, query)
count_eh <- mongo.count(mongo, namespace_eh, query)

#create vectors for each variable
ph <- vector()
eh <- vector()
tv_ph <- vector()
tv_eh <- vector()

#use a moving cursor to find the data from the mongodb
cursor <- mongo.find(mongo, namespace_ph, query)
while (mongo.cursor.next(cursor)) {
  val <- mongo.cursor.value(cursor)
  tv_ph[length(tv_ph)+1] <- mongo.bson.value(val, "time")
  ph[length(ph)+1] <- as.numeric(mongo.bson.value(val, "ph"))
}

#repeat on eh data
cursor <- mongo.find(mongo, namespace_eh, query)
while (mongo.cursor.next(cursor)) {
  val <- mongo.cursor.value(cursor)
  tv_eh[length(tv_eh)+1] <- mongo.bson.value(val, "time")
  eh[length(eh)+1] <- as.numeric(mongo.bson.value(val, "mv"))
}

# put the data into a dataframe as times
f_ph <- data.frame(tv_ph,ph,experiment_name)
f_eh <- data.frame(tv_eh,eh,experiment_name)
f_ph$datetime_ph <- as.POSIXlt(f_ph$tv_ph, origin="1970-01-01", tz = "BST")
f_eh$datetime_eh <- as.POSIXlt(f_eh$tv_eh, origin="1970-01-01", tz = "BST")

#set the start time for zero point
hour = 13
min = 32
k = 0.018/60

#create the offset in seconds
offset_ph = as.integer((as.Date(f_ph$datetime[1])))*86400 + hour*3600 + min*60
offset_eh = as.integer((as.Date(f_eh$datetime[1])))*86400 + hour*3600 + min*60
offset_date_time_ph = as.POSIXlt(offset, origin="1970-01-01",tz = "BST")
offset_date_time_eh = as.POSIXlt(offset, origin="1970-01-01",tz = "BST")

#create the offset in seconds
offset_date_time = as.POSIXlt(offset, origin="1970-01-01",tz = "BST")

#shift the xaxis time points
f_ph["t"] <- as.numeric(f_ph$datetime - offset_date_time, units="secs")
f_eh["t"] <- as.numeric(f_eh$datetime - offset_date_time, units="secs")

f_ph["R"] <- k*f_ph$t
f_eh["R"] <- k*f_eh$t

#calculate df/dt
diff_f <- diff(f_ph$ph)
#set the offset and search width
offset_a = 1400
offset_b = 2200
width = 400

a1 <- diff_f[offset_a:(offset_a+width)]
a2 <- diff_f[offset_b:(offset_b+width)]
#no strictly at the peak - bit slow here
E1 = f_ph$R[which(a1==max(a1))+offset_a]  
R1 = f_ph$ph[which(a1==max(a1))+offset_a]
E2 = f_ph$R[which(a2==max(a2))+offset_b]
R2 = f_ph$ph[which(a2==max(a2))+offset_b]

#additional plot to look at peaks in graph, set the offsets accordingly
#plot(diff_f, xlim=c(0,length(diff_f)),ylim=c(0,0.1))
#plot(f_ph$ph,ylim=c(0,15))

#set the theme for publication
theme_set(theme_bw(base_size = 20))
theme_white()

p <- ggplot(f_ph, aes( R, ph )) + geom_line() + geom_vline(xintercept = E1) + geom_vline(xintercept = E2) + labs(title=experiment_name) + scale_x_continuous(limits = c(-0.1, 4))
q <- ggplot(f_eh, aes( R, eh )) + geom_line() + geom_vline(xintercept = E1) + geom_vline(xintercept = E2) + labs(title=experiment_name) + scale_x_continuous(limits = c(-0.1, 4)) + ylab("eh /mV")
multiplot(p,q)
