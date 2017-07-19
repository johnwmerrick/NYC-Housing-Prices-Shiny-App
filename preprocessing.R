

setwd("C:/Users/johnw/git_proj/Shiny Project/") 
rm(list=ls()) # to clear the environment for testing

###############################################################
##############  NYC Neighborhood Map Layer  ###################



library(rgdal)
library(maptools)
library(plyr)


# Generates SpatialPolygonsDataFrame for plots:
setwd("C:/Users/johnw/git_proj/Shiny Project/ZIP CODE") 
nyc = readOGR(dsn=".", layer="ZIP_CODE_040114", verbose = FALSE)

# Map the lat and long so Leaflet can plot the data:
nyc_latlon <- spTransform(nyc, CRS("+proj=longlat +datum=WGS84"))

# Merging vpsf & pct data with shapefiles for coloring the plots:
nyc_price <- merge(nyc_latlon, 
                   annual_vpsf, 
                   by.x="ZIPCODE", 
                   by.y="RegionName"
                   )

nyc_pct <- merge(nyc_latlon, 
                 percent_vpsf, 
                 by.x="ZIPCODE", 
                 by.y="RegionName"
                 )


# Saving processed shapefiles to load into Shiny:
setwd("C:/Users/johnw/git_proj/Shiny Project/") 

# dir.create("nyc_price")   # Only need to do this once
writeOGR(obj=nyc_price, 
         dsn="nyc_price", 
         layer="nyc_price", 
         driver="ESRI Shapefile")

# dir.create("nyc_pct")     # Only need to do this once
writeOGR(obj=nyc_pct, 
         dsn="nyc_pct", 
         layer="nyc_pct", 
         driver="ESRI Shapefile")



##### Don't need this, only used to transform shapefile into
##### data frame for plotting in ggplot2 (Leaflet takes the 
##### shapefile directly):

# nyc@data$id = rownames(nyc@data)
# gpclibPermit()
# nyc.points = fortify(nyc, region="id")
# nyc.df = join(nyc.points, nyc@data, by="id")




###############################################################
###################  NYC Pop & Value Stats  ###################


# Extracting POPULATION Value stats for charts: 
nyc_pop_stats <- as.data.frame(nyc_price[,1:36]) %>% 
  mutate(., 
         density=
           round(POPULATION/AREA*10000, 
                 2)) %>% 
  select(., 1, 4:5, 7, 15:37)

setwd("C:/Users/johnw/git_proj/Shiny Project/") 
write.csv(nyc_pop_stats, file = "nyc_pop_stats.csv")


# Extracting POPULATION and AREA for calculation of pop density: 
nyc_pct1 <- as.data.frame(nyc_pct[,1:5]) %>% 
  mutate(., 
         density=
           round(POPULATION/AREA*10000, 
                 2)) %>% 
  select(., 1, 6)

write.csv(nyc_pct1, file = "nyc_pct1.csv")





###############################################################
#######################  Price Data  ##########################

setwd("C:/Users/johnw/git_proj/Shiny Project/Data") 
zip_vpsf <- read.csv("Zip_MedianValuePerSqft_AllHomes.csv")

# Filter for NYC data points:
NYC_vpsf <- zip_vpsf %>%
  filter(., City=="New York")

