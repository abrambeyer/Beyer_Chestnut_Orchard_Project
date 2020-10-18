library(tidyverse)
library(RODBC)


odbcDataSources()
connect <- odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=D:/Users/Dr Roger Beyer/Desktop/CHESTNUTS/BeyerFarm.accdb")


treedata <- sqlQuery(connect, "select *
                     from 
                     Tree")
treedata

dim(treedata)
n_distinct(treedata$TreeID)


treedata %>% filter(TreeVarietyID == 6)

treelocationdata <- sqlQuery(connect, "select * from TreeLocation")
treelocationdata

treevarietydata <- sqlQuery(connect, "select * from TreeVariety")
treevarietydata


dim(treelocationdata)

treedata_joined <- inner_join(treedata, treelocationdata, by = "TreeLocationID")

treedata_joined <- inner_join(treedata_joined, treevarietydata, by = "TreeVarietyID")

dim(treedata_joined)

head(treedata_joined)


treedata_joined <- treedata_joined %>% select(TreeID, Column, Row, TreeVarietyName, TreePlantDate TreeDeath)

head(treedata_joined)


n_distinct(treedata$TreeID)

str(treedata)



treedata %>% filter(TreePlantDate == "2013-10-17") %>% select(TreeID) %>% n_distinct()

treedata %>% filter(TreePlantDate == "2014-10-17") %>% select(TreeID) %>% n_distinct()

# Count of Trees in the Orchard 2013 & 2014

treedata_joined %>% 
  group_by(TreeVarietyName) %>% 
  summarise(n = n()) %>% 
  ggplot() + 
  geom_bar(aes(x=reorder(TreeVarietyName,n), y=n),stat="identity", fill="blue", alpha=0.7) + 
  geom_text(aes(x = TreeVarietyName, y=n, label=n), position=position_dodge(width=0.9), vjust=-0.5) +
  theme_minimal() +
  coord_flip() + 
  labs(title = "Beyer Orchard 2013 & 2014 Tree Count By Variety", x= "Tree Variety Name", y="Count")


# Count of Trees in the Orchard 2014

treedata_joined %>% 
  filter(TreePlantDate == "2014-10-17") %>%
  group_by(TreeVarietyName) %>% 
  summarise(n = n()) %>% 
  ggplot() + 
  geom_bar(aes(x=reorder(TreeVarietyName,n), y=n),stat="identity", fill="blue", alpha=0.7) + 
  geom_text(aes(x = TreeVarietyName, y=n, label=n), position=position_dodge(width=0.9), vjust=-0.5) +
  theme_minimal() +
  coord_flip() + 
  labs(title = "Beyer Orchard 2014 Tree Count By Variety", x= "Tree Variety Name", y="Count")



treedata_joined %>% 
  filter(TreePlantDate == "2014-10-17") %>%
  group_by(Column,TreeVarietyName) %>% 
  summarise(n = n()) %>% 
  ggplot() + 
  geom_bar(aes(x=reorder(Column,n), y=n, fill=TreeVarietyName),stat="identity", fill="blue", alpha=0.7) + 
  geom_text(aes(x = Column, y=n, label=n), position=position_dodge(width=0.9), vjust=-0.5) +
  theme_minimal() +
  coord_flip() + 
  labs(title = "Beyer Orchard 2014 Tree Count By Variety", x= "Tree Variety Name", y="Count")

# Count of Tree Deaths By Tree Variety in the Orchard 2013

treedata_joined %>% 
  group_by(TreeVarietyName,TreeDeath) %>% 
  summarise(n = n()) %>% 
  ggplot() + 
  geom_bar(aes(x=reorder(TreeVarietyName,n), y=n, fill=as.factor(TreeDeath)),stat="identity") + 
  geom_text(aes(x = TreeVarietyName, y=n, label=n), position=position_dodge(width=0.9), vjust=-0.5) +
  theme_minimal() +
  coord_flip() + 
  labs(title = "Beyer Orchard Tree Death vs. Alive Count By Variety", x= "Tree Variety Name", y="Count") +
  guides(fill=guide_legend(title="Tree Death: 1 = Yes 0 = No")) +
  scale_fill_manual(values=c("green","red"))



# Count of Tree Deaths By Tree Variety in the Orchard 2013

treedata_joined %>% 
  group_by(TreeVarietyName,TreeDeath) %>% 
  summarise(n = n()) %>%
  ungroup %>% 
  complete(TreeVarietyName, TreeDeath, fill=list(n=0)) %>%
  group_by(TreeVarietyName) %>%
  mutate(n_treevar = sum(n)) %>%
  filter(n_treevar > 0) %>%
  mutate(percent = (n/n_treevar) * 100) %>%
  group_by(TreeVarietyName) %>%
  mutate(value_tmp = if_else(TreeDeath == 0, percent, NA_real_),value2 = mean(value_tmp, na.rm=TRUE)) %>%
  ggplot() +
  geom_bar(aes(x = reorder(TreeVarietyName, -value2), y=percent, fill=as.factor(TreeDeath)),stat="identity") +
  geom_text(aes(x = TreeVarietyName, y=percent, label=round(percent,2)), vjust=-0.75) +
  coord_flip() + 
  theme_minimal() +
  labs(title = "Beyer Orchard Tree Death Trees Ranked By Tree Death Rate", subtitle="Year: 2013", x="Tree Variety", y="Percent") +
  guides(fill=guide_legend(title="Tree Death: 1 = Yes, 0 = No")) +
  scale_fill_manual(values=c("green","red"))

  


# Count of Tree Deaths By Tree Location Column in the Orchard 2013

treedata_joined %>% 
  group_by(Column,TreeDeath) %>% 
  summarise(n = n()) %>%
  ungroup %>% 
  complete(Column, TreeDeath, fill=list(n=0)) %>%
  group_by(Column) %>%
  mutate(n_treevar = sum(n)) %>%
  filter(n_treevar > 0) %>%
  mutate(percent = (n/n_treevar) * 100) %>%
  group_by(Column) %>%
  mutate(value_tmp = if_else(TreeDeath == 0, percent, NA_real_),value2 = mean(value_tmp, na.rm=TRUE)) %>%
  ggplot() +
  geom_bar(aes(x = reorder(Column, -value2), y=percent, fill=as.factor(TreeDeath)),stat="identity") +
  geom_text(aes(x = Column, y=percent, label=round(percent,2)), vjust=-0.75) +
  coord_flip() + 
  theme_minimal() +
  labs(title = "Beyer Orchard Tree Death Location Columns Ranked By Tree Death Rate", subtitle="Year: 2013", x="Tree Location Column", y="Percent") +
  guides(fill=guide_legend(title="Tree Death: 1 = Yes, 0 = No"))




# Count of Tree Deaths By Tree Variety in the Orchard 2013

treedata_joined %>% 
  group_by(Column,TreeDeath) %>% 
  summarise(n = n()) %>% 
  ggplot() + 
  geom_bar(aes(x=reorder(Column,n), y=n, fill=as.factor(TreeDeath)),stat="identity") + 
  geom_text(aes(x = Column, y=n, label=n), position=position_dodge(width=0.9), vjust=-0.5) +
  theme_minimal() +
  coord_flip() + 
  labs(title = "Beyer Orchard 2013 Tree Death vs. Alive Count By Location Column", x= "Tree Location Column", y="Count") +
  guides(fill=guide_legend(title="Tree Death: 1 = Yes 0 = No"))



