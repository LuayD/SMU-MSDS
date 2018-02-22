# Codebook for Case Study 1

### Directories
* *.* main directory

### Files
* *SMU-MSDS-6306-HW5-Work.R*: Work file of all code before moved to R Markdown
* *SMU-MSDS-6306-HW5.Rmd* FInal R Markdown file
* 


### Main Variables
* *df* (data.frame): :
  * *Brew_ID* (integer vector): ID number unique to the brewery (ranges 1 to 558)
  * *Name* (factor): Name of the brewery
  * *City* (factor): City in which the brewery is located
  * *State* (factor): US State in which the brewery is located
* *beers* (data.frame): Cleaned beer data containing the following variables for each beer:
  * *Name* (factor): Name of the beer
  * *Beer_ID* (integer vector): ID number unique to the beer
  * *ABV* (numeric vector): Alcohol by volume of the beer
  * *IBU* (integer vector): International Bitterness Units of the beer
  * *Brew_ID* (integer vector): Brewery ID associated with the beer
  * *Style* (factor): Style of the beer
  * *Ounces* (numeric vector): Ounces of beer
* *brew.data* (data.frame): Combined beer and brewery data merged by brewery ID ('Brew_ID') with the following variables for each beer:
  * *Brew_ID* (integer vector): ID number unique to the brewery (ranges 1 to 558)
  * *Brew_Name* (factor): Name of the brewery
  * *City* (factor): City in which the brewery is located
  * *State* (factor): US State in which the brewery is located
  * *Beer_Name* (factor): Name of the beer
  * *Beer_ID* (integer vector): ID number unique to the beer
  * *ABV* (numeric vector): Alcohol by volume of the beer
  * *IBU* (integer vector): International Bitterness Units of the beer
  * *Brew_ID* (integer vector): Brewery ID associated with the beer
  * *Style* (factor): Style of the beer
  * *Ounces* (numeric vector): Ounces of beer
* *breweries.by.state* (array): Number of breweries in each state
* *ABV_medians* (named integer vector): Gives the Median Alcohol Content for beers per state manufactured
* *IBU_medians* (named integer vector): Gives the International Bitterness Unit for beers per state manufactured
