#Install and load the "dplyr" package.
install.packages("dplyr")

#Install and load the "caret" package
install.packages("caret", dependencies = c("Depends", "Suggests"))

#install.packages("devtools")
install.packages("backports")

#Install and load the "taucharts" package
devtools::install_github("hrbrmstr/taucharts")

#Install and load the "RMySQL" package.
install.packages("RMySQL")

#Install and load the "plotly" package.
install.packages("plotly")

#Install and load the "lubridate" package.
install.packages("lubridate")

#Install and load the "ggfortify" package.
install.packages('ggfortify')

#Install and load the "forecast" package.
install.packages('forecast')

library(caret)
library(dplyr)
library(taucharts)
library(RMySQL)
library(lubridate)
library(plotly)
library(ggplot2)
library(ggfortify)
library(forecast)

## Create a database connection
con = dbConnect(MySQL(), user='deepAnalytics', password='Sqltask1234!', dbname='dataanalytics2018', host='data-analytics-2018.cbrosir2cswx.us-east-1.rds.amazonaws.com')

## List the tables contained in the database
dbListTables(con)

#electricPowerConsumptionDataSet <- read.csv("/Users/krishnav/Desktop/Workbench/Cisco_Lenovo_Laptop/misc/personal/UT-Data-Analytics/Study-Materials/Chapter-3/Task-2/household_power_consumption_Comma.csv")

## Get all attributes for yr_2006
yr_2006ALL <- dbGetQuery(con, "SELECT * FROM yr_2006")


## Get all attributes for yr_2007
yr_2007ALL <- dbGetQuery(con, "SELECT * FROM yr_2007")

## Get all attributes for yr_2008
yr_2008ALL <- dbGetQuery(con, "SELECT * FROM yr_2008")


#Create Primary Data Frame
## Combine tables into one dataframe using dplyr
newDF <- bind_rows(yr_2006ALL, yr_2007ALL, yr_2008ALL)

## Combine Date and Time attribute values in a new attribute column
combined3YrsDF <-cbind(newDF,paste(newDF$Date,newDF$Time), stringsAsFactors=FALSE)

## Give the new attribute in the 6th column a header name
## NOTE: if you downloaded more than 5 attributes you will need to change the column number)
colnames(combined3YrsDF)[11] <-"DateTime"

## Convert DateTime from character to POSIXct 
combined3YrsDF$DateTime <- as.POSIXct(combined3YrsDF$DateTime, "%Y/%m/%d %H:%M:%S")

## Plot all of sub-meter 1
plot(combined3YrsDF$Sub_metering_1)

# preprocessing of data using Lubridate to make working with DateTime much easier
## Create "year" attribute with lubridate
combined3YrsDF$year <- year(combined3YrsDF$DateTime)
## Create "quarter" attribute with lubridate
combined3YrsDF$quarter <- quarter(combined3YrsDF$DateTime, with_year = TRUE)
## Create "month" attribute with lubridate
combined3YrsDF$month <- month(combined3YrsDF$DateTime)
## Create "day" attribute with lubridate
combined3YrsDF$day <- day(combined3YrsDF$DateTime)
## Create "week" attribute with lubridate
combined3YrsDF$week <- week(combined3YrsDF$DateTime)
## Create "weekdays" attribute with lubridate
combined3YrsDF$weekdays <- wday(combined3YrsDF$DateTime, label = TRUE,  week_start = getOption("lubridate.week.start", 7))
## Create "hour" attribute with lubridate
combined3YrsDF$hour <- hour(combined3YrsDF$DateTime)
## Create "minutes" attribute with lubridate
combined3YrsDF$minute <- minute(combined3YrsDF$DateTime)


#Visualize a Single Day with Plotly say the 9th day of January 2008 - All observations
houseDay <- filter(combined3YrsDF, combined3YrsDF$DateTime > '2008-1-8 23:59:00' & combined3YrsDF$DateTime < '2008-1-9 23:59:00')
## Plot sub-meter 1
plot_ly(houseDay, x = ~houseDay$DateTime, y = ~houseDay$Sub_metering_1, type = 'scatter', mode = 'lines')


