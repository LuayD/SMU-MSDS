### Practice in R

#Live Session 12 demo
install.packages("dygraphs")
library("dygraphs")

install.packages("forecast")
library("forecast")

#read, convert and display births timeseries dataset
births <- scan("http://robjhyndman.com/tsdldata/data/nybirths.dat") 
births <- ts(births, frequency = 12, start = c(1946, 1))  #frequency =12 because its a monthly dataset, 1=yearly, 4=quarterly
births
class(births)

#read, convert and display gift shop dataset
gift <- scan("http://robjhyndman.com/tsdldata/data/fancy.dat")
gift<- ts(gift, frequency=12, start=c(1987,1))
gift 

#plot births and gift timeseries - both have seasonal components 
plot(births)  #additive or multiplicative?
plot(gift)    #additive or multiplicative?
abline(v=1992, col="red")


#decompose seasonal data
birthsComp <- decompose(births, type="add")
plot(birthsComp)

giftComp <- decompose(gift, type="mult")
plot(giftComp)

#HoltWinters filtering on births
birthsHW <- HoltWinters(births)
birthsHW
plot(birthsHW)

#forecast for next 48 months
#start from 1952
#blue line: actual prediction, dark gray: 80% confidence interval, light gray: 95% confidence interval
birthsSubset<-window(births, start=1952)
birthsF5 <- hw(birthsSubset, initial="optimal", h=48)
plot(birthsF5)
lines(fitted(birthsF5), col="red")

#dygraphs
dygraph(birthsSubset, main="Birth rates", ylab="Births", xlab="Year") %>% 
  dyRangeSelector(height=100) %>%
  dyShading(from = "1955-1-1", to = "1956-1-1", color = "#FFE6E6") %>%
  dyShading(from = "1959-1-1", to = "1960-1-1", color = "#CCEBD6")

## a.	Using the maxtemp dataset granted by loading fpp2, there are maximum annual temperature data in Celsius.  For more information, use help(maxtemp).  To see what you’re looking at, execute the command in ‘Examples’ in the help document.
## b.	We are only concerned with information after 1990.  Please eliminate unwanted information or subset information we care about.
## c.	Utilize SES to predict the next five years of maximum temperatures in Melbourne.  Plot this information, including the prior information and the forecast.  Add the predicted value line across 1990 present as a separate line, preferably blue.  So, to review, you should have your fit, the predicted value line overlaying it, and a forecast through 2021, all on one axis. Find the AICc of this fitted model.  You will use that information later.
## d.	Now use a damped Holt’s linear trend to also predict out five years.  Make sure initial=“optimal.”  As above, create a similar plot to 1C, but use the Holt fit instead.
## e.	Compare the AICc of the ses() and holt() models.  Which model is better here?
  
#In this exercise, we will use Temperature data
install.packages("fpp2")
install.packages("fma")
library("fpp2")
library("dygraphs")
library("xts")
maxtemp
autoplot(maxtemp, xlab="Year", ylab="Temperature (Celsius)")
ts<-window(maxtemp, start=1990)
ts
# Use SES
fit<-ses(ts, h=5)
fit
# Comparing Forecast Fit
plot(fit,ylab="Temperature, Celsius", xlab= "Year", main="Comparing forecast fit")
lines(fitted(fit), col="blue")
lines(fit$mean, col="blue", type="o")

# Finding AICc
fit$model

# Use Holt Fit and damped
holtfit<- holt(ts, initial="optimal", h=5, damped = TRUE)
holtfit

plot(holtfit, ylab="Temperature, Celsius", xlab= "Year", main="Comparing forecast fit")
lines(fitted(holtfit), col="blue", type="o")
lines(holtfit$mean, col="red", lwd = 2)

# Finding AICc
holtfit$model
