## HW5 Data Munging/Merging of Baby Names
## Luay Dajani
## MSDS 6306 201802

## Question 1: import data and tidy

### Q1a: read table into df & Assign Column Names
df <- read.table("data/yob2016.txt"
                 , sep = ';'
                 , col.names = c("first_name", "gender", "total_2016") #set names
                , as.is = TRUE #do not set character to factor
#                 , colClasses = c("character", "factor", "integer") #set column classes
                 )

### Q1b: Display summary & structure of df

#Summary
summary(df)
#Structure
str(df)

### Q1c: Find extraneaous name (3 yyy at end) within df and remove

#convert into vector to find position
vec <- df[,"first_name"]

#show the found item/s
xyz <- grep("yyy"
     , vec
     , value = TRUE
#     , ignore.case = TRUE
     )

# create vector of ints to find which observations has the pattern
found_observation <- regexpr("yyy", vec)

# used to affix column numbers to the found observation var and then combined into a dataframe
ordinal_vector <- 1:length(found_observation)
df2 <- data.frame(ordinal_vector, found_observation)

# extract the position of the found item
found <- df2[df2$found_observation != -1,1]

strings <- c("a", "ab", "acb", "accb", "acccb", "accccb")
grep("b", strings, value = TRUE)

### Q1d: Remove extraneaous name (3 yyy at end) within df

#take out the observation that was found
y2016 <- df[-found,]
y2016 <- y2016[order(y2016$first_name, y2016$gender),]
vec <- df[,"first_name"]

#show the found item/s if still there
zyx <- grep("yyy"
            , vec
            , value = TRUE
            #     , ignore.case = TRUE
)

## Question 2: Merge Data

### Q2a: read table into df & Assign Column Names
y2015 <- read.table("yob2015.txt"
                 , sep = ','
                 , col.names = c("first_name", "gender", "total_2015") #set names
                 , as.is = TRUE #do not set character to factor
                 #                 , colClasses = c("character", "factor", "integer") #set column classes
)

# Sort by first name then gender
y2015 <- y2015[order(y2015$first_name, y2015$gender),]

### Q2b: Display last 10 rows, print something interesting
tail(y2015, 10)
cat("Interesting Observation: All these ending rows are Male and only have 5 children respectivley named\n")

### Q2c: Merge the y2015 & y2016
final <- merge(y2015
               , y2016
               , by = c("first_name","gender")
               , sort = TRUE
               , all = FALSE
)

## Question 3: Data Summary:

### Q3a: Add Total with total amount of children of 2015 & 2016
final$total <- (final$total_2015 + final$total_2016)

### Q3b: Sort the dataframe by TOTAL and show top 10 baby names for the 2 years

# sort total desc
final <- final[order(-final$total),]

# show top 10 
head(final, n = 10)

### Q3c: show top 10 girl's names (omit boys)
top_10_F <- final[final$gender=="F",][1:10,]
top_10_F

### Q3d: write top 10 female names with name & total (no others) columns to a csv file
top_10_new <- top_10_F[,c("first_name","total")]
rownames(top_10_new) <- NULL
write.csv(top_10_new, file = "top_10_f.csv")

# sorting examples using the mtcars dataset
attach(mtcars)
# sort by mpg
newdata <- mtcars[order(mpg),] 
# sort by mpg and cyl
newdata <- mtcars[order(mpg, cyl),]
#sort by mpg (ascending) and cyl (descending)
newdata <- mtcars[order(mpg, -cyl),] 
detach(mtcars)