#Plotting all three sub-meters helps gain a better perspective on all of the power being consumed.
# Plot sub-meter 1, 2 and 3 with title, legend and labels - All observations
plot_ly(houseDay, x = ~houseDay$DateTime, y = ~houseDay$Sub_metering_1, name = 'Kitchen', type = 'scatter', mode = 'lines') %>%
  add_trace(y = ~houseDay$Sub_metering_2, name = 'Laundry Room', mode = 'lines') %>%
  add_trace(y = ~houseDay$Sub_metering_3, name = 'Water Heater & AC', mode = 'lines') %>%
  layout(title = "Power Consumption January 9th, 2008",
         xaxis = list(title = "Time"),
         yaxis = list (title = "Power (watt-hours)"))


#Reducing Granularity by subsetting the 9th day of January 2008 by 10 Minute frequency
houseDay10 <- dplyr::filter(combined3YrsDF, year == 2008 & month == 1 & day == 9 & (minute == 0 | minute == 10 | minute == 20 | minute == 30 | minute == 40 | minute == 50))

## Plot sub-meter 1, 2 and 3 with title, legend and labels - 10 Minute frequency
plot_ly(houseDay10, x = ~houseDay10$DateTime, y = ~houseDay10$Sub_metering_1, name = 'Kitchen', type = 'scatter', mode = 'lines') %>%
  add_trace(y = ~houseDay10$Sub_metering_2, name = 'Laundry Room', mode = 'lines') %>%
  add_trace(y = ~houseDay10$Sub_metering_3, name = 'Water Heater & AC', mode = 'lines') %>%
  layout(title = "Power Consumption January 9th, 2008",
         xaxis = list(title = "Time"),
         yaxis = list (title = "Power (watt-hours)"))




# Visualize a Single week with Plotly by Subsetting say the second week of 2008 - All Observations
houseWeek <- filter(combined3YrsDF, year == 2008 & month == 1 & week == 2 )
## Plot subset houseWeek
plot(houseWeek$Sub_metering_1)
## Plot sub-meter 1 using plotly
plot_ly(houseWeek, x = ~houseWeek$DateTime, y = ~houseWeek$Sub_metering_1, type = 'scatter', mode = 'lines')

#Plotting all three sub-meters helps gain a better perspective on all of the power being consumed.
# Plot sub-meter 1, 2 and 3 with title, legend and labels - All observations
plot_ly(houseWeek, x = ~houseWeek$DateTime, y = ~houseWeek$Sub_metering_1, name = 'Kitchen', type = 'scatter', mode = 'lines') %>%
  add_trace(y = ~houseWeek$Sub_metering_2, name = 'Laundry Room', mode = 'lines') %>%
  add_trace(y = ~houseWeek$Sub_metering_3, name = 'Water Heater & AC', mode = 'lines') %>%
  layout(title = "Power Consumption January 8th - 14th, 2008",
         xaxis = list(title = "Time"),
         yaxis = list (title = "Power (watt-hours)"))


#Reducing Granularity by subsetting the 9th day of January 2008 by 10 Minute frequency
houseWeek2 <- dplyr::filter(combined3YrsDF, year == 2008 & month == 1 & week == 2 & (minute == 0 | minute == 10 | minute == 20 | minute == 30 | minute == 40 | minute == 50))

## Plot sub-meter 1, 2 and 3 with title, legend and labels - 10 Minute frequency
plot_ly(houseWeek2, x = ~houseWeek2$DateTime, y = ~houseWeek2$Sub_metering_1, name = 'Kitchen', type = 'scatter', mode = 'lines') %>%
  add_trace(y = ~houseWeek2$Sub_metering_2, name = 'Laundry Room', mode = 'lines') %>%
  add_trace(y = ~houseWeek2$Sub_metering_3, name = 'Water Heater & AC', mode = 'lines') %>%
  layout(title = "Power Consumption January 8th - 14th, 2008 with 10 Minute frequency",
         xaxis = list(title = "Time"),
         yaxis = list (title = "Power (watt-hours)"))






