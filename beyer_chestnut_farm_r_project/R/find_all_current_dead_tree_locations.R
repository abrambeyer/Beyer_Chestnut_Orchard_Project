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



trees_final3 %>% nrow()

trees_final3 %>% filter(TreeDeath == 1) %>% nrow()


#find all tree locations where TreeDeath = 1.
dead_trees <- trees_final3 %>%
  filter(TreeDeath == 1) %>% 
  arrange(Column, Row)

write.csv(dead_trees, "dead_trees_2019.csv")

