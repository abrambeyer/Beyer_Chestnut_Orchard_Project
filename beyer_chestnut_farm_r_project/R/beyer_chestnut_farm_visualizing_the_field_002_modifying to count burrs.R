## Script:  Creating basic heatmaps of the Beyer Chestnut Orchard
## Author:  R. Abram Beyer
## Date:    04/10/2019

library(tidyverse)
library(ggalt)
library(ggthemes)
library(RODBC)
library(RColorBrewer)
library(zoo)
#########################################################################

# Connect to the database

odbcDataSources()
connect <- odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=D:/Users/Dr Roger Beyer/Desktop/CHESTNUTS/access_database/BeyerFarm.accdb")


treedata <- sqlQuery(connect, "select *
                     from 
                     Tree")

treevar <- sqlQuery(connect, "select * from TreeVariety")

treelocationdata <- sqlQuery(connect, "select * from TreeLocation")
treeEvent <- sqlQuery(connect,"select f.TreeLocationID,e.EventType from FarmEvent as f LEFT JOIN EventType as e ON f.EventTypeID = e.EventTypeID WHERE f.EventTypeID in (22,23,24,25)")
treedata_joined <- inner_join(treedata, treelocationdata, by = "TreeLocationID")
treedata_joined_var <- inner_join(treedata_joined,treevar, by="TreeVarietyID")
treedata_joined_var <- left_join(treedata_joined_var,treeEvent, by="TreeLocationID")
odbcClose(connect)



#########################################################################

# find all trees in the field now

# Step 1:  select only necessary columns
trees_final <- treedata_joined_var %>%
  select(TreeLocationID, TreeID,Column, Row,TreeDeath, TreeDeathDate, TreePlantDate,TreeVarietyName,Pollinator,Transplant,EventType)
  
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

# Step 5:  Handling the transplanted trees.  Some trees were transplanted.  
# transplanted_trees <- trees_final %>%
#   filter(Transplant == 1)
# 
# trees_final4 <- bind_rows(trees_final3, transplanted_trees)
# 
# transplanted_duplicates <- trees_final4 %>%
#   group_by(TreeLocationID) %>%
#   summarise(count = n_distinct(TreeID)) %>%
#   filter(count > 1) %>% select(TreeLocationID)


# leaving off here....


# transplanted_duplicates2 <- inner_join(trees_final4,transplanted_duplicates,by="TreeLocationID")
# 
# alive_transplants <- transplanted_duplicates2 %>% 
#   arrange(TreeLocationID) %>% filter(TreeDeath == 0)
# 
# dead_transplants <- transplanted_duplicates2 %>% 
#   arrange(TreeLocationID) %>% filter(TreeDeath == 1)
# 
# trees_final5 <- anti_join(trees_final4, dead_transplants,by='TreeID')
# 
# trees_final6 <- bind_rows(trees_final5, alive_transplants)
# 
# trees_final6 %>% filter(Transplant == 1) %>% View()
# 
# levels(trees_final6$TreeVarietyName)

#########################################################################

## Visualizaing Tree Variety Location and Tree Death Location

trees_final3$Column <- factor(trees_final3$Column, levels = c("A","B","C","D","E","F",
                         "G","H","I","J","K","L",
                         "M","N","O","P","Q","R","S",
                         "T","U","V","W","X","Y","Z","AA",
                         "BB","CC","DD","ZZZ"))


columnlabs1 <- levels(trees_final3$Column)
columnlabs2 <- c("A","B","C","D","E","F",
                 "G","H","I","J","K","L",
                 "M","N","O","P","Q","R","S",
                 "T","U","V","W","X","Y","Z","AA",
                 "BB","CC","DD","ZZZ")


ggplot(filter(trees_final3, Row <= 58), aes(as.numeric(Column), Row)) + geom_tile(aes(fill = TreeVarietyName),colour = "white") + 
  geom_point(data=filter(trees_final3, TreeDeath == 1 & Row <= 58), mapping=aes(x=as.numeric(Column), y=Row), shape=4, size=5,alpha=1,stroke=2) +
  scale_fill_discrete() + 
  scale_fill_brewer(palette = "Set1",type="div") + 
  theme_minimal()  +
  scale_x_continuous(breaks = 1:length(columnlabs1),
                     labels = columnlabs1,
                     sec.axis = sec_axis(~.,
                                         breaks = 1:length(columnlabs2),
                                         labels = columnlabs2)) + 
  scale_y_continuous(sec.axis = dup_axis(),
                     breaks = round(seq(0, max(trees_final3$Row), by = 5),1),
                     minor_break = seq(0,max(trees_final3$Row),5)) + 
  theme(legend.position="top") +
  theme(axis.text.x = element_text(size =22),
        axis.text.y = element_text(size=22),
        legend.text = element_text(colour="black", size=22),
        legend.title = element_text(size=22),
        axis.title.x=element_text(size=27),
        axis.title.y=element_text(size=27),
        axis.title.y.right = element_blank(),
        panel.grid.minor = element_line(colour="black", size=0.5),
        panel.grid.major = element_line(colour="black", size=0.5)) #+
  #labs(fill = "Tree Variety",x="ROAD",y="RUNWAY")




#######################################################################

# Visualize Tree Event (Burr Count) by location.

trees_final3$Column <- factor(trees_final3$Column, levels = c("A","B","C","D","E","F",
                                                              "G","H","I","J","K","L",
                                                              "M","N","O","P","Q","R","S",
                                                              "T","U","V","W","X","Y","Z","AA",
                                                              "BB","CC","DD","ZZZ"))


columnlabs1 <- levels(trees_final3$Column)
columnlabs2 <- c("A","B","C","D","E","F",
                 "G","H","I","J","K","L",
                 "M","N","O","P","Q","R","S",
                 "T","U","V","W","X","Y","Z","AA",
                 "BB","CC","DD","ZZZ")


ggplot(filter(trees_final3, Row <= 58), aes(as.numeric(Column), Row)) + geom_tile(aes(fill = EventType),colour = "white") + 
  geom_point(data=filter(trees_final3, TreeDeath == 1 & Row <= 58), mapping=aes(x=as.numeric(Column), y=Row), shape=4, size=5,alpha=1,stroke=2) +
  scale_fill_discrete() + 
  scale_fill_brewer(palette = "Set1",type="div") + 
  theme_minimal()  +
  scale_x_continuous(breaks = 1:length(columnlabs1),
                     labels = columnlabs1,
                     sec.axis = sec_axis(~.,
                                         breaks = 1:length(columnlabs2),
                                         labels = columnlabs2)) + 
  scale_y_continuous(sec.axis = dup_axis(),
                     breaks = round(seq(0, max(trees_final3$Row), by = 5),1),
                     minor_break = seq(0,max(trees_final3$Row),5)) + 
  theme(legend.position="top") +
  theme(axis.text.x = element_text(size =22),
        axis.text.y = element_text(size=22),
        legend.text = element_text(colour="black", size=22),
        legend.title = element_text(size=22),
        axis.title.x=element_text(size=27),
        axis.title.y=element_text(size=27),
        axis.title.y.right = element_blank(),
        panel.grid.minor = element_line(colour="black", size=0.5),
        panel.grid.major = element_line(colour="black", size=0.5)) +
  labs(fill = "Tree Variety",x="ROAD",y="RUNWAY")




#########################################################################

## Visualizing Tree Variety and Tree Age location

# trees_final3 %>% 
#   mutate(treeUntilDate = ifelse(is.na(TreeDeathDate),zoo::as.Date(Sys.Date()),NA)) %>%
#   mutate(TreeDeathDate = as.Date(TreeDeathDate, format="%Y-%m-%d")) %>%
#   mutate(treeUntilDate = ifelse(is.na(treeUntilDate),TreeDeathDate,treeUntilDate)) %>%
#   mutate(treeUntilDate = as.Date(treeUntilDate)) %>%
#   mutate(treeAge = difftime(as.Date(treeUntilDate),as.Date(TreePlantDate),unit="weeks")/52.25) %>%
#   mutate(treeYear = case_when(treeAge < 1 ~ "0 - 1 years",
#                               treeAge >= 1 & treeAge < 2 ~ "1 - 2 years",
#                               treeAge >= 2 & treeAge < 3 ~ "2 - 3 years",
#                               treeAge >= 3 & treeAge < 4 ~ "3 - 4 years",
#                               treeAge >= 4 & treeAge < 5 ~ "4 - 5 years",
#                               treeAge >= 5 & treeAge < 6 ~ "5 - 6 years",
#                               treeAge >= 6 & treeAge < 7 ~ "6 - 7 years",
#                               treeAge >= 7 & treeAge < 8 ~ "7 - 8 years",
#                               treeAge >= 8 & treeAge < 9 ~ "8 - 9 years",
#                               treeAge >= 9 & treeAge < 10 ~ "9 - 10 years"
#   )) %>% group_by(treeYear) %>% summarise(count = n_distinct(TreeID))


trees_final3$Column <- factor(trees_final3$Column, levels = c("A","B","C","D","E","F",
                                                              "G","H","I","J","K","L",
                                                              "M","N","O","P","Q","R","S",
                                                              "T","U","V","W","X","Y","Z","AA",
                                                              "BB","CC","DD","ZZZ"))


columnlabs1 <- levels(trees_final3$Column)
columnlabs2 <- c("A","B","C","D","E","F",
                 "G","H","I","J","K","L",
                 "M","N","O","P","Q","R","S",
                 "T","U","V","W","X","Y","Z","AA",
                 "BB","CC","DD","ZZZ")

  ggplot(filter(trees_final3, Row <= 58), aes(as.numeric(Column), Row)) + geom_tile(aes(fill = as.factor(TreePlantDate)),colour = "white") + 
  geom_point(data=filter(trees_final3, TreeDeath == 1 & Row <= 58), mapping=aes(x=as.numeric(Column), y=Row), shape=4, size=5,alpha=1,stroke=2) +
  scale_fill_discrete() + 
  scale_fill_brewer(palette = "Set1",type="div") + 
  theme_minimal()  +
  scale_x_continuous(breaks = 1:length(columnlabs1),
                     labels = columnlabs1,
                     sec.axis = sec_axis(~.,
                                         breaks = 1:length(columnlabs2),
                                         labels = columnlabs2)) + 
  scale_y_continuous(sec.axis = dup_axis(),
                     breaks = round(seq(0, max(trees_final3$Row), by = 5),1),
                     minor_break = seq(0,max(trees_final3$Row),5)) + 
  theme(legend.position="top") +
  theme(axis.text.x = element_text(size =22),
        axis.text.y = element_text(size=22),
        legend.text = element_text(colour="black", size=22),
        legend.title = element_text(size=22),
        axis.title.x=element_text(size=27),
        axis.title.y=element_text(size=27),
        axis.title.y.right = element_blank(),
        panel.grid.minor = element_line(colour="black", size=0.5),
        panel.grid.major = element_line(colour="black", size=0.5)) +
  labs(fill = "Tree Variety",x="ROAD",y="RUNWAY")


  

