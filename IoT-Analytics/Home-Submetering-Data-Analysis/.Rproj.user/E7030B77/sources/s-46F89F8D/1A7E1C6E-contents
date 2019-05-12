
#Install and load the "dplyr" package.
#install.packages("dplyr")
#Install and load the "RMySQL" package.
#install.packages("RMySQL")
#Install and load the "lubridate" package.
#install.packages("lubridate")

library(RMySQL)
library(dplyr)
library(lubridate)

## Create a database connection
con = dbConnect(MySQL(), user='deepAnalytics', password='Sqltask1234!', dbname='dataanalytics2018', host='data-analytics-2018.cbrosir2cswx.us-east-1.rds.amazonaws.com')

## List the tables contained in the database
dbListTables(con)

## Lists attributes contained in a table
dbListFields(con,'iris')

## Use asterisk to specify all attributes for download
irisALL <- dbGetQuery(con, "SELECT * FROM iris")

## Use attribute names to specify specific attributes for download
irisSELECT <- dbGetQuery(con, "SELECT SepalLengthCm, SepalWidthCm FROM iris")

### Reference data is in the following tables: yr_2006, yr_2007, yr_2008, yr_2009, yr_2010

#yr_2006
## Lists attributes contained in table yr_2006
dbListFields(con,'yr_2006')

## Get all attributes for yr_2006
yr_2006ALL <- dbGetQuery(con, "SELECT * FROM yr_2006")

#Investigating data frame
# display the "head"  of the dataset, "yr_2006ALL".
head(yr_2006ALL)
# display the " "tail" of the dataset, "yr_2006ALL".
tail(yr_2006ALL)
#Display the summary statistics of dataset, "yr_2006ALL".
summary(yr_2006ALL)
#Display the names found in dataset, "yr_2006ALL".
names(yr_2006ALL)
#Display the structure of dataset, "yr_2006ALL".
str(yr_2006ALL)


#yr_2007
## Use attribute names to specify specific attributes for yr_2006
yr_2006SELECT <- dbGetQuery(con, "SELECT Global_active_power, Global_reactive_power, Global_intensity FROM yr_2006")

## Lists attributes contained in table yr_2007
dbListFields(con,'yr_2007')

## Get all attributes for yr_2007
yr_2007ALL <- dbGetQuery(con, "SELECT * FROM yr_2007")

## Use attribute names to specify specific attributes for yr_2007
yr_2007SELECT <- dbGetQuery(con, "SELECT Global_active_power, Global_reactive_power, Global_intensity FROM yr_2007")

#Investigating data frame
# display the "head"  of the dataset, "yr_2007ALL".
head(yr_2007ALL)
# display the " "tail" of the dataset, "yr_2007ALL".
tail(yr_2007ALL)
#Display the summary statistics of dataset, "yr_2007ALL".
summary(yr_2007ALL)
#Display the names found in dataset, "yr_2007ALL".
names(yr_2007ALL)
#Display the structure of dataset, "yr_2007ALL".
str(yr_2007ALL)

#yr_2008
## Lists attributes contained in table yr_2008
dbListFields(con,'yr_2008')

## Get all attributes for yr_2008
yr_2008ALL <- dbGetQuery(con, "SELECT * FROM yr_2008")

## Use attribute names to specify specific attributes for yr_2008
yr_2008SELECT <- dbGetQuery(con, "SELECT Global_active_power, Global_reactive_power, Global_intensity FROM yr_2008")

#Investigating data frame
# display the "head"  of the dataset, "yr_2008ALL".
head(yr_2008ALL)
# display the " "tail" of the dataset, "yr_2008ALL".
tail(yr_2008ALL)
#Display the summary statistics of dataset, "yr_2008ALL".
summary(yr_2008ALL)
#Display the names found in dataset, "yr_2008ALL".
names(yr_2008ALL)
#Display the structure of dataset, "yr_2008ALL".
str(yr_2008ALL)


#yr_2009
## Lists attributes contained in table yr_2009
dbListFields(con,'yr_2009')

## Get all attributes for yr_2009
yr_2009ALL <- dbGetQuery(con, "SELECT * FROM yr_2009")

