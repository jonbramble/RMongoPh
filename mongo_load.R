library(rmongodb)
library(ggplot2)
library(lubridate)
library(plyr)

unix2POSIXlt  <-  function (time)   
  structure(time, class = c("POSIXt", "POSIXlt")) 
# mongo db connection, over internet doesn't work well so copy to local first
host <- "localhost:27017"
db <- "phdata"
#get password from ~.REnviron file
username <- Sys.getenv("MONGODBUSER")
password <- Sys.getenv("MONGODBPWD")

experiment_name <- "SPY0005"

namespace_ph <- paste(db, "ph_points", sep=".")
namespace_eh <- paste(db, "eh_points", sep=".")

#create the db connection
mongo <- mongo.create(host=host , db=db, username=username, password=password)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "experiment", experiment_name)
query <- mongo.bson.from.buffer(buf)

count_ph <- mongo.count(mongo, namespace_ph, query)
count_eh <- mongo.count(mongo, namespace_eh, query)

ph <- vector()
eh <- vector()
tv_ph <- vector()
tv_eh <- vector()

cursor <- mongo.find(mongo, namespace_ph, query)
while (mongo.cursor.next(cursor)) {
  val <- mongo.cursor.value(cursor)
  tv_ph[length(tv_ph)+1] <- mongo.bson.value(val, "time")
  ph[length(ph)+1] <- as.numeric(mongo.bson.value(val, "ph"))
}

cursor <- mongo.find(mongo, namespace_eh, query)
while (mongo.cursor.next(cursor)) {
  val <- mongo.cursor.value(cursor)
  tv_eh[length(tv_eh)+1] <- mongo.bson.value(val, "time")
  eh[length(eh)+1] <- as.numeric(mongo.bson.value(val, "mv"))
}

f_ph <- data.frame(tv_ph,ph)
f_ph$datetime_ph <- as.POSIXlt(f_ph$tv_ph, origin="1970-01-01", tz = "BST")
f_eh <- data.frame(tv_eh,eh)
f_eh$datetime_eh <- as.POSIXlt(f_eh$tv_eh, origin="1970-01-01", tz = "BST")

hour = 13
min = 34
k = 0.02/60

offset = as.integer((as.Date(f_ph$datetime[1])))*86400 + hour*3600 + min*60
offset_date_time = as.POSIXlt(offset, origin="1970-01-01",tz = "BST")
offset_date_time

f["t"] <- as.numeric(f$datetime - offset_date_time, units="secs")
f["R"] <- k*f$t
difff <- diff(f$ph)
offset_a = 1000
offset_b = 2200
width = 400
a1 <- difff[offset_a:(offset_a+width)]
a2 <- difff[offset_b:(offset_b+width)]
#no strictly at the peak
E1 = f$R[which(a1==max(a1))+offset_a]  
R1 = f$ph[which(a1==max(a1))+offset_a]
E2 = f$R[which(a2==max(a2))+offset_b]
R2 = f$ph[which(a2==max(a2))+offset_b]

plot(difff, xlim=c(0,length(difff)),ylim=c(0,0.1))
#plot(f$ph,ylim=c(0,15))

p <- ggplot(f, aes( R, ph )) 
p + geom_line() + scale_x_continuous(limits = c(-0.1, 4))


