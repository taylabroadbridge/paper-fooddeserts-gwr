
# Read in packages
pacman::p_load(tidyverse, dplyr, readr, readxl, readODS, here)

# Import data
lsoa_data1 <- read_excel(here("data/lsoa-data.xls"), sheet = "iadatasheet1", 
                        skip = 1) %>% dplyr::select(c(1,2),`BAME (%)`)

lsoa_data2 <- read_excel("~/Downloads/lsoa-data.xls", sheet = "iadatasheet2", 
                         skip = 1) %>% dplyr::select(c(1,2),`% No qualifications`,
                                                     `No cars or vans in household (%)`,
                                                     `Median Annual Household Income estimate (£)`)

# Clean data sheets and join
lsoa_data1 <- lsoa_data1 %>% slice(-1) %>%  rename(lsoa_code = ...1, 
                                                 lsoa_name = ...2, 
                                                 BAME_2011_perc = `BAME (%)`)

lsoa_data2 <- lsoa_data2 %>% slice(-1) %>%  rename(lsoa_code = ...1, 
                                                   lsoa_name = ...2, 
                                                   no_qualifications_perc = `% No qualifications`,
                                                   no_cars_perc = `No cars or vans in household (%)`,
                                                   household_median_income = `Median Annual Household Income estimate (£)`) %>%
  mutate(carownership_perc = 100-no_cars_perc) %>%
  dplyr::select(-no_cars_perc)

lsoa_data <- lsoa_data1 %>%
  inner_join(lsoa_data2, by = c("lsoa_code","lsoa_name"))
  

# Read in journey time dataset from DfT, along with Local Authority names & codes
journeytime_lsoa <- read_ods("~/Downloads/jts0507.ods", sheet = "2019", skip = 6) %>% 
  dplyr::select(LSOA_code, LA_Code, LA_Name, FoodPTt, FoodCart, FoodWalkt)

journeytime_lsoa <- journeytime_lsoa %>% rename(lsoa_code = LSOA_code,
                                        la_code = LA_Code,
                                        la_name = LA_Name,
                                        food_pt = FoodPTt,
                                        food_car = FoodCart,
                                        food_walk = FoodWalkt)

# Read in Tesco dataset
year_lsoa_grocery <- read_csv("~/Library/CloudStorage/Box-Box/Data/tesco_model/year_lsoa_grocery.csv") %>%
  dplyr::select(area_id, avg_age, f_dairy, f_eggs, f_fats_oils, f_sweets, f_grains, f_sauces, f_fruit_veg,
                f_fish, f_meat_red, f_poultry, f_readymade, f_soft_drinks) %>% rename(lsoa_code=area_id)


# Merge all three datasets: 
cleaned_data <- lsoa_data %>%
  inner_join(journeytime_lsoa, by = "lsoa_code") %>%
  inner_join(year_lsoa_grocery, by = "lsoa_code")

# Save cleaned data
# Can subsequently run paper-code.Rmd to produce manuscript results 
write.csv(cleaned_data, here("data/cleaned_data.csv"))
