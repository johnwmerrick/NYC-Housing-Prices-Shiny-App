

### global.R ###


library(shiny)
library(shinydashboard)
library(shinythemes)

#library(data.table)
library(dplyr)
#library(tidyr)
#library(DT)

#library(ggplot2)
#library(googleVis)

library(plotly)
library(leaflet)
library(maps)
library(RColorBrewer)
library(ggmap)


###############################################################
####################  Load Data Files  ########################

#setwd("C:/Users/johnw/git_proj/Shiny Project/Data") 
annual_vpsf <- read.csv("annual_vpsf.csv")
percent_vpsf <- read.csv("percent_vpsf.csv")
nyc_pop_stats <- read.csv("nyc_pop_stats.csv")
t_annual_county <- read.csv("t_annual_county.csv")

# Load pop density data frame: 
nyc_pct1 <- read.csv("nyc_pct1.csv")

###############################################################
#################  NYC Zip Code Map Layer  ####################



library(rgdal)
library(maptools)
#library(plyr)

# Load SpatialPolygonsDataFrame for plots:
#setwd("C:/Users/johnw/git_proj/Shiny Project/nyc_price") 
nyc_price <- readOGR(dsn=".", layer="nyc_price", verbose = FALSE)

#setwd("C:/Users/johnw/git_proj/Shiny Project/nyc_pct") 
nyc_pct <- readOGR(dsn=".", layer="nyc_pct", verbose = FALSE)

# Merge density into shapefile for mapping:
nyc_pop <- merge(nyc_pct, 
                 nyc_pct1,  
                 by.x="ZIPCODE", 
                 by.y="ZIPCODE", 
                 duplicateGeoms = TRUE
                 )

#setwd("C:/Users/johnw/git_proj/Shiny Project/") 

###############################################################
######################  Working Calcs  ########################

# pop_stats <- nyc_pop_stats %>% 
#   group_by(COUNTY)
  

# Subsetting top and bottom polygons for mapping:


