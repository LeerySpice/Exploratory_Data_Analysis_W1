#clean enviroment
rm(list = ls())

#Create data dir
if (!file.exists("data")){
  dir.create("data")
}

#Get Data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "data/electric_power.zip", method = "curl")
unzip("data/electric_power.zip", exdir = "data")

#Read Data
file <- list.files(path = ".", recursive = TRUE,
                            pattern = "\\.txt", 
                            full.names = TRUE)
base <- read.csv2(file)
base$Date <- as.Date(base$Date,"%d/%m/%Y")
db <- subset(base, Date == "2007-02-02" | Date == "2007-02-01" )
names(db)
dim(db)

## plot1
png(filename = "data/plot1.png", width = 480, height = 480)
hist(as.numeric(as.character(db$Global_active_power)), 
     col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")
dev.off()

## plot2
db$Date2 <- as.POSIXct(paste(db$Date, db$Time), "%Y-%m-%d %H:%M:%S",tz="UTC")
png(filename = "data/plot2.png", width = 480, height = 480)
plot(db$Date2, as.numeric(as.character(db$Global_active_power)),
     type = "l", lwd = 1, xlab = "",
     ylab = "Global Active Power (kilowatts)")
dev.off()

## plot3
png(filename = "data/plot3.png", width = 480, height = 480)
plot(db$Date2, as.numeric(as.character(db$Sub_metering_1)),
     type = "l", lwd = 1, xlab = "", 
     ylab = "Energy sub metering")
lines(db$Date2, as.numeric(as.character(db$Sub_metering_2)),
     type = "l", lwd = 1, xlab = "", col = "red")
lines(db$Date2, as.numeric(as.character(db$Sub_metering_3)),
     type = "l", lwd = 1, xlab = "", col = "blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black","red","blue"), lty=1, cex=0.8)
dev.off()

## plot4
png(filename = "data/plot4.png", width = 480, height = 480)
par(mfrow=c(2,2))
# Plot 4.1 
plot(db$Date2, as.numeric(as.character(db$Global_active_power)),
     type = "l", lwd = 1, xlab = "",
     ylab = "Global Active Power")
# Plot 4.2
plot(db$Date2, as.numeric(as.character(db$Voltage)), 
     type = "l", xlab = "datetime", ylab = "Voltage")
# Plot 4.3
plot(db$Date2, as.numeric(as.character(db$Sub_metering_1)),
     type = "l", lwd = 1, xlab = "", 
     ylab = "Energy sub metering")
lines(db$Date2, as.numeric(as.character(db$Sub_metering_2)),
      type = "l", lwd = 1, xlab = "", col = "red")
lines(db$Date2, as.numeric(as.character(db$Sub_metering_3)),
      type = "l", lwd = 1, xlab = "", col = "blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black","red","blue"), lty=1, bty = "n", cex=0.8)
# Plot 4.4
plot(db$Date2, as.numeric(as.character(db$Global_reactive_power)),
     type = "l", lwd = 1, xlab = "datetime",
     ylab = "Global Active Power")

dev.off()

saveRDS(db, file = "db.Rdata")