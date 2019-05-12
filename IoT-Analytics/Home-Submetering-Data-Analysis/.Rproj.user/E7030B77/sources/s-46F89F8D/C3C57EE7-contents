#Install and load the "chron" package.
#install.packages("chron")

library("chron")

                 
#as.Date function allows a variety of input formats 
as.Date('2019-4-30')
as.Date('2019/04/30')

#If input dates are not in the standard format, a format string can be composed using format elements 
as.Date('5/1/2019',format='%m/%d/%Y')
as.Date('April 26, 2019',format='%B %d, %Y')
as.Date('22JUN19',format='%d%b%y')   # %y is system-specific; use with caution


bdays = c(mukundh=as.Date('1985-08-28'),subavarshini=as.Date('1992-10-12'), mythiligovindan=as.Date('1962-02-21'), govindan=as.Date('1952-09-27'), srikanthgovindan=as.Date('1988-06-05') )

weekdays(bdays)

dtimes = c("2002-06-09 12:45:40","2003-01-29 09:30:40","2002-09-04 16:45:40","2002-11-13 20:00:40", "2002-07-07 17:30:40")

dtparts = t(as.data.frame(strsplit(dtimes,' ')))

row.names(dtparts) = NULL
thetimes = chron(dates=dtparts[,1],times=dtparts[,2], format=c('y-m-d','h:m:s'))
thetimes

dts = c("2005-10-21 18:47:22","2005-12-24 16:39:58", "2005-10-28 07:30:05 PDT")

as.POSIXlt(dts)

dtstimestamp = c(1127056501,1104295502,1129233601,1113547501,1119826801,1132519502,1125298801,1113289201)
mydates = dtstimestamp

class(mydates) = c('POSIXt','POSIXct')
mydates

mydates = structure(dts,class=c('POSIXt','POSIXct'))
mydate = strptime('16/Oct/2005:07:51:00',format='%d/%b/%Y:%H:%M:%S')

#Doing away with “unknown timezone” warnings
Sys.setenv(TZ="USA/PDT")
Sys.setenv(TZ="USA/CST")
Sys.getenv("TZ")
as.POSIXct(dts, TZ=getOption("TZ"))
# End of Doing away with “unknown timezone” warnings


#Another way to create POSIX dates is to pass the individual components of the time to the ISOdate function
ISOdate(2005,10,21,18,47,22,tz="USA/CST")

thedate = ISOdate(2005,10,21,18,47,22,tz="USA/CST")

#format function will recognize the type of your input date, and perform any necessary conversions before calling strftime, so strftime rarely needs to be called directly.
format(thedate,'%A, %B %d, %Y %H:%M:%S')

#individual components of a POSIX date/time object can be extracted by first converting to POSIXlt if necessary

mydate = as.POSIXlt('2005-4-19 7:01:00')
names(mydate)

mydate$mday

# statistical summary functions, like mean, min, max, etc are able to transparently handle date objects 
rdates = scan(what="") 

rdates = as.data.frame(matrix(rdates,ncol=2,byrow=TRUE))

dates[,2] = as.Date(rdates[,2],format='%d%b%Y')
names(rdates) = c("Release","Date")
rdates