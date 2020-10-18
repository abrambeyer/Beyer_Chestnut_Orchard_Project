## Script:  Creating basic heatmaps of the Beyer Chestnut Orchard
## Author:  R. Abram Beyer
## Date:    04/10/2019

library(tidyverse)
library(ggalt)
library(ggthemes)
library(RODBC)
library(RColorBrewer)
library(zoo)
library(eeptools)
#########################################################################

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

#########################################################################


# How many alive trees were there in Fall 2018?




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


# Step 5:  Only keep the alive trees

alive_trees <- trees_final3 %>%
  filter(TreeDeath == 0)

alive_trees %>%
  group_by(Pollinator) %>%
  summarise(count = n())

alive_trees %>%
  group_by(TreeVarietyName,Pollinator) %>%
  summarise(count = n())


# Step 6:  Calculate the age of each tree in October, 2018 during the harvest time.

alive_trees %>%
  mutate(age = age_calc(as.Date(TreePlantDate,format="%Y-%m-%d"), enddate = as.Date('2019-10-10',format="%Y-%m-%d"), units = "years", precise = TRUE)) %>%
  group_by(age,Pollinator) %>%
  summarise(count = n()) %>%
  arrange(desc(age))

alive_trees %>% nrow()



#2016 Harvest:  150lbs
#2017 Harvest:  350lbs
#2018 Harvest:  3,200lbs.



##################################################################################################################

# # How many alive trees were there in Fall 2017? 


# Step 1:  select only necessary columns
trees_final_2017 <- treedata_joined_var %>%
  select(TreeLocationID, TreeID,Column, Row,TreeDeath, TreeDeathDate, TreePlantDate,TreeVarietyName,Pollinator,Transplant)

#n_distinct(trees_final$TreeID)
#4618 distinct trees in the database


#n_distinct(trees_final$TreeLocationID)
#3449 distinct tree locations

# Step 2: Reduce the dataframe down to only the most recent tree in each location.
trees_final2_2017 <- trees_final_2017 %>% 
  filter(TreePlantDate != '2018-05-12') %>%   # remove trees planted in 2018
  group_by(TreeLocationID) %>% 
  filter(TreePlantDate == max(TreePlantDate) | Transplant == 1)



# Step 3:  Isolate locations which have duplicates.  This will happen if a tree was planted
#          then died and was replaced all in the same year.
duplicate_trees_2017 <- trees_final2_2017 %>%
  group_by(TreeLocationID) %>%
  summarise(count = n_distinct(TreeID)) %>%
  arrange(desc(count)) %>%
  filter(count > 1) 



# filter the dataset to get the correct IDs of the DEAD duplicate locations
dead_duplicate_trees_2017 <- inner_join(duplicate_trees_2017,trees_final2_2017, by="TreeLocationID") %>%
  filter(TreeDeath == 1)

# Step 4:  Anti join to filter out DEAD duplicates
trees_final3_2017 <- anti_join(trees_final2_2017, dead_duplicate_trees_2017, by='TreeID')


# Step 5:  Switch the 2018 dead trees back to alive because they did not die yet.


trees_final3_2017$TreeDeath[trees_final3_2017$TreeDeathDate == '2018-05-12 00:00:00'] <- 0

trees_final3_2017$TreeDeathDate[trees_final3_2017$TreeDeathDate == '2018-05-12 00:00:00'] <- NA


# Step 6:  How many alive trees were there in Fall 2017?


alive_trees_2017 <- trees_final3_2017 %>%
  filter(TreeDeath == 0)

alive_trees_2017 %>%
  group_by(Pollinator) %>%
  summarise(count = n())

alive_trees_2017 %>%
  group_by(TreeVarietyName,Pollinator) %>%
  summarise(count = n())



# Step 7:  Calculate the age of each tree in October, 2017 during the harvest time.

alive_trees_2017 %>%
  mutate(age = age_calc(as.Date(TreePlantDate,format="%Y-%m-%d"), enddate = as.Date('2017-10-10',format="%Y-%m-%d"), units = "years", precise = TRUE)) %>%
  group_by(age,Pollinator) %>%
  summarise(count = n()) %>%
  arrange(desc(age))


# In 2017, how many pounds per tree type (pollinator vs. producer):
#4-years old
xprod = 0.7981
xpol = .3995


########################################################################################################

#5-years old
xprod = 6.4516
xpol = 3.2258

