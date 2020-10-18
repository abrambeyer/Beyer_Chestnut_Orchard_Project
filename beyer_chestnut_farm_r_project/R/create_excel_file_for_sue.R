library(tidyverse)
library(ggalt)
library(ggthemes)
library(RODBC)
library(RColorBrewer)

#########################################################################

# Connect to the database

#odbcDataSources()
connect <- odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=D:/Users/Dr Roger Beyer/Desktop/CHESTNUTS/access_database/BeyerFarm.accdb")


treedata <- sqlQuery(connect, "select *
                     from 
                     Tree")

treevar <- sqlQuery(connect, "select * from TreeVariety")

treelocationdata <- sqlQuery(connect, "select * from TreeLocation")
treedata_joined <- inner_join(treedata, treelocationdata, by = "TreeLocationID")
treedata_joined_var <- inner_join(treedata_joined,treevar, by="TreeVarietyID")
odbcClose(connect)


#########################################################################

# find all trees in the field now




# find all trees in the field now

# Step 1:  select only necessary columns
trees_final <- treedata_joined_var %>%
  select(TreeLocationID, TreeID,Column, Row,TreeDeath, TreeDeathDate, TreePlantDate,TreeVarietyName,Pollinator,Transplant)


#n_distinct(trees_final$TreeID)
#4618 distinct trees in the database


#n_distinct(trees_final$TreeLocationID)
#3449 distinct tree locations

# Step 2: Reduce the dataframe down to only the most recent tree in each location.
trees_final2 <- trees_final %>% 
  group_by(TreeLocationID) %>% 
  filter(TreePlantDate == max(TreePlantDate) | Transplant == 1)


# Step 3:  Isolate locations which have duplicates.  This will happen if a tree was planted
#          then died and was replaced all in the same year.
duplicate_trees <- trees_final2 %>%
  group_by(TreeLocationID) %>%
  summarise(count = n_distinct(TreeID)) %>%
  arrange(desc(count)) %>%
  filter(count > 1) 



# filter the dataset to get the correct IDs of the DEAD duplicate locations
dead_duplicate_trees <- inner_join(duplicate_trees,trees_final2, by="TreeLocationID") %>%
  filter(TreeDeath == 1)

# Step 4:  Anti join to filter out DEAD duplicates
trees_final3 <- anti_join(trees_final2, dead_duplicate_trees, by='TreeID')


#########################################################################



trees_final3$Column <- factor(trees_final3$Column, levels = c("A","B","C","D","E","F",
                                                              "G","H","I","J","K","L",
                                                              "M","N","O","P","Q","R","S",
                                                              "T","U","V","W","X","Y","Z","AA",
                                                              "BB","CC","DD","ZZZ"))


trees_final3 %>% group_by(TreeVarietyName) %>% summarise(count = n_distinct(TreeID))

trees_final4 <- trees_final3 %>%
  select(Column, Row, TreeVarietyName,-TreeLocationID) %>%
  mutate(Variety = case_when(TreeVarietyName == 'Labor Day' ~ 'LD',
                             TreeVarietyName == 'Precoce Migoule' ~ 'PM',
                             TreeVarietyName == 'Bouche de Betizac' ~ 'BD',
                             TreeVarietyName == 'Cuneo' ~ 'CU',
                             TreeVarietyName == 'Maraval' ~ 'MV',
                             TreeVarietyName == 'Marigoule' ~ 'MG',
                             TreeVarietyName == 'Marsol' ~ 'MS',
                             TreeVarietyName == 'Marrone' ~ 'MA',
                             TreeVarietyName == 'Colossal' ~ 'C',
                             TreeVarietyName == 'Unlabelled' ~ 'U'
  )) %>%
  select(-TreeVarietyName)


write.csv(trees_final4,"04.14.2019_trees.csv")

setwd("D:/Users/Dr Roger Beyer/Desktop/CHESTNUTS")

trees_final5 <- read_csv("04.14.2019_trees.csv")

head(trees_final5)

trees_final6 <- spread(trees_final5, Column,Variety)

trees_final6 %>% write.csv("04.14.2019_trees_002.csv")
