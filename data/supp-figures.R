# Supplementary figures code 
# Representativenss and transaction volume


pacman::p_load(tidyverse, tidymodels, dplyr, readr,
               sf, spdep, tmap, readxl, here, GWmodel, RColorBrewer)

tesco_data <- read_csv("~/Library/CloudStorage/Box-Box/Data/tesco_model/year_lsoa_grocery.csv") %>%
  rename(lsoa_code = area_id)

# read in shapefile 
map_lsoa <- st_read(here("data/shapefiles/LSOA_boundaries_2011_london.shp")) %>% 
  rename(lsoa_code = LSOA11CD)


# join dataframes together 
tesco_polygon <- inner_join(map_lsoa, tesco_data)


tm_shape(tesco_polygon) + 
  tm_polygons("representativeness_norm", fill.scale = tm_scale_intervals(values=c("#e5f5e0","#31a354"),breaks=c(0,0.1,1)), 
              col_alpha=0, tm_legend(title="",frame=FALSE, position=c("right","top"))) +
  tm_layout(frame = FALSE, legend.text.size=1.2, legend.reverse = TRUE) 


tm_shape(tesco_polygon) + 
  tm_polygons("num_transactions", fill.scale = tm_scale_continuous(values = "brewer.greens"), 
              col_alpha=0, tm_legend(title="",frame=FALSE)) +
  tm_layout(frame = FALSE,legend.text.size=1.2, legend.reverse = TRUE)




