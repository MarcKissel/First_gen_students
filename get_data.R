#data_analyis 
#see if readXl can do this

library(readxl)
library(tidyverse)
temp <- read_excel("data/sed17-sr-tab033.xlsx", skip=3)
glimpse(temp)
View(temp)
temp <- read_excel("data/sed17-sr-tab033.xlsx", skip=3, col_names = c("demo", "total", "all", "highSchool", "somecollege", "bach", "advanced"))
glimpse(temp)
View(temp)
#ok, now row 1 is garbadge but looking better. still have issues of grouped data 
#another idea is play around with import tool

#ok, so problem is basically that this is a pivot table of sorts.
#i think tidyxl might help
#https://github.com/nacnudus/tidyxl
#install.packages("tidyxl")
#library(tidyxl)
#ftable(Titanic, row.vars = 1:2)
#titanic <- system.file("extdata/titanic.xlsx", package = "tidyxl")
#readxl::read_excel(titanic)
#x <- xlsx_cells(titanic)
#dplyr::glimpse(x)
#View(x)
#x[x$data_type == "character", c("address", "character")]



#look here: https://nacnudus.github.io/spreadsheet-munging-strategies/pivot-simple.html
# and here: https://www.youtube.com/watch?v=1sinC7wsS5U 
# for above check at 18:40 for hints but prob need to watch whole thing
# and this: http://rpubs.com/dgrtwo/tidying-enron

#this might be better than other video: https://www.youtube.com/watch?v=Q_McYaDV9H0 
# check arouf 2:50


#AND THIS!
#https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-02-19

#ok, so lets try

#prob is that the first col has data that is indented but that doesn't show
#up in the text. when you immport with readxl it only import the value. but that leading space is impt
#tidyxl imports each cell into its own row and imports formatting
#need
#as of 7/10 i am cheating a littlem bit by editing the 
#xls file. 
#1. i removed the line"Parental education attainment (%)"
#2. then i moved the col names below that up to where 'Parental education attainment (%)' used to be
# prob could find way to do this but for now i am staying with it

install.packages("tidyxl")
install.packages("unpivotr")
library(tidyxl)
library(unpivotr) #this goes from the one row per cell format back into datatable

cells <- xlsx_cells("data/sed17-sr-tab033b.xlsx") #get data
cells %>% select(row, col, data_type, character, numeric, local_format_id)
# so first cell has value 'table 33' r 1 c 1
formats <- xlsx_formats("data/sed17-sr-tab033b.xlsx") 
#list of lists. it descibres the state of the cell. is it bold? etc
#there is also an allignment 

#we can look up the local format id from the cells table to see the format of that cell
#we want to know if cell is indented

#look under alignment and then the indent 'leaf'
#also need to know the Direction that we need to go..NNW etc

indent <-formats$local$alignment$indent
indents #this is just the vector of 496 elements. we see where indents


cells %>% 
  filter(row >= 4L) %>% 
  behead_if(indent[local_format_id] == 0, direction= "WNW", name ="field1") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  #select(row, col, data_type, character, numeric, field1) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  #filter(row >= 9)
  #now, lets strip off the second level
  behead_if(indent[local_format_id] == 1, direction= "WNW", name ="field2") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  #select(row, col, data_type, character, numeric, field1, field2) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  #filter(row >= 9)
  behead_if(indent[local_format_id] == 2, direction= "WNW", name ="field3") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  behead_if(indent[local_format_id] == 3, direction= "WNW", name ="field4") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  
  select(row, col, data_type, character, numeric, field1, field2, field3, field4) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  filter(row >= 9) %>% View()
#this is kinda working

#below is getting into R the right way!

cells %>% 
  filter(row >= 4L) %>% 
  behead_if(indent[local_format_id] == 0, direction= "WNW", name ="field1") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  #select(row, col, data_type, character, numeric, field1) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  #filter(row >= 9)
  #now, lets strip off the second level
  behead_if(indent[local_format_id] == 1, direction= "WNW", name ="field2") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  #select(row, col, data_type, character, numeric, field1, field2) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  #filter(row >= 9)
  behead_if(indent[local_format_id] == 2, direction= "WNW", name ="field3") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  behead_if(indent[local_format_id] == 3, direction= "WNW", name ="field4") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  behead("N", name="parents_data") # %>% 
  #select(row, col, data_type, character, numeric, field1, field2, field3, field4, parents_data) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  #filter(row >= 9) %>% View()


#getting it set

data_2017 <- cells %>% 
  filter(row >= 4L) %>% 
  behead_if(indent[local_format_id] == 0, direction= "WNW", name ="field1") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  #select(row, col, data_type, character, numeric, field1) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  #filter(row >= 9)
  #now, lets strip off the second level
  behead_if(indent[local_format_id] == 1, direction= "WNW", name ="field2") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  #select(row, col, data_type, character, numeric, field1, field2) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  #filter(row >= 9)
  behead_if(indent[local_format_id] == 2, direction= "WNW", name ="field3") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  behead_if(indent[local_format_id] == 3, direction= "WNW", name ="field4") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  behead("N", name="parents_data") %>% 
  select(field1:field4, parents_data, value = numeric)
#just note some fieds have NA but we can getrid of those

#looking at the data

#what is the mean number of people who have fathers of ed attainment across all field
 
data_2017 %>% filter(!is.na(value)) %>% select(-field1) %>% filter(field2 == "Field of study") %>% filter(field4 == "Father's education") %>%
  group_by(parents_data) %>%filter(parents_data != "Total (number)",
                                   parents_data != "All")   %>% 
  summarise(median(value)) %>% knitr::kable(caption = "father's education attainment 2017") %>% kableExtra::kable_styling()



#what is the mean number of people who have mothers of ed attainment across all field
data_2017 %>% filter(!is.na(value)) %>% select(-field1) %>% filter(field2 == "Field of study") %>% filter(field4 == "Mother's education") %>%
  group_by(parents_data) %>%filter(parents_data != "Total (number)",
                                   parents_data != "All")   %>% 
  summarise(median(value)) %>% knitr::kable(caption = "mothers education attainment 2017") %>% kableExtra::kable_styling()



#######






cells %>% 
  filter(row >= 4L) %>% 
  behead_if(indent[local_format_id] == 0, direction= "WNW", name ="field1") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  #select(row, col, data_type, character, numeric, field1) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  #filter(row >= 9)
  #now, lets strip off the second level
  behead_if(indent[local_format_id] == 1, direction= "WNW", name ="field2") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  #select(row, col, data_type, character, numeric, field1, field2) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  #filter(row >= 9)
  behead_if(indent[local_format_id] == 2, direction= "WNW", name ="field3") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  behead(direction= "W", name ="field4") %>%  #only consider header cells that have indent of zero. to do this we index into the indent vector. we look at each cell's local format id and see if it = 0
  
  select(row, col, data_type, character, numeric, field1, field2, field3, field4) %>%  #note that it is assingign some of the header cells to have a value. will fix as we go
  filter(row >= 9) %>% View()
