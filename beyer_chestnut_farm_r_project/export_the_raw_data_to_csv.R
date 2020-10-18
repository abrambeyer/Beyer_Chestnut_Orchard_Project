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