#4th plot for Exploratory Data Analysis Course
#Peer-graded Assignment: Course Project 1

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
data[,c(3:9)] <- sapply(data[,c(3:9)], as.numeric)

ToPlot <- subset(data, 
                 year(data$Date) == 2007 & month(data$Date) ==2 & day(data$Date) <= 2,
                 select = c(-Date, -Global_intensity))

#Change parameters to create a 2x2 grid of plots
par(mfrow = c(2,2), mar = c(4,4,2,1), oma = c(0,0,2,0))
#Plots
#(1,1) Global Active Power vs Time
plot(ToPlot$Global_active_power ~ ToPlot$Time, type = "l", 
     xlab="", ylab = "Global Active Power (kilowatts)")
#(1,2) Voltage vs Time
plot(ToPlot$Voltage ~ ToPlot$Time, type = "l", 
     xlab="datetime", ylab = "Voltage")
#(2,1) Sub_metering vs Time
plot(ToPlot$Sub_metering_1 ~ ToPlot$Time, type = "l", 
     xlab = "", ylab = "Energy sub metering")
lines(ToPlot$Sub_metering_2 ~ ToPlot$Time, col = "red")
lines(ToPlot$Sub_metering_3 ~ ToPlot$Time, col = "blue")
legend("topright", col = c("black", "red", "blue"), lwd = 1,
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
#(2,2) Global reactive power vs Time
plot(ToPlot$Global_reactive_power ~ ToPlot$Time, type = "l", 
     xlab="datetime", ylab = "Global_reactive_power")

#This time we have to make the plots first and then copy them to png.
#Otherwise, the only plot contained in the png file is the last one
dev.copy(png, "plot4.png", width=480, height=480)   
dev.off()