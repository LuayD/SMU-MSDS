# Codebook for Case Study 1

### Directories
* *data/* Data Files

### Files
* *SMU-MSDS-6306-HW5-Work.R*: Work file of all code before moved to R Markdown
* *SMU-MSDS-6306-HW5.Rmd*: Final R Markdown file
* *data/yob2015.txt*: data file with comma seperated files
* *data/yob2016.txt*: data file with semi colon seperated files

### Main Variables
* *df* (data.frame): data read in from yob2016:
  * *first_name* (character): Baby name
  * *gender* (factor): 'M' or 'F'
  * *total_2016* (integer): Total count of this tyoe of name from this sample
* *y2016* (data.frame): df data but sorted (asc firstname, asc gender) & Cleaned of extraneous observation
  * *first_name* (character): Baby name
  * *gender* (factor): 'M' or 'F'
  * *total_2016* (integer): Total count of this tyoe of name from this sample
* *y2015* (data.frame): sorted data frin yob2016 (asc firstname, asc gender)
  * *first_name* (character): Baby name
  * *gender* (factor): 'M' or 'F'
  * *total_2015* (integer): Total count of this tyoe of name from this sample
* *final* (data.frame): Merged data from y2015 & y2016 sorted (asc firstname, asc gender)
  * *first_name* (character): Baby name
  * *gender* (factor): 'M' or 'F'
  * *total_2015* (integer): Total count of this tyoe of name from this sample year
  * *total_2016* (integer): Total count of this tyoe of name from this sample year
  * *total* (integer): added column with added values from total_2015 & total_2016
* *top_10_F* (data.frame): Top 10 female names from final
  * *first_name* (character): Baby name
  * *gender* (factor): 'M' or 'F'
  * *total_2015* (integer): Total count of this tyoe of name from this sample year
  * *total_2016* (integer): Total count of this tyoe of name from this sample year
  * *total* (integer): added column with added values from total_2015 & total_2016
 * *top_10_F* (data.frame): Top 10 female names from final
   * *first_name* (character): Baby name
   * *total* (integer): added column with added values from total_2015 & total_2016

