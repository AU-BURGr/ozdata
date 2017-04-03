# global setup
rm(list=ls())

# Load oz_metadata
#load(system.file("data/oz_metadata.rda", package = "ozdata"))
load("../../data/oz_metadata.rda")

# TODO: temporarily subsetting for speed. Remove later.
oz_metadata <- data.frame(head(oz_metadata)) %>%
    select(-c(notes, org_description))

group_var <- c("All", unique(oz_metadata$organization))
