library(dataRetrieval)
library(readr)
library(usethis)

# downloads NWIS daily mean discharge data
# for Lavaca River near Edna
lavaca <- readNWISdv(siteNumbers = "08164000",
                 parameterCd = "00060",
                 startDate = "1990-01-01",
                 endDate = "2015-01-01",
                 statCd = "00003")

# renames variables
lavaca <- renameNWISColumns(lavaca)


write_csv(lavaca, "data-raw/lavaca.csv")
usethis::use_data(lavaca, overwrite = TRUE)