# Visualize a Single Month with Plotly by Subsetting say the month of Jan 2008 - All Observations
houseMonth <- filter(combined3YrsDF, year == 2008 & month == 1 )
## Plot subset houseWeek
plot(houseMonth$Sub_metering_1)
## Plot sub-meter 1 using plotly
plot_ly(houseMonth, x = ~houseMonth$DateTime, y = ~houseMonth$Sub_metering_1, type = 'scatter', mode = 'lines')

#Plotting all three sub-meters helps gain a better perspective on all of the power being consumed.
# Plot sub-meter 1, 2 and 3 with title, legend and labels - All observations
plot_ly(houseMonth, x = ~houseMonth$DateTime, y = ~houseMonth$Sub_metering_1, name = 'Kitchen', type = 'scatter', mode = 'lines') %>%
  add_trace(y = ~houseMonth$Sub_metering_2, name = 'Laundry Room', mode = 'lines') %>%
  add_trace(y = ~houseMonth$Sub_metering_3, name = 'Water Heater & AC', mode = 'lines') %>%
  layout(title = "Power Consumption January  2008",
         xaxis = list(title = "Time"),
         yaxis = list (title = "Power (watt-hours)"))


#Reducing Granularity by subsetting the month of January 2008 by 10 Minute frequency
houseMonth1 <- dplyr::filter(combined3YrsDF, year == 2008 & month == 1 & (minute == 0 | minute == 10 | minute == 20 | minute == 30 | minute == 40 | minute == 50))

## Plot sub-meter 1, 2 and 3 with title, legend and labels - 10 Minute frequency
plot_ly(houseMonth1, x = ~houseMonth1$DateTime, y = ~houseMonth1$Sub_metering_1, name = 'Kitchen', type = 'scatter', mode = 'lines') %>%
  add_trace(y = ~houseMonth1$Sub_metering_2, name = 'Laundry Room', mode = 'lines') %>%
  add_trace(y = ~houseMonth1$Sub_metering_3, name = 'Water Heater & AC', mode = 'lines') %>%
  layout(title = "Power Consumption January 2008 with 10 Minute frequency",
         xaxis = list(title = "Time"),
         yaxis = list (title = "Power (watt-hours)"))



## Subset to one observation per week on Mondays at 8:00pm for 2007, 2008 and 2009
house070809weekly <- dplyr::filter(combined3YrsDF,  weekdays == "Mon" & hour == 20 & minute == 1)

## Create Time Series object with SubMeter3
tsSM3_070809weekly <- ts(house070809weekly$Sub_metering_3, frequency=52, start=c(2007,1))

## Plot using autoplot for sub-meter 3
# autoplot(tsSM3_070809weekly)

## Plot using autoplot for sub-meter 3 by adding labels, colors etc
autoplot(tsSM3_070809weekly, ts.colour = 'red', xlab = "Time", ylab = "Watt Hours", main = "Sub-meter 3 Weekly Readings")

## Plot using for sub-meter 3  
plot.ts(tsSM3_070809weekly,   main = "Sub-meter 3 Weekly Readings")





## Subset to one observation per month  on 21st day of the month at 8:00pm for 2007, 2008 and 2009
house070809monthly <- dplyr::filter(combined3YrsDF, day == 21 & hour == 20 & minute == 1)

## Create Time Series object with SubMeter2 once every month
tsSM2_070809monthly <- ts(house070809monthly$Sub_metering_2, frequency=12, start=c(2007,1))

## Plot using autoplot for sub-meter 2 by adding labels, colors etc
autoplot(tsSM2_070809monthly, ts.colour = 'green', xlab = "Time", ylab = "Watt Hours", main = "Sub-meter 2")

## Plot using for sub-meter 2  
plot.ts(tsSM2_070809monthly,   main = "Sub-meter 2 Monthly Readings")







