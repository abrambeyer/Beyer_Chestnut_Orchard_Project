# Beyer_Chestnut_Orchard_Project

## Project Overview:

##### My father is a hobby chestnut farmer.  His orchard is in the early development stage.  I built him a suite of tools to help manage his orchard and make the best planning decisions possible about what trees he currently has, which trees are performing the best, how to quickly find and track trees of interest, and other adhoc data questions he may have over the years.  The data is stored in an Access database I designed and built from scratch.  Adhoc data questions are answered mainly with adhoc R scripts, RMarkdown reports, and a Tableau dashboard on Tableau public.

- **Access Database** 
  - Built an Access Database from scratch.  This database tracks, tree location, tree events (plantings, death, trimming, fertilization, etc.), tree varieties, etc.  This is a local datbase and not available to view in this repo.  Although, I have included an image of the ER Diagram down below.
- **R Project**
  - *Adhoc Exploratory Data Analysis*:  Several R scripts for answering one-off questions.  The R scripts make the answers easy to reproduce and update as more data is added to the database. 
  - *RMarkdown Files*:  Currently, these RMarkdown reports are pre-designed to quickly allow my father to identify overall turnover in his field, what trees are currently alive/dead in the field, where are each tree variety in his field, any special notes he has attached to a tree (any experiments or trees of concern).
- **Tableau Dashboard**
  - I built a high-level overview dashboard to accompany this suite of tools.  The dashboard gives my father insight into avg. cost per variety, death rates, yearly plantings and deaths so he can better plan for next years and understand how many trees he should be replacing and which variety will do best.
- **Excel**
  - Provides a simple way to record the data and mass insert into Access.  Walking the field with a tablet with Excel installed.  Return to the local machine and mass insert new data points.  
  
 
## Tools Used In This Project
- **R Version:** 3.5.3
- **R Packages:** tidyverse, RODBC,ggalt,ggthemes,RColorBrewer,zoo,eeptools,readxl,stringr
- **Excel**
- **Tableau** 2020.1.4
 

## Access Database ER Diagram 
<img src="https://github.com/abrambeyer/Beyer_Chestnut_Orchard_Project/blob/main/er_diagram.PNG" width="500">

## RMarkdown Report Examples

##### I created a series of RMarkdown reports for my father so he can quickly regenerate current-situation views of his orchard in terms of tree variety, tree age, specially-noted trees, dead tree locations, etc.

##### **NOTE ABOUT THE COLOR CHOICES I MADE**:  I understand some people may not like using red, green color-coding.  However, my father has physically painted every tree in his orchard to mark the tree variety.  The colors on these reports represent the actual line of paint on the tree trunk.  Colossal = red, for example.  When you're standing next to the tree, there is a line of red around its trunk so he can quickly remember what kind of chestnut it is.  I believe these colors were determined initially by what he had available at his local hardward store.

Front Field View            |  Back Field View
:-------------------------:|:-------------------------:
*Tree Variety*
<img src="https://github.com/abrambeyer/Beyer_Chestnut_Orchard_Project/blob/main/beyer_orchard_tree_variety_layout1.PNG" width="400">  |  <img src="https://github.com/abrambeyer/Beyer_Chestnut_Orchard_Project/blob/main/beyer_orchard_tree_variety_layout2.PNG" width="400">  
*Tree Age*
<img src="https://github.com/abrambeyer/Beyer_Chestnut_Orchard_Project/blob/main/beyer_orchard_tree_age_layout1.PNG" width="400">  |  <img src="https://github.com/abrambeyer/Beyer_Chestnut_Orchard_Project/blob/main/beyer_orchard_tree_age_layout2.PNG" width="400">



## Tableau Dashboard
##### The purpose of the Tableau dashboard is to give my father a high-level view of his orchard in terms of numbers.  This dashboard is a static view of the current situation in the field in aggregate over all years he has planted chestnuts.  As he adds more data into the database, the numbers will update and give him insights based on all-time data.

## Tableau Demo


### ***Beyer Chestnut Orchards Planning Dashboard***
[Link to Tableau Public Visualization](https://public.tableau.com/profile/abrambeyer#!/vizhome/BeyerChestnutOrchardsPlanningDashboard/BeyerChestnutOrchardsMain)  

<img src="https://github.com/abrambeyer/Beyer_Chestnut_Orchard_Project/blob/main/beyer_chestnut_orchards_planning_dashboard_gif.gif" width="500">
  
