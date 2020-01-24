#1st plot for Exploratory Data Analysis Course
#Peer-graded Assignment: Course Project 1

#This script supposes that your cwd is "~/ExData_Plotting1". If not, set it with setwd().
library("lubridate")


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

#Convert the dates we need in proper format and subset the data we need, after cleaning them
data$Date <- as.Date(strptime(data$Date, format = "%d/%m/%Y"))
data$Global_active_power <- as.numeric(data$Global_active_power)
ToPlot <- subset(data, 
                 year(data$Date) == 2007 & month(data$Date) ==2 & day(data$Date) <= 2,
                 select = c(Time, Global_active_power)
                 )

#Plot
png(file="plot1.png", width=480, height = 480, units = "px")
hist(ToPlot$Global_active_power,
    col = "red",
    main = "Global Active Power",
    xlab = "Global Active Power (kilowatts)")
dev.off()