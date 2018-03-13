######
## Unit 9 Assignment
## Parse HTML Pages:
## http://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1
## http://www.espn.com/nba/team/stats/_/name/sa/san-antonio-spurs
######

#clean the environment variables
rm(list=ls())
# install.packages("rvest")
# install.packages("bindr")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("ggplot2")

library("rvest")   # Great for grabbing and parsing HTML
library("bindr")   # support for dplyr
library("dplyr")   # Easy transformation of data.frames for summarization
library("tidyr")   # Nice way to arrange data
library("ggplot2") # Excellent for visuals

## Analysis 1: Harry potter cast from IMDB Site

## Q1a: Download IMDB information

# Download page and load
url_hp <- "http://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1"
webpage_hp <- read_html(url_hp)

## Q1b: "Scrape" table into data frame

# Identifying HTML nodes where <table>
table_nodes_hp<-html_nodes(webpage_hp, 'table')

# Convert to HTML tables
tables_hp<-html_table(table_nodes_hp)

# Take the 3rd HTML table where the cast list is
castlist_dfm <- tables_hp[[3]]

## Q1c: Clean dataframe

# take out observations with "info" taken out
clean_dfm <- castlist_dfm[(castlist_dfm$X1 != "Rest of cast listed alphabetically:"),]

# take out top blank observation
clean_dfm <- clean_dfm[-(clean_dfm$X2 == ""),]

# utilize only columns with names and characters and disregard rest and name
clean_dfm <- clean_dfm[c(2,4)]
colnames(clean_dfm) <- c("Actor", "Character")

# reset row names/numbers to start at 1
rownames(clean_dfm) <- NULL

# Find observation with Mr. Warwick Davis and 
clean_dfm[(clean_dfm$Actor == "Warwick Davis"),]

# get rid of all \n and extraneous spaces *ref#1 from all observations
clean_dfm$Character <- gsub("\\n | ^ *|(?<= ) | *$", "", clean_dfm$Character, perl = TRUE)

## Q1d: Separate name into 1st & 2nd names

#separatescommand, not working well
#test <- separate(clean_dfm["Actor"], Actor, into = c("FirstName", "Surname"), sep=" [^ ]*$ | .* ")

# pull out the first and middle parts of the name *ref#2
first_midname_vec <- gsub(" [^ ]*$", "", clean_dfm$Actor)

# pull out the last part of the name
lastname_vec <- gsub(".* ", "", clean_dfm$Actor)

# put it together in final display dfm
final_castlist_dfm = data.frame(first_midname_vec, lastname_vec, clean_dfm$Character)
colnames(final_castlist_dfm)<- c("FirstName", "Surname", "Character")

## Q1e: Print first 10 rows of the dataframe

# Print results
head(final_castlist_dfm, 10)

# Walking through the regular expression syntax
## [ ] - match a single character present in the set: here I chose a space.
## (?= ) - positive lookahead
## [^ ] - match a single character NOT present in the set: here I chose not a space
## * - matches between 0 and unlimited times, as many as possible
## $ - asserts position at the end of the line

## Analysis 2: ESPN San Antonio Spurs Stats

## Q2a: Download ESPN San Antonio Spurs information **Shooting Statistics**

# Download page and load
url_espn <- "http://www.espn.com/nba/team/stats/_/name/sa/san-antonio-spurs"
webpage_espn <- read_html(url_espn)

## Q2b: "Scrape" table into data frame

# Identifying HTML nodes where <table>
table_nodes_espn <- html_nodes(webpage_espn, 'table')

# Convert to HTML tables
tables_espn <- html_table(table_nodes_espn)

# Take the 3rd HTML table where the cast list is
init_stats_dfm <- tables_espn[[2]]

## Q2c: clean data frame: -1 obs/player, no blanks, no row of column names, no totals, and numbers converted

# new clean dataframe with out extraneous informtion (1st 2 rows) and another to take out the totals row
stats_dfm <- init_stats_dfm[c(-1, -2),]
stats_dfm <- stats_dfm[stats_dfm[,1] != "Totals",]

# convert numbers from characters where appropriate and return in back to data stats sfm by making a new one
stats_dfm <- data.frame(stats_dfm[,1], sapply(stats_dfm[-1], as.numeric))

# use apply the colums names from the init dfm 2nd row but changing out the % sign with word & reset row nums
newcolumnnames <- gsub(pattern = "%", replacement = "_PERCENTAGE", init_stats_dfm[2,])
colnames(stats_dfm) <- newcolumnnames

#get the player column and split the name and position parts
stats_dfm <- stats_dfm %>% separate(PLAYER, into=c("Name", "Position"), sep=", ")

# Print top 10 results results
head(stats_dfm, 10)

## Q2d: Create a colorful barchart "Field Goal % per game: infromative centererd title, relevant x/y axis names,
## human readable axis w/no overlap, column colors by player position
## orientation flip usign coord_flip() at *ref#3
## sorting the bar chart at *ref#4
## Coloring the bars by category *ref#5

# The plot
ggplot(stats_dfm, aes(reorder(Name, FG_PERCENTAGE), FG_PERCENTAGE)) +
  geom_bar(stat="identity", aes(fill=Position)) +
  coord_flip() +
  ggtitle("San Antonio Spurs Current Roster: FG Percentage by Player" ,
          subtitle = "Starting with Player with best FG Percentage ") +
  ylab("Percentage of FG Made") +
  xlab("Player Name") +
  theme(plot.title = element_text(hjust = 0.5))

######
## References:
### 1- https://stackoverflow.com/questions/25707647/merge-multiple-spaces-to-single-space-remove-trailing-leading-spaces
### 2- https://stackoverflow.com/questions/19959697/split-string-by-final-space-in-r
### 3- Flip ggplot orientation: http://www.sthda.com/english/wiki/ggplot2-rotate-a-graph-reverse-and-flip-the-plot
### 4- Sorting the ggplot bar: 6 down https://stackoverflow.com/questions/5208679/order-bars-in-ggplot2-bar-graph
### 5- coloring ggplot bars by category: http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually
######