# Calculate mean annual value per sq. ft (from mthly data):
annual_vpsf <- data.frame(
  NYC_vpsf[,1:2],
  "CountyName"=NYC_vpsf[,6],
  "1996"=rowMeans(NYC_vpsf[,8:16], na.rm = TRUE),
  "1997"=rowMeans(NYC_vpsf[,17:28], na.rm = TRUE),
  "1998"=rowMeans(NYC_vpsf[,29:40], na.rm = TRUE),
  "1999"=rowMeans(NYC_vpsf[,41:52], na.rm = TRUE),
  "2000"=rowMeans(NYC_vpsf[,53:64], na.rm = TRUE),
  "2001"=rowMeans(NYC_vpsf[,65:76], na.rm = TRUE),
  "2002"=rowMeans(NYC_vpsf[,77:88], na.rm = TRUE),
  "2003"=rowMeans(NYC_vpsf[,89:100], na.rm = TRUE),
  "2004"=rowMeans(NYC_vpsf[,101:112], na.rm = TRUE),
  "2005"=rowMeans(NYC_vpsf[,113:124], na.rm = TRUE),
  "2006"=rowMeans(NYC_vpsf[,125:136], na.rm = TRUE),
  "2007"=rowMeans(NYC_vpsf[,137:148], na.rm = TRUE),
  "2008"=rowMeans(NYC_vpsf[,149:160], na.rm = TRUE),
  "2009"=rowMeans(NYC_vpsf[,161:172], na.rm = TRUE),
  "2010"=rowMeans(NYC_vpsf[,173:184], na.rm = TRUE),
  "2011"=rowMeans(NYC_vpsf[,185:196], na.rm = TRUE),
  "2012"=rowMeans(NYC_vpsf[,196:208], na.rm = TRUE),
  "2013"=rowMeans(NYC_vpsf[,209:220], na.rm = TRUE),
  "2014"=rowMeans(NYC_vpsf[,221:232], na.rm = TRUE),
  "2015"=rowMeans(NYC_vpsf[,233:244], na.rm = TRUE),
  "2016"=rowMeans(NYC_vpsf[,245:256], na.rm = TRUE),
  "2017"=rowMeans(NYC_vpsf[,257:261], na.rm = TRUE)) 

# Save CSV file for loading in Shiny app:

write.csv(annual_vpsf, file = "annual_vpsf.csv")



# County-level data
library(data.table)
county_vpsf <- fread("County_MedianValuePerSqft_AllHomes.csv")

# Filter for NYC data points:
NYC_county_vpsf <- county_vpsf %>%
  filter(., State=="NY" & (RegionName=="Kings" | RegionName=="Queens" | 
           RegionName=="New York" | RegionName=="Richmond" | 
           RegionName=="Bronx"))

# Calculate mean annual value per sq. ft (from mthly data):
annual_county_vpsf <- data.frame(
  NYC_county_vpsf[,1:2],
  "CountyName"=NYC_county_vpsf[,6],
  "1996"=rowMeans(NYC_county_vpsf[,8:16], na.rm = TRUE),
  "1997"=rowMeans(NYC_county_vpsf[,17:28], na.rm = TRUE),
  "1998"=rowMeans(NYC_county_vpsf[,29:40], na.rm = TRUE),
  "1999"=rowMeans(NYC_county_vpsf[,41:52], na.rm = TRUE),
  "2000"=rowMeans(NYC_county_vpsf[,53:64], na.rm = TRUE),
  "2001"=rowMeans(NYC_county_vpsf[,65:76], na.rm = TRUE),
  "2002"=rowMeans(NYC_county_vpsf[,77:88], na.rm = TRUE),
  "2003"=rowMeans(NYC_county_vpsf[,89:100], na.rm = TRUE),
  "2004"=rowMeans(NYC_county_vpsf[,101:112], na.rm = TRUE),
  "2005"=rowMeans(NYC_county_vpsf[,113:124], na.rm = TRUE),
  "2006"=rowMeans(NYC_county_vpsf[,125:136], na.rm = TRUE),
  "2007"=rowMeans(NYC_county_vpsf[,137:148], na.rm = TRUE),
  "2008"=rowMeans(NYC_county_vpsf[,149:160], na.rm = TRUE),
  "2009"=rowMeans(NYC_county_vpsf[,161:172], na.rm = TRUE),
  "2010"=rowMeans(NYC_county_vpsf[,173:184], na.rm = TRUE),
  "2011"=rowMeans(NYC_county_vpsf[,185:196], na.rm = TRUE),
  "2012"=rowMeans(NYC_county_vpsf[,196:208], na.rm = TRUE),
  "2013"=rowMeans(NYC_county_vpsf[,209:220], na.rm = TRUE),
  "2014"=rowMeans(NYC_county_vpsf[,221:232], na.rm = TRUE),
  "2015"=rowMeans(NYC_county_vpsf[,233:244], na.rm = TRUE),
  "2016"=rowMeans(NYC_county_vpsf[,245:256], na.rm = TRUE),
  "2017"=rowMeans(NYC_county_vpsf[,257:261], na.rm = TRUE)) 

