---
title: "SMU-MSDS-6306-HW5 Data Munging/Merging of Baby Names"
author: "Luay Dajani"
date: "February 20, 2018"
output: 
  html_document:
        keep_md: true
---



## Data Munging/Merging of Baby Names

Attempt for HW5, GITHUB repo <https://github.com/LuayD/SMU-MSDS/tree/master/SMU-MSDS-6306-HW5>.

## Question 1: import data and tidy

### Q1a: read table into df & Assign Column Names


```r
# read table from file
df <- read.table("data/yob2016.txt"
                , sep = ';'
                , col.names = c("first_name", "gender", "total_2016") #set names
                , as.is = TRUE #do not set character to factor
                 )
```

### Q1b: Display summary & structure of df


```r
# Summary
summary(df)
```

```
##   first_name           gender            total_2016     
##  Length:32869       Length:32869       Min.   :    5.0  
##  Class :character   Class :character   1st Qu.:    7.0  
##  Mode  :character   Mode  :character   Median :   12.0  
##                                        Mean   :  110.7  
##                                        3rd Qu.:   30.0  
##                                        Max.   :19414.0
```

```r
# Structure
str(df)
```

```
## 'data.frame':	32869 obs. of  3 variables:
##  $ first_name: chr  "Emma" "Olivia" "Ava" "Sophia" ...
##  $ gender    : chr  "F" "F" "F" "F" ...
##  $ total_2016: int  19414 19246 16237 16070 14722 14366 13030 11699 10926 10733 ...
```

### Q1c: Find extraneaous name (3 yyy at end) within df and remove


```r
# convert into vector to find position
vec <- df[,"first_name"]

# create vector of ints to find which observations has the pattern returns vector of -1 (for not found)
found_observation <- regexpr("yyy", vec)

# used to affix column numbers to the found observation var and then combined into a dataframe
ordinal_vector <- 1:length(found_observation)
df2 <- data.frame(ordinal_vector, found_observation)

# extract the position of the found item
found <- df2[df2$found_observation != -1,1]
```

### Q1d: Remove extraneaous name (3 yyy at end) within df


```r
# take out the observation that was found
y2016 <- df[-found,]

# order dataframe
y2016 <- y2016[order(y2016$first_name, y2016$gender),]
```

## Question 2: Merge Data

### Q2a: read table into df & Assign Column Names


```r
# Read the table from table file
y2015 <- read.table("data/yob2015.txt"
                 , sep = ','
                 , col.names = c("first_name", "gender", "total_2015") #set names
                 , as.is = TRUE #do not set character to factor
                 #                 , colClasses = c("character", "factor", "integer") #set column classes
)

# Sort by first name then gender
y2015 <- y2015[order(y2015$first_name, y2015$gender),]
```

### Q2b: Display last 10 rows, print something interesting


```r
#show the tail & 10 rows & print
tail(y2015, 10)
```

```
##       first_name gender total_2015
## 27770      Zyren      M          9
## 16366      Zyria      F          6
## 5105      Zyriah      F         27
## 16367     Zyriel      F          6
## 19054   Zyrielle      F          5
## 29668     Zyrion      M          7
## 25031      Zyron      M         15
## 33062      Zyrus      M          5
## 33063       Zyus      M          5
## 31100      Zyvon      M          6
```

```r
cat("Interesting Observation: All these ending rows are Male and only have 5 children respectivley named\n")
```

```
## Interesting Observation: All these ending rows are Male and only have 5 children respectivley named
```

### Q2c: Merge the y2015 & y2016


```r
#merge data frames together
final <- merge(y2015
               , y2016
               , by = c("first_name","gender")
               , sort = TRUE
               , all = FALSE
)
```

## Question 3: Data Summary:

### Q3a: Add Total with total amount of children of 2015 & 2016


```r
#add total to new column
final$total <- (final$total_2015 + final$total_2016)
```

### Q3b: Sort the dataframe by TOTAL and show top 10 baby names for the 2 years


```r
# sort total desc
final <- final[order(-final$total),]

# show top 10 
head(final, n = 10)
```

```
##       first_name gender total_2015 total_2016 total
## 8290        Emma      F      20415      19414 39829
## 19886     Olivia      F      19638      19246 38884
## 19594       Noah      M      19594      19015 38609
## 16114       Liam      M      18330      18138 36468
## 23273     Sophia      F      17381      16070 33451
## 3252         Ava      F      16340      16237 32577
## 17715      Mason      M      16591      15192 31783
## 25241    William      M      15863      15668 31531
## 10993      Jacob      M      15914      14416 30330
## 10682   Isabella      F      15574      14722 30296
```

### Q3c: show top 10 girl's names (omit boys)


```r
# Variable with first 10 rows of female only
top_10_F <- final[final$gender=="F",][1:10,]

# display Variable
top_10_F
```

```
##       first_name gender total_2015 total_2016 total
## 8290        Emma      F      20415      19414 39829
## 19886     Olivia      F      19638      19246 38884
## 23273     Sophia      F      17381      16070 33451
## 3252         Ava      F      16340      16237 32577
## 10682   Isabella      F      15574      14722 30296
## 18247        Mia      F      14871      14366 29237
## 5493   Charlotte      F      11381      13030 24411
## 277      Abigail      F      12371      11699 24070
## 8273       Emily      F      11766      10926 22692
## 9980      Harper      F      10283      10733 21016
```

### Q3d: write top 10 female names with name & total (no others) columns to a csv file


```r
# Variable with only first name and total columns from top 10 female names
top_10_new <- top_10_F[,c("first_name","total")]

# reset row name number
rownames(top_10_new) <- NULL

# write variable to file
write.csv(top_10_new, file = "data/top_10_f.csv")
```
