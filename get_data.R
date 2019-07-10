#data_analyis 
#see if readXl can do this

library(readxl)
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