## Create Time Series object with SubMeter1 once every month
tsSM1_070809monthly <- ts(house070809monthly$Sub_metering_1, frequency=12, start=c(2007,1))

## Plot using autoplot for sub-meter 1 by adding labels, colors etc
autoplot(tsSM1_070809monthly, ts.colour = 'orange', xlab = "Time", ylab = "Watt Hours", main = "Sub-meter 3")

## Plot using for sub-meter 1  
plot.ts(tsSM1_070809monthly,   main = "Sub-meter 1 Monthly Readings")




#Forecasting time series:


## Apply time series linear regression to the sub-meter 3 ts object and use summary to obtain R2 and RMSE from the model you built
fitSM3 <- tslm(tsSM3_070809weekly ~ trend + season)
summary(fitSM3)

## Create the forecast for sub-meter 3. Forecast ahead 20 time periods
forecastfitSM3 <- forecast(fitSM3, h=20)
## Plot the forecast for sub-meter 3. 
plot(forecastfitSM3)

## Create sub-meter 3 forecast with confidence levels 80 and 90
forecastfitSM3c <- forecast(fitSM3, h=20, level=c(80,90))
summary(forecastfitSM3c)

## Plot sub-meter 3 forecast, limit y and add labels
plot(forecastfitSM3c, ylim = c(0, 40), ylab= "Watt-Hours", xlab="Time", main = "Forecasts from Linear Regression Model for Weekly Sub-meter 3  Readings")




## Apply time series linear regression to the sub-meter 2 ts object and use summary to obtain R2 and RMSE
fitSM2 <- tslm(tsSM2_070809monthly ~ trend + season)
summary(fitSM2)

## Create the forecast for sub-meter 2. Forecast ahead 20 time periods
forecastfitSM2 <- forecast(fitSM2, h=20)
## Plot the forecast for sub-meter 2. 
plot(forecastfitSM2)

## Create sub-meter 2 forecast with confidence levels 80 and 85
forecastfitSM2c <- forecast(fitSM2, h=20, level=c(80,85))
summary(forecastfitSM2c)

## Plot sub-meter 2 forecast, limit y and add labels
plot(forecastfitSM2c, ylim = c(-10, 27), ylab= "Watt-Hours", xlab="Time", main = "Forecasts from Linear Regression Model for Monthly Sub-meter 2  Readings")





## Apply time series linear regression to the sub-meter 1 its object and use summary to obtain R2 and RMSE
fitSM1 <- tslm(tsSM1_070809monthly ~ trend + season)
summary(fitSM1)

## Create the forecast for sub-meter 1. Forecast ahead 20 time periods
forecastfitSM1 <- forecast(fitSM1, h=20)
## Plot the forecast for sub-meter 2. 
plot(forecastfitSM1)

## Create sub-meter 1 forecast with confidence levels 80 and 85
forecastfitSM1c <- forecast(fitSM2, h=20, level=c(85,90))
summary(forecastfitSM1c)

## Plot sub-meter 1 forecast, limit y and add labels
plot(forecastfitSM1c, ylim = c(-10, 27), ylab= "Watt-Hours", xlab="Time", main = "Forecasts from Linear Regression Model for Monthly Sub-meter 1  Readings")



#Decomposing time series:

## Decompose Sub-meter 3 into trend, seasonal and remainder
components070809SM3weekly <- decompose(tsSM3_070809weekly)
## Plot decomposed sub-meter 3
plot(components070809SM3weekly)
## Check summary statistics for decomposed sub-meter 3
summary(components070809SM3weekly)




## Decompose Sub-meter 2 into trend, seasonal and remainder
components070809SM2monthly <- decompose(tsSM2_070809monthly)
## Plot decomposed sub-meter 2
plot(components070809SM2monthly)
## Check summary statistics for decomposed sub-meter 2
summary(components070809SM2monthly)



## Decompose Sub-meter 1 into trend, seasonal and remainder
components070809SM1monthly <- decompose(tsSM1_070809monthly)
## Plot decomposed sub-meter 1
plot(components070809SM1monthly)
## Check summary statistics for decomposed sub-meter 1
summary(components070809SM1monthly)