t_annual_county <- as.data.frame(t(annual_county_vpsf))[4:25,]
setDT(t_annual_county, keep.rownames = TRUE)[]
colnames(t_annual_county) <- c("Year", "Kings", "Queens", 
                               "New_York", "Richmond")

t_annual_county <- t_annual_county %>% 
  mutate("Year" = as.numeric(substr(Year, 2, 5)))

#test=strsplit(t_annual_county[,Xyear], "")[1:22]



# Save CSV file for loading in Shiny app:

write.csv(t_annual_county, file = "t_annual_county.csv")


###############################################################
##################  Percent Change Data  ######################

# Calculate %/CAGR price change
percent_vpsf <- annual_vpsf %>%
  mutate(., 
         "pct_1"=((X2016/X2015)-1)*100,
         "CAGR_2"=((X2016/X2014)**(1/2)-1)*100,
         "CAGR_3"=((X2016/X2013)**(1/3)-1)*100,
         "CAGR_5"=((X2016/X2011)**(1/5)-1)*100,
         "CAGR_10"=((X2016/X2006)**(1/10)-1)*100,
         "CAGR_15"=((X2016/X2001)**(1/15)-1)*100,
         "CAGR_20"=((X2016/X1996)**(1/20)-1)*100
  ) %>% 
  select(., 1:3, 26:32)


# Save CSV file for loading in Shiny app:

write.csv(percent_vpsf, file = "percent_vpsf.csv")


# Calculate %/CAGR price change
percent_county_vpsf <- annual_county_vpsf %>%
  mutate(., 
         "pct_1"=((X2016/X2015)-1)*100,
         "CAGR_2"=((X2016/X2014)**(1/2)-1)*100,
         "CAGR_3"=((X2016/X2013)**(1/3)-1)*100,
         "CAGR_5"=((X2016/X2011)**(1/5)-1)*100,
         "CAGR_10"=((X2016/X2006)**(1/10)-1)*100,
         "CAGR_15"=((X2016/X2001)**(1/15)-1)*100,
         "CAGR_20"=((X2016/X1996)**(1/20)-1)*100
  ) %>% 
  select(., 1:3, 26:32)


# Save CSV file for loading in Shiny app:

write.csv(percent_county_vpsf, file = "percent_county_vpsf.csv")

setwd("C:/Users/johnw/git_proj/Shiny Project/") 

###############################################################
#################    WIP    ##################


# groupedboros <- annual_vpsf %>% 
#   group_by(CountyName)

# boro_vpsf <- annual_vpsf %>% 
#   group_by(., CountyName) %>% 
#   summarize(., mean(X2016))

# manhattan_vpsf <- annual_vpsf %>% 
#   filter(., CountyName=="New York")








###############################################################
#################  NYC Building Permit Data  ##################

dobPermit <- read.csv("DOB_Permit_Issuance.csv")

# Read in building permit data; remove unneeded columns and 
# filter for residential rows:
dobPermit <- dobPermit %>% 
  select(1, 5:7, 12:14, 7:21, 25, 27:28, 48:52) %>% 
  filter(Residential=="YES")

write.csv(dobPermit, file = "dobPermit.csv")

dobPermit <- read.csv("dobPermit.csv")

# Plant to work on this if there is time to expand the scope



###############################################################






