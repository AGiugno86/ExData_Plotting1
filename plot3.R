#This script supposes that your cwd is "~/ExData_Plotting1". If not, set it with setwd().
library("lubridate")

#To have shortenings of weekdays in english, the second argument is because I'm Linux user
Sys.setlocale("LC_TIME", "C")

#Download the zip folder and extract the dataset
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destFile = "HP_Consumption.zip"
download.file(url = url, destfile = destFile)

#Unzip. The option overwrite is set to FALSE to avoid unzipping again if the file already exists
unzip(zipfile = destFile, overwrite = FALSE)
file.remove(destFile)

#Load the data and clean them
#To avoid formatting problems, we choose to set stringsAsFactors to FALSE. 
#Otherwise the decimals of numericals are not properly recognised

data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", 
                   dec=".", stringsAsFactors=FALSE)
data[data == "?"] <- NA   #Replace ? with NA

#Convert the dates we need in proper format and subset the data we need
data$Date <- as.Date(strptime(data$Date, format = "%d/%m/%Y"))
data$Time <- as.POSIXct(paste(data$Date,data$Time), format = "%Y-%m-%d %H:%M:%S")
data[,c(7:9)] <- sapply(data[,c(7:9)], as.numeric)

ToPlot <- subset(data, 
                 year(data$Date) == 2007 & month(data$Date) ==2 & day(data$Date) <= 2,
                 select = c(2,7:9))

#Plot
png(file="plot3.png", width=480, height = 480, units = "px")
  plot(ToPlot$Sub_metering_1 ~ ToPlot$Time, type = "l", 
       xlab = "", ylab = "Energy sub metering")
  lines(ToPlot$Sub_metering_2 ~ ToPlot$Time, col = "red")
  lines(ToPlot$Sub_metering_3 ~ ToPlot$Time, col = "blue")
  legend("topright", col = c("black", "red", "blue"), lwd = 1,
         legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()