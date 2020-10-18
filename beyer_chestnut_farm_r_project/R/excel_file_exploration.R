library(tidyverse)
library(readxl)
library(stringr)

getwd()


#load 2013 dataframe
data2013 = read_excel("../Chestnut Lay Out Spread Sheet 2013-14v2.xlsx", sheet="Sheet1", skip=2)




#remove columns with all NULLS
data2013_b <- data2013 %>%
  select(-ROWNAME1,-ROWNAME2,-N,-M,-K)
  
#Count non-null rows
sum(colSums(!is.na(data2013_b)))
colSums(!is.na(data2013_b))

#L   J   I   H   G   F   E   D   C   B   A 
#84 120  31 119  61 119  57 117 117 117  59

#1001 non-null rows  for 2013


#Count "dead" rows

sum(str_count(data2013_b,"dead"))
# 97

sum(str_count(data2013_b,"DEAD"))
# 0

sum(str_count(data2013_b,"Dead"))
# 0

sum(str_count(data2013_b,"late"))
#4

# 97 + 4 = 101 dead

# Total tree planted and alive in 2013

1001 - 97

#904  should be the total number of alive trees in the database

#################################################################################################
data2013_b %>%
sum(colSums(!is.na(data2013_b)))

sum(str_count(data2013_b,"PM"))
#112
sum(str_count(data2013_b,"LD"))
#53
sum(str_count(data2013_b,"C"))
#651
sum(str_count(data2013_b,"BD"))
#180
sum(str_count(data2013_b,"Pecan"))
#2
sum(str_count(data2013_b,"unlab"))
#2
sum(str_count(data2013_b,"roots"))
#1

# 112 + 53 + 651 + 180 + 2 + 2 + 1 = 1001

# find unique values in the dataframe
df2 <- as.vector(as.matrix(data2013_b))
unique(df2)

sum(str_count(data2013_b$E,"LD"),na.rm=TRUE)
sum(str_count(data2014_b$E,"LD"),na.rm=TRUE)


#################################################################################################
# find dead rows

data2013 %>%
  filter(grepl('dead',E)) %>%
  View()



#################################################################################################


#load 2014 dataframe
data2014 = read_excel("../Chestnut Lay Out Spread Sheet 2014-15v2.xlsx", sheet="Sheet1", skip=2)

head(data2014, width=inf)
#View(data2014)
#remove columns with all NULLS
data2014_b <- data2014 %>%
  select(-ROWNAME1,-ROWNAME2,-U,-T,-S,-R,-Q,-P)

#Count non-null rows
sum(colSums(!is.na(data2014_b)))
sum(colSums(!is.na(data2014_b)))

# O   N   M   L   K   J   I   H   G   F   E   D   C   B   A 
# 62 120 120 117 120 120 119 119 119 119 118 117 117 117 116



#1720 non-null rows  for 2014


#Count "dead" rows

sum(str_count(data2014_b,"dead"))
# 85

sum(str_count(data2014_b,"DEAD"))
# 0

sum(str_count(data2014_b,"Dead"))
# 0

sum(str_count(data2014_b,"late"))
#2

sum(str_count(data2014_b,"Pecan"))
#2

#1720 - 87 = 1633 alive



#################################################################################################

sum(str_count(data2014_b,"PM"))
#346
sum(str_count(data2014_b,"LD"))
#146
sum(str_count(data2014_b,"C"))
#651
sum(str_count(data2014_b,"BD"))
#444
sum(str_count(data2014_b,"MV"))
#58
sum(str_count(data2014_b,"MS"))
#70
sum(str_count(data2014_b,"Pecan"))
#2
sum(str_count(data2014_b,"unlab"))
#2
sum(str_count(data2014_b,"roots"))
#1

sum(str_count(data2014_b$B,"C"),na.rm=TRUE)
sum(str_count(data2014_b$E,"PM"),na.rm=TRUE)

# 346 + 146 + 651 + 444 + 58 + 70 + 2 + 2 + 1 = 1720


# find unique values in the dataframe
df2 <- as.vector(as.matrix(data2014_b))
unique(df2)


#################################################################################################
# find dead rows

data2014 %>%
  filter(grepl('dead',E)) %>%
  View()


# find the locations where trees are marked as dead or late in 2013




#################################################################################################



