library(tidyverse)
library(RODBC)


odbcDataSources()
connect <- odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=D:/Users/Dr Roger Beyer/Desktop/CHESTNUTS/BeyerFarm.accdb")


treedata <- sqlQuery(connect, "select *
                     from 
                     Tree")

treevar <- sqlQuery(connect, "select * from TreeVariety")

treelocationdata <- sqlQuery(connect, "select * from TreeLocation")
treedata_joined <- inner_join(treedata, treelocationdata, by = "TreeLocationID")
treedata_joined_var <- inner_join(treedata_joined,treevar, by="TreeVarietyID")
odbcClose(connect)

#####################################################################################

## Count trees in the database
treedata %>%
  filter(TreePlantDate == '2013-10-17') %>%
  nrow()

#999...only

#count colosals from 2013
treedata %>%
  filter(TreePlantDate == '2013-10-17' & TreeVarietyID == 1) %>%
  nrow()
#652...OK  (651 C + 1 roots)

#count PM from 2013
treedata %>%
  filter(TreePlantDate == '2013-10-17' & TreeVarietyID == 4) %>%
  nrow()
#112...OK


#count LD from 2013
treedata %>%
  filter(TreePlantDate == '2013-10-17' & TreeVarietyID == 3) %>%
  nrow()
#53..OK

#count BD from 2013
treedata %>%
  filter(TreePlantDate == '2013-10-17' & TreeVarietyID == 2) %>%
  nrow()
#180..OK

#count unlabs from 2013
treedata %>%
  filter(TreePlantDate == '2013-10-17' & TreeVarietyID == 10) %>%
  nrow()
#2..OK

#651 + 113 + 53 + 180 + 2  = 999

#####################################################################################

unique(treedata$TreeDeathDate)

# Dead trees

treedata %>%
  filter(TreePlantDate == '2013-10-17' & TreeDeath == 1 & TreeDeathDate == '2014-06-01') %>%
  nrow()
# 155 dead



#####################################################################################


treedata_joined %>%
  select(Column,Row,TreeDeath) %>%
  filter(Column == 'E' & TreeDeath == 1)

treedata_joined_var %>%
  select(TreeID, TreeVarietyName,TreePlantDate) %>%
  filter(TreePlantDate == '2013-10-17') %>%
  group_by(TreeVarietyName) %>%
  summarise(count = n())


treedata_joined_var %>%
  select(TreeID, TreeVarietyName,TreePlantDate) %>%
  filter(TreePlantDate == '2014-10-17') %>%
  group_by(TreeVarietyName) %>%
  summarise(count = n()) %>%
  summarise(sum =sum(count))



treedata_joined %>%
  select(Column,Row,TreeDeath) %>%
  #filter(Column == 'A') %>%
  group_by(Column, Row) %>%
  summarise(count = n()) %>%
  filter(count == 2) %>%
  View()

treedata_joined %>%
  select(Column,Row,TreeDeath,TreeVarietyID) %>%
  filter(Column == 'E' & TreeVarietyID == 4) %>%
  #filter(Column == 'E') %>%
  group_by(Column, Row) %>%
  summarise(count = n()) %>%
  filter(count == 2) %>%
  View()



treedata_joined %>%
  select(Column,Row,TreeDeath,TreePlantDate) %>%
  filter(Column == 'L' & Row %in% c(67,99,103)) %>%
  arrange(Column,Row)
  


treedata_joined %>%
  filter(TreePlantDate == '2013-10-17') %>%
  group_by(Column) %>%
  summarise(n = n())

# Column      n
# <fct>     <int>
# 1  A         59
# 2  B        117
# 3  C        117
# 4  D        117
# 5  E         57
# 6  F        119
# 7  G         61
# 8  H        119
# 9  I         31
# 10 J        120
# 11 L         59
# 12 ZZZ       23


treedata %>%
  filter(TreePlantDate == '2013-10-17') %>%
  colnames()

# find the row and columns marked 'dead' and planted in 2013

treedata_joined %>%
  filter(TreePlantDate == '2013-10-17' & TreeDeath == 1) %>%
  select(Column,Row)

treedata_joined %>%
  filter(TreePlantDate == '2013-10-17' & Column == 'ZZZ') %>%
  select(Column,Row,TreeDeath)
  


#####################################################################################

## 2014 ##


## Count trees in the database
treedata %>%
  filter(TreePlantDate == '2014-10-17') %>%
  nrow()

treedata %>%
  filter(TreePlantDate == '2013-10-17') %>%
  nrow()



#779 for 2014

780 + 999

treedata %>%
  group_by(TreeLocationID) %>%
  summarise(n = n()) %>%
  filter(n > 1) %>% View()


#count colosals from 2014
treedata %>%
  filter(TreePlantDate == '2014-10-17' & TreeVarietyID == 1) %>%
  nrow()
#0  zero colosals planted in 2014?

#count PM from 2014
treedata %>%
  filter(TreePlantDate == '2014-10-17' & TreeVarietyID == 4) %>%
  nrow()
#243...OK


#count LD from 2014
treedata %>%
  filter(TreePlantDate == '2014-10-17' & TreeVarietyID == 3) %>%
  nrow()
#100..OK

#count BD from 2014
treedata %>%
  filter(TreePlantDate == '2014-10-17' & TreeVarietyID == 2) %>%
  nrow()
#282..OK

#count unlabs from 2014
treedata %>%
  filter(TreePlantDate == '2014-10-17' & TreeVarietyID == 10) %>%
  nrow()
#0..OK

#count MS from 2014
treedata %>%
  filter(TreePlantDate == '2014-10-17' & TreeVarietyID == 5) %>%
  nrow()
#96

#count MV from 2014
treedata %>%
  filter(TreePlantDate == '2014-10-17' & TreeVarietyID == 6) %>%
  nrow()
#58

0 + 243 + 100 + 282 + 0 + 96 + 58


treedata %>%
  filter(TreePlantDate == '2014-10-17') %>%
  count(TreeVarietyID)




#####################################################################################

# Dead trees

treedata %>%
  filter(TreePlantDate == '2014-10-17' & TreeDeath == 1) %>%
  nrow()
# 101 dead

#####################################################################################
treedata_joined <- inner_join(treedata, treelocationdata, by = "TreeLocationID")

treedata_joined %>%
  filter(TreePlantDate == '2013-10-17') %>%
  group_by(Column) %>%
  summarise(n = n())


#####################################################################################

treedata_joined %>%
  filter(Column == 'E') %>%
  nrow()



treedata_joined_var %>%
  filter(Column == 'ZZZ') %>%
  group_by(TreeVarietyName,TreePlantDate) %>%
  summarise(count = n())
  

treedata_joined_var %>% 
  filter(TreePlantDate == '2013-10-17' & `Column` == 'E' & TreeVarietyName == 'Labor Day') %>%
  select(Column, Row, TreeVarietyName,TreePlantDate)

treedata_joined %>%
  filter(Column == 'E' & TreeDeath == 1 & TreeVarietyID == 3) %>%
  nrow()


treedata_joined_var %>%
  group_by(TreePlantDate) %>%
  summarise(count = n())


treedata_joined_var %>%
  select(TreeVarietyName,TreePlantDate,TreeID) %>%
  filter(TreePlantDate == '2014-10-17') %>%
  group_by(TreeVarietyName) %>%
  summarise(count = n()) %>%
  summarise(sum(count))


treedata_joined_var %>%
  group_by(Column, Row) %>%
  summarise(count = n()) %>%
  filter(count > 1) %>%
  View()


treedata_joined_var %>%
  filter(Column == 'ZZZ') %>%
  View()









