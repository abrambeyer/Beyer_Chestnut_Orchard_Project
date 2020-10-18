# 2015 no trees were planted.  Only trees died so we need to record those.
#####################################################################################


library(tidyverse)
library(RODBC)
library(readxl)

# Connect to the database


odbcDataSources()
connect <- odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=D:/Users/Dr Roger Beyer/Desktop/CHESTNUTS/access_database/BeyerFarm.accdb")


treedata <- sqlQuery(connect, "select *
                     from 
                     Tree")

treevar <- sqlQuery(connect, "select * from TreeVariety")


treelocationdata <- sqlQuery(connect, "select * from TreeLocation")
treedata_joined <- inner_join(treedata, treelocationdata, by = "TreeLocationID")
treedata_joined_var <- inner_join(treedata_joined,treevar, by="TreeVarietyID")
odbcClose(connect)


#####################################################################################

# read the spring 2015 excel spreadsheet

data2015_excel = read_excel("../Chestnut Lay Out Spread Sheet 2015 spring.xlsx", sheet="Sheet1", skip=2)

data2015_excel <- data2015_excel %>% select('O',
                                            'N','M','L',
                                            'K','J','I','H',
                                            'G','F','E','D',
                                            'C','B','A')


# How many "dead" trees in the spring 2015 excel spreadsheet?
df2 <- as.vector(as.matrix(data2015_excel))

length(subset(df2, !(df2 %in% c('PM','LD','BD','C','MS','MV',NA,'Pecan','ROW','COLUMN','AISLE'))))

#224 dead trees listed in spring 2015 excel file.


#####################################################################################

treedata_joined %>%
  filter(TreeDeath == 1) %>%
  group_by(TreePlantDate) %>%
  summarise(count = n())

#265 dead trees in the database before adding them.

treedata_joined %>%
  filter(TreeDeath == 1) %>%
  group_by(TreeDeathDate) %>%
  summarise(count = n())

treedata_joined_var %>%
  select(Column, Row, TreeID) %>%
  group_by(Column,Row) %>%
  summarise(count = n()) %>%
  filter(count == 2) %>%
  nrow()



##################################################################

# check planting count

treedata_joined_var %>%
  filter(TreePlantDate == '2017-05-12') %>%
  nrow()

treedata_joined_var %>%
  filter(TreePlantDate == '2017-05-12') %>%
  group_by(TreeVarietyName) %>%
  summarise(count = n())


treedata_joined_var %>%
  filter(TreePlantDate == '2017-05-12' & TreeVarietyName == 'Colossal') %>%
  group_by(TreeVarietyName, Column) %>%
  summarise(count = n())



treedata_joined_var %>%
  filter(Transplant == 1) %>%
  group_by(TreeVarietyName) %>%
  summarise(count = n())


treedata_joined_var %>%
  filter(TreeDeath == 1 | !is.na(TreeDeathDate)) %>%
  group_by(Column, Row) %>%
  summarise(count = n()) %>%
  filter(count > 1) %>%
  arrange(Column) %>%
  View()

treedata_joined_var %>%
  filter(TreeDeath != 1 & TreePlantDate == '2014-10-17') %>%
  nrow()



treedata_joined_var %>%
  filter(Transplant == 1) %>%
  select(Column, Row, TreeVarietyName)



treedata_joined_var %>%
  filter(TreeVarietyName == 'Bouche de Betizac') %>%
  select(Column, Row, TreePlantDate, Transplant, TreeDeath) %>%
  filter(TreeDeath == 1) %>%
  write.csv('column_q.csv')




treedata_joined_var %>%
  filter(TreeVarietyName == 'Bouche de Betizac') %>%
  group_by(TreePlantDate,TreeDeath) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  group_by(TreePlantDate) %>%
  mutate(yeartotal = sum(count))

treedata_joined_var %>%
  filter(TreeVarietyName == 'Bouche de Betizac') %>%
  filter(TreeDeath == 0) %>%
  group_by(Column) %>%
  summarise(count = n())


treedata_joined_var %>%
  filter(Column == 'Q') %>%
  select(Column, Row, TreeVarietyName,TreeDeath) %>%
  write.csv("column_q.csv")



treedata_joined_var %>%
  filter(TreePlantDate == '2017-05-12') %>%
  group_by(TreeVarietyName) %>%
  summarise(count = n())





treelocationdata %>%
  filter(Column %in% c('W','X','Y','Z')) %>%
  filter(Row >= 1 & Row <= 112) %>%
  filter(Column %in% c('W','X','Y') | (Column == 'Z' & Row >= 1 & Row <= 72)) %>%
  select(TreeLocationID, Column, Row) %>%
  write.csv("w_x_y_x_treelocations.csv")

  
treedata_joined_var %>%
  filter(TreePlantDate == '2017-05-12') %>%
  filter(TreeVarietyName)

treedata_joined_var %>%
  filter(TreeDeath == 0) %>%
  group_by(TreeLocationID, Column, Row) %>%
  summarise(count = n()) %>%
  filter(count > 1) %>%
  arrange(desc(count))


treedata_joined_var %>%
  filter(TreePlantDate == '2017-05-12') %>%
  filter(TreeVarietyName == 'Bouche de Betizac') %>%
  arrange(Column, Row) %>%
  select(Column, Row, TreeVarietyName, TreePlantDate) %>%
  write.csv("bd_planted_2017.csv")


treedata_joined_var %>%
  select(TreePlantDate) %>% unique()


treedata %>%
  nrow()