## Use attribute names to specify specific attributes for yr_2009
yr_2009SELECT <- dbGetQuery(con, "SELECT Global_active_power, Global_reactive_power, Global_intensity FROM yr_2009")

#Investigating data frame
# display the "head"  of the dataset, "yr_2009ALL".
head(yr_2009ALL)
# display the " "tail" of the dataset, "yr_2009ALL".
tail(yr_2009ALL)
#Display the summary statistics of dataset, "yr_2009ALL".
summary(yr_2009ALL)
#Display the names found in dataset, "yr_2009ALL".
names(yr_2009ALL)
#Display the structure of dataset, "yr_2009ALL".
str(yr_2009ALL)

#yr_2010
## Lists attributes contained in table yr_2010
dbListFields(con,'yr_2010')

## Get all attributes for yr_2010
yr_2010ALL <- dbGetQuery(con, "SELECT * FROM yr_2010")

## Use attribute names to specify specific attributes for yr_2010
yr_2010SELECT <- dbGetQuery(con, "SELECT Global_active_power, Global_reactive_power, Global_intensity FROM yr_2010")

#Investigating data frame
# display the "head"  of the dataset, "yr_2010ALL".
head(yr_2010ALL)
# display the " "tail" of the dataset, "yr_2010ALL".
tail(yr_2010ALL)
#Display the summary statistics of dataset, "yr_2010ALL".
summary(yr_2010ALL)
#Display the names found in dataset, "yr_2010ALL".
names(yr_2010ALL)
#Display the structure of dataset, "yr_2010ALL".
str(yr_2010ALL)



#Create Primary Data Frame
## Combine tables into one dataframe using dplyr
newDF <- bind_rows(yr_2006ALL, yr_2007ALL, yr_2008ALL, yr_2009ALL, yr_2010ALL)

#Investigating data frame
# display the "head"  of the dataset, "newDF".
head(newDF)
# display the " "tail" of the dataset, "newDF".
tail(newDF)
#Display the summary statistics of dataset, "newDF".
summary(newDF)
#Display the names found in dataset, "newDF".
names(newDF)
#Display the structure of dataset, "newDF".
str(newDF)


## Combine Date and Time attribute values in a new attribute column
combineddataframe <-cbind(newDF,paste(newDF$Date,newDF$Time), stringsAsFactors=FALSE)

## Give the new attribute in the 6th column a header name
## NOTE: if you downloaded more than 5 attributes you will need to change the column number)
colnames(combineddataframe)[11] <-"DateTime"

head(combineddataframe)

## Move the DateTime attribute within the dataset
newcombineddataframe <- combineddataframe[,c(ncol(combineddataframe), 1:(ncol(combineddataframe)-1))]
head(newcombineddataframe)

## Convert DateTime from character to POSIXct 
newcombineddataframe$DateTime <- as.POSIXct(newcombineddataframe$DateTime, "%Y/%m/%d %H:%M:%S")


## Add the time zone
attr(newcombineddataframe$DateTime, "tzone") <- "USA/CST"

## Inspect the data types
str(newcombineddataframe)

# preprocessing of data using Lubridate to make working with DateTime much easier

## Create "year" attribute with lubridate
newcombineddataframe$year <- year(newcombineddataframe$DateTime)

## Create "month" attribute with lubridate
newcombineddataframe$month <- month(newcombineddataframe$DateTime)

## Create "day" attribute with lubridate
newcombineddataframe$day <- day(newcombineddataframe$DateTime)

# Create the mode function.
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

#summary statistics

attributes(newcombineddataframe) #List your attributes within your data set.
getmode(newcombineddataframe$Sub_metering_1) #Prints the mode
getmode(newcombineddataframe$Sub_metering_2) #Prints the mode
getmode(newcombineddataframe$Sub_metering_3) #Prints the mode
summary(newcombineddataframe) #Prints the min, max, mean, median, and quartiles of each attribute.
str(newcombineddataframe) #Displays the structure of your data set.
names(newcombineddataframe) #Names your attributes within your data set.

