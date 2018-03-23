#####
## Exploring Mental Health
## SMU MSDS 6306 Analysis Assignment 10 201803 
#####

# Install Libraries
# install.packages("plyr")
# install.packages("ggplot2")


# VA Mental Health Clinics Anlysis

## Part 1: Mental Health Clinics (Number Per State)

### Analysis 1a: Load in environment data with SAMHDA

# Load in RDA file
str_RData_file <- "data/N-MHSS-2015-DS0001-data/N-MHSS-2015-DS0001-data-r.rda"
load(str_RData_file)

# Load in attributes fron column names for descriptive text
lst_data_attributes <- attr(mh2015_puf, "variable.labels")

### Analysis 1b: List the state abreviations represented in the data

library(plyr)
# Do a 2 de-reference to get the count in a DF then get the x column, then cast factor to character then dlee spaces
# taking out spaces from *ref1
vec_state_abbrev <- gsub(" ", "", as.character(count(mh2015_puf$LST)$x))
vec_state_abbrev

### Analysis 1c: Include listings of only states & DC (exclude offland terriories) from initial DF

# offland territories *ref2
vec_territory_abbrev <- c("AS", "FM", "GU", "MH", "MP", "PW", "PR", "VI")

# create count of states using filter deriving mainland states vector and number of centers, 
# just find where the element does not match the filter of not wanted territories and use count *ref#3
dfm_VA_per_state <- count(mh2015_puf[!is.element(gsub(" ", "", as.character(mh2015_puf$LST)), vec_territory_abbrev),]$LST)
#change the colnames to something readable
colnames(dfm_VA_per_state) <- c("state", "number_va_hopitals")
#add column with orinal numbers to randomly color bars in subsequent plot
dfm_VA_per_state["color_code"] <- 1:length(dfm_VA_per_state$state)

### Analysis 1d: ggplot barchart of filtered dataset
library(ggplot2)
library(plyr)

# plot using bar and reordering so A-Z state abbrevs first *ref#4, also played with geor_bar colors *ref#5,
# also not showing legend *ref#6
ggplot(dfm_VA_per_state, aes(reorder(state, desc(state)), number_va_hopitals)) +
  geom_bar(stat="identity", aes(fill=color_code), width = .8, show.legend = FALSE) +
  coord_flip() + #flip graph
  ggtitle("Number of VA Hospitals per State" ,
          subtitle = "Including US States and DC, not off mainland territorries") +
  xlab("States") +
  ylab("Number of Hospitals") +
  scale_fill_gradient(low="blue", high="red") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5),
        axis.text.y = element_text(size = 5)
        )

## Part 2: Cleaning Data and Introducing new features

### Analysis 2a: Load in state information data and see issues with merging

# read in file data
str_state_data_file <- "data/statesize.csv"
dfm_state_data <- read.csv(str_state_data_file, stringsAsFactors = FALSE)
dfm_merged_VA_state_data <-  merge(x = dfm_VA_per_state, y = dfm_state_data, by.x = "state", by.y = "Abbrev")
# The abbreiations do not match as either one is a Factor or has etraneous spaces.  Will clean that out and concert to string
# show current merged state (empty)
head(dfm_merged_VA_state_data, 10)
# show structure
str(dfm_VA_per_state)

### Analysis 2b: Fix issue and merge

# use gsub function to delete spaces and change to string (character)
dfm_VA_per_state$state <- gsub(" ", "", as.character(dfm_VA_per_state$state))
# re-show structure
str(dfm_VA_per_state)
#re-merge
dfm_merged_VA_state_data <-  merge(x = dfm_VA_per_state, y = dfm_state_data, by.x = "state", by.y = "Abbrev")
# re-show current merged state
head(dfm_merged_VA_state_data, 10)

### Analysis 2c: Calculate VA hospitals per square mile

# Add new variable (column) to the merged data frame showing the VA calculated hospitals per sq mile
dfm_merged_VA_state_data$HospitalsPerKSqMile <- dfm_merged_VA_state_data$number_va_hopitals / (dfm_merged_VA_state_data$SqMiles / 1000)
head(dfm_merged_VA_state_data, 10)

### Analysis 2d: Plot VAs per square 1000 miles 

# Copy plot info from 1d, reorder the bars to show by descending order from top and fil per region
ggplot(dfm_merged_VA_state_data, aes(reorder(state, HospitalsPerKSqMile), HospitalsPerKSqMile)) +
  geom_bar(stat="identity", aes(fill=Region), width = .8, show.legend = TRUE) +
  coord_flip() + #flip graph
  ggtitle("Number of VA Hospitals Per Thousand Square Miles per State" ,
          subtitle = "Including US States and DC, not off mainland territorries") +
  xlab("States") +
  ylab("Number of Hospitals Per Thousand Square Miles") +
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5),
        axis.text.y = element_text(size = 5)
  )

### Analysis 2e: Analyse: patters, region distribution, Advice given


# 1: Remove spaces from text https://stackoverflow.com/questions/5992082/how-to-remove-all-whitespace-from-a-string
# 2: US state & territory abbreviations: http://www.stateabbreviations.us/
# 3: Remove a particular group of elements in a vector? https://stackoverflow.com/questions/11672227/remove-a-particular-group-of-elements-in-a-vector
# 4: r - reverse order of discrete y axis in ggplot2 https://stackoverflow.com/questions/28391850/r-reverse-order-of-discrete-y-axis-in-ggplot2
# 5: Fill gradient color not working with geom_bar of ggplot2 https://stackoverflow.com/questions/37343114/fill-gradient-color-not-working-with-geom-bar-of-ggplot2
# 6: removing legend ggplot 2.2: https://stackoverflow.com/questions/35618260/removing-legend-ggplot-2-2
