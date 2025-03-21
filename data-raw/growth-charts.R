## code to prepare growth charts data:

# Data source: https://www.cdc.gov/growthcharts/cdc-data-files.htm
files  <- list.files("data-raw/data/growth-charts", full.names = TRUE)
filenames <- sub(
  "\\.[a-zA-Z0-9]*$", "", list.files("data-raw/data/growth-charts")
)
files <- setNames(files, filenames)
growth_charts <- lapply(files, read.csv)

# Children:
weight_for_age_children <- growth_charts$wtage
height_for_age_children <- growth_charts$statage
bmi_for_age_children <- growth_charts$bmiagerev
weight_for_height_children <- growth_charts$wtstat

# Infants:
weight_for_age_infants <- growth_charts$wtageinf
height_for_age_infants <- growth_charts$lenageinf
weight_for_height_infants <- growth_charts$wtleninf

# Combine children and infant data sets:
weight_for_age <- rbind(
  subset(weight_for_age_infants, Agemos < 36),
  subset(weight_for_age_children, Agemos > 36)
)
weight_for_age <- weight_for_age[
  order(weight_for_age$Sex, weight_for_age$Agemos),
]

height_for_age <- rbind(
  subset(height_for_age_infants, Agemos < 36),
  subset(height_for_age_children, Agemos > 36)
)
height_for_age <- height_for_age[
  order(height_for_age$Sex, height_for_age$Agemos),
]

# Standardize names:
names(weight_for_age)[names(weight_for_age) == "Sex"] <- "sex"
names(height_for_age)[names(height_for_age) == "Sex"] <- "sex"
names(bmi_for_age_children)[names(bmi_for_age_children) == "Sex"] <- "sex"
names(weight_for_height_infants)[names(weight_for_height_infants) == "Sex"] <- "sex"
names(weight_for_height_children)[names(weight_for_height_children) == "Sex"] <- "sex"
names(weight_for_age)[names(weight_for_age) == "Agemos"] <- "age"
names(height_for_age)[names(height_for_age) == "Agemos"] <- "age"
names(bmi_for_age_children)[names(bmi_for_age_children) == "Agemos"] <- "age"
names(weight_for_height_infants)[names(weight_for_height_infants) == "Length"] <- "height"
names(weight_for_height_children)[names(weight_for_height_children) == "Height"] <- "height"

usethis::use_data(
  weight_for_age,
  height_for_age,
  bmi_for_age_children,
  weight_for_height_infants,
  weight_for_height_children,
  overwrite = TRUE
)
