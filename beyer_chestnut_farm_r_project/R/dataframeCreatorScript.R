library(tidyverse)
library(readxl)

getwd()

treeLocation = read_excel("TreeLocation.xlsx", sheet = "TreeLocation")



treeLocation



sheet2013 = read_excel("Chestnut Lay Out Spread Sheet 2013-14v2.xlsx", sheet="Sheet1", skip=2)


#Create container table
test2 <- tribble(
  ~"TreeLocationID",~"Column", ~"Row",~"TreeVarietyShortName",~"TreeVarietyID",~"TreeSourceID",~"RootVarietyID",~"TreeDeath",~"TreeDeathDate",~'TreePlantDate',~'TreeEndDate'
)


#iterate through farm excel spreadsheet and create rows.
for(i in 16-seq((ncol(sheet2013)-2))){
  for(n in seq(nrow(sheet2013))){
    #print(colnames(sheet2013)[i])
    #print(sheet2013$ROWNAME2[n])
    value <- colnames(sheet2013)[i]
    value2 <- sheet2013[value][n,][[1]]
    #print(value2)
    treelocationrow <- treeLocation %>% filter(Column == colnames(sheet2013)[i] & Row == sheet2013$ROWNAME2[n])
    treelocationid <- treelocationrow$TreeLocationID[[1]]
    #print(treelocationid)
    
    if(is.na(value2) == F & value2 != 'Pecan') {
      if (value2 == "C" | value2 == "C dead" | value2 == "C late" | value2 == "C dead?" | value2 == "C roots" | value2 == "C roots ?" | value2 == "C ?" | value2 == "C  roots" | value2 == "C dead L" | value2 == "C?" | value2 == "roots"){
        varietyid = 1
      } else if (value2 == 'PM' | value2 == "PM dead" | value2 == "PM  dead" | value2 == "PM roots" | value2 == "PM root" | value2 == "PM?" | value2 == "PM ?"){
        varietyid = 4
      } else if (value2 == 'LD' | value2 == "LD dead ?" | value2 == "LD dead" | value2 == "LD ? Root" | value2 == "LD?" | value2 == "LD late" | value2 == "LD ?"){
        varietyid = 3
      } else if (value2 == 'BD' | value2 == "BD ?" | value2 == "BD dead" | value2 == "BD dead?" | value2 == "BD late" | value2 == "BD dead L" | value2 == "BD root" | value2 == "BD?"){
        varietyid = 2
      } else if (value2 == 'unlab'){
        varietyid = 10
      }
      test2 <- add_row(test2,TreeLocationID = treelocationid, Column = colnames(sheet2013)[i], Row = sheet2013$ROWNAME2[n], TreeVarietyShortName=value2,TreeVarietyID = varietyid, TreeSourceID = 1, RootVarietyID = 1,TreeDeath='No',TreeDeathDate='',TreePlantDate='10/17/2013',TreeEndDate='')
    }
    
  }
}

count <- 0
for(i in 16-seq((ncol(sheet2013)-2))){
  for(n in seq(nrow(sheet2013))){
    value <- colnames(sheet2013)[i]
    value2 <- sheet2013[value][n,][[1]]
    if(is.na(value2) == F & value2 != 'Pecan') {
    count <- count + 1
    }
  }
}


unique(sheet2013$G)

test2 %>% 
  select(TreeVarietyShortName) %>% 
  filter(grepl("unlab",TreeVarietyShortName) | grepl("bd",TreeVarietyShortName)) %>% 
  unique()


unique(test2$TreeVarietyShortName)
#view data
View(test2)

#delete table
rm(test2)



head(treeLocation)

write.csv(test2, "data_2013.csv")

