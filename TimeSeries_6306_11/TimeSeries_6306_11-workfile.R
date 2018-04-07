## Libraries
# install.packages("dygraphs")
if("dygraphs" %in% rownames(installed.packages()) == FALSE) {install.packages("dygraphs")}
library("dygraphs")

# install.packages("forecast")
if("forecast" %in% rownames(installed.packages()) == FALSE) {install.packages("forecast")}
library("forecast")

# install.packages("fpp2")
if("fpp2" %in% rownames(installed.packages()) == FALSE) {install.packages("fpp2")}
library("fpp2")

# install.packages("xts")
if("xts" %in% rownames(installed.packages()) == FALSE) {install.packages("xts")}
library("xts")

## Analysis 1: Warm-up Bried Financial Data from EU Stock Markets

## Part 1a. Pull data from EU Stock Markets 1991 - 1998

# Take just the "DAX" data from the data
ts_EuStockMarketsDax <- EuStockMarkets[,1]
names(ts_EuStockMarketsDax) <- "DAX"

## Part 1b. Plot with bluw line and make red vert line on 1997
plot(ts_EuStockMarketsDax,
     main = "EU Stock Market DAX index 1991 - 1998",
     ylab = "DAX index",
     xlab = "Year",
     col = "blue")
abline(v=1997, col="red", lwd = 2)

## Part 1c. decompose data "mult" to get observed, seasonal, trend, & random noise, same colors as before
lst_decomp_EuStockMarketsDax <- decompose(ts_EuStockMarketsDax, type="mult")
plot(lst_decomp_EuStockMarketsDax, 
    xlab = "Year",
    col = "blue",
    las = 1,         # make Categorylabel text perpendicular to axis & plot
    mar = c(0,9,1,3) # increase y-axis margin (c(bottom, left, top, right))
)
abline(v=1997, col="red", lwd = 2)

## Analysis 2: Temperature Data Predicitons for Moorabbin Airport Melbourne

## Part 2a. Pull data from fpp2 lib and plot

# assign to local var to visually explore
ts_maxtemp <- maxtemp

# Autoplot maxtemp data using example as per help page
autoplot(ts_maxtemp, main = "Max Temperate for Moorabbin Airport Melbourne",
         xlab = "Time Period", ylab = "Temperature (Celcius")

## Part 2b. subset data after year 1990
ts_maxtemp_1990 <- window(ts_maxtemp, start = 1990)

## Part 2c. Predict next 5 years of temperatures

#Get predicted meand part 5 years
lst_maxtemp_ses_1990_2021 <- ses(ts_maxtemp_1990, h = 5)

# plot observed & 5 years predicted with confidence intervals of 80% and 95%
plot(lst_maxtemp_ses_1990_2021, 
     main = "Moorabbin Airport 1990-2016 +5 years (SES) forecasted",
     sub = "Black Observed & Blue Fitted (1990-2016) Predicted (2017-2021 w/ 80% & 95% CI)",
     ylab = "Temperature (Celcius)",
     xlab = "Year",
     type = "o"
     )

# find fitted (predicted values lines) from 1990 - 2016 (NOT THE 5 YEARS PREDICTED) & add line to plot
lines(fitted(lst_maxtemp_ses_1990_2021), col = "blue", type = "o")

# overlay 2016-2021 predictions with points
lines(lst_maxtemp_ses_1990_2021$mean, col = "blue", type = 'o')

## Part 2d. Use Damped Holt's Linear Trend
lst_maxtemp_holt_1990_2021 <- holt(ts_maxtemp_1990, h = 5, damped = TRUE)

# plot observed & 5 years predicted with confidence intervals of 80% and 95%
plot(lst_maxtemp_holt_1990_2021, 
     main = "Moorabbin Airport 1990-2016 +5 years (Holt) forecasted",
     sub = "Black Observed & Blue Fitted (1990-2016) Predicted (2017-2021 w/ 80% & 95% CI)",
     ylab = "Temperature (Celcius)",
     xlab = "Year"
)

# find fitted (predicted values lines) from 1990 - 2016 (NOT THE 5 YEARS PREDICTED) & add line to plot
lines(fitted(lst_maxtemp_holt_1990_2021), col = "blue", type = 'o')

# overlay 2016-2021 predictions with points
lines(lst_maxtemp_holt_1990_2021$mean, col = "blue", type = 'o')

# AICc comparion for models
cat("AICs for SES model", lst_maxtemp_ses_1990_2021$model$aicc, "\n")
cat("AICs for HW model", lst_maxtemp_holt_1990_2021$model$aicc, "\n")
cat("The SES model has the lower AICc", "\n")

## Analysis 3: Wands that choose the wizard

## Part 3a.Read in both datasets, files do not have headers
dfm_ollivander <- read.csv("data/Unit11TimeSeries_Ollivander.csv", header = FALSE, stringsAsFactors = FALSE)
dfm_gregorovitch <- read.csv("data/Unit11TimeSeries_gregorovitch.csv", header = FALSE, stringsAsFactors = FALSE)

# Add headers
colnames(dfm_ollivander) <- c("year", "ollivander")
colnames(dfm_gregorovitch) <- c("year", "gregorovitch")

## Part 3b. Convert aquired Date into correct date format
dfm_ollivander["newdate"] = as.Date(dfm_ollivander$year, "%m/%d/%Y")
dfm_gregorovitch["newdate"] = as.Date(dfm_ollivander$year, "%m/%d/%Y")

# Combine (Merge) data frames
dfm_combined <- merge(dfm_ollivander[c("newdate","ollivander")], 
                                     dfm_gregorovitch[c("newdate","gregorovitch")], 
                                     by = "newdate", all=TRUE)

## Part 3c. Convert data frames to time series and plot using dygraphs
ts_combined <- xts(dfm_combined[c("ollivander","gregorovitch")], 
                   order.by = dfm_gregorovitch$newdate)


# plot the dygrpah
dygraph(ts_combined, main="Wands Sold per Wand Maker", ylab="Wands Sold", 
        xlab="Year (Shaded Area When He who should not be named active)") %>%
  dySeries("ollivander", label = "Ollivander", color = "green") %>%
  dySeries("gregorovitch", label = "Gregorovitch", color = "red") %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyRangeSelector(height=30) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyShading(from = "1995-1-1", to = "1999-1-1", color = "#55CCDD")
  
  