# HoltWinters Forecasting

## Seasonal adjusting sub-meter 3 by subtracting the seasonal component & plot
tsSM3_070809Adjusted <- tsSM3_070809weekly - components070809SM3weekly$seasonal
autoplot(tsSM3_070809Adjusted)

## Test Seasonal Adjustment by running Decompose again. Note the very, very small scale for Seasonal
plot(decompose(tsSM3_070809Adjusted))

## Holt Winters Exponential Smoothing & Plot
tsSM3_HW070809 <- HoltWinters(tsSM3_070809Adjusted, beta=FALSE, gamma=FALSE)
plot(tsSM3_HW070809, ylim = c(0, 25))

## HoltWinters forecast & plot
tsSM3_HW070809for <- forecast(tsSM3_HW070809, h=25)
plot(tsSM3_HW070809for, ylim = c(0, 25), ylab= "Watt-Hours", xlab="Time - Sub-meter 3")

## Forecast HoltWinters with diminished confidence levels
tsSM3_HW070809forC <- forecast(tsSM3_HW070809, h=25, level=c(10,25))
## Plot only the forecasted area
plot(tsSM3_HW070809forC, ylim = c(-12, 5), ylab= "Watt-Hours", xlab="Time - Sub-meter 3", start(2010))






## Seasonal adjusting sub-meter 2 by subtracting the seasonal component & plot
tsSM2_070809Adjusted <- tsSM2_070809monthly - components070809SM2monthly$seasonal
autoplot(tsSM2_070809Adjusted)

## Test Seasonal Adjustment by running Decompose again. Note the very, very small scale for Seasonal
plot(decompose(tsSM2_070809Adjusted))

## Holt Winters Exponential Smoothing & Plot
tsSM2_HW070809 <- HoltWinters(tsSM2_070809Adjusted, beta=FALSE, gamma=FALSE)
plot(tsSM2_HW070809, ylim = c(0, 25))

## HoltWinters forecast & plot
tsSM2_HW070809foreCasting <- forecast(tsSM2_HW070809, h=25)
plot(tsSM2_HW070809foreCasting, ylim = c(-15, 28), ylab= "Watt-Hours", xlab="Time - Sub-meter 2")

## Forecast HoltWinters with diminished confidence levels
tsSM2_HW070809foreCastingC <- forecast(tsSM2_HW070809, h=25, level=c(10,25))
## Plot only the forecasted area
plot(tsSM2_HW070809foreCastingC, ylim = c(-12, 5), ylab= "Watt-Hours", xlab="Time - Sub-meter 2", start(2010))






## Seasonal adjusting sub-meter 1 by subtracting the seasonal component & plot
tsSM1_070809Adjusted <- tsSM1_070809monthly - components070809SM1monthly$seasonal
autoplot(tsSM1_070809Adjusted)

## Test Seasonal Adjustment by running Decompose again. Note the very, very small scale for Seasonal
plot(decompose(tsSM1_070809Adjusted))

## Holt Winters Exponential Smoothing & Plot
tsSM1_HW070809 <- HoltWinters(tsSM1_070809Adjusted, beta=FALSE, gamma=FALSE)
plot(tsSM1_HW070809, ylim = c(-35, 45))

## HoltWinters forecast & plot
tsSM1_HW070809foreCasting <- forecast(tsSM1_HW070809, h=25)
plot(tsSM1_HW070809foreCasting, ylim = c(-60, 70), ylab= "Watt-Hours", xlab="Time - Sub-meter 1")

## Forecast HoltWinters with diminished confidence levels
tsSM1_HW070809foreCastingC <- forecast(tsSM1_HW070809, h=25, level=c(10,25))
## Plot only the forecasted area
plot(tsSM1_HW070809foreCastingC, ylim = c(-7, 13), ylab= "Watt-Hours", xlab="Time - Sub-meter 1", start(2010))
