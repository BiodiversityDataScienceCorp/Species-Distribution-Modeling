#gbif.R
#query species current data from GBIF
#clean up the data
#save it to a csv file
#create a map to display the species occurrence points

#list of packages
#see packages.R in src folder

#setting up environment
usethis::edit_r_environ()

#setting up data from GBIF of Habronattus americanus
spiderBackbone<-name_backbone(name="Habronattus americanus")
speciesKey<-spiderBackbone$usageKey

#download occurrence data in csv format
occ_download(pred("taxonKey", speciesKey), format="SIMPLE_CSV")

#Citation Info:  
 # Please always cite the download DOI when using this data.
#https://www.gbif.org/citation-guidelines
#DOI: 10.15468/dl.myvtcu
#Citation:
 # GBIF Occurrence Download https://doi.org/10.15468/dl.myvtcu
  # Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-02-13

#download raw data
d <- occ_download_get('0012238-240202131308920') %>%
  occ_download_import()

View(d)
write_csv(d, "data/rawData.csv")

#cleaning data
fData<-d %>%
  filter(!is.na(decimalLatitude),!is.na(decimalLongitude))

fData<-fData %>%
  filter(countryCode %in% c("US", "CA", "MX"))

fData<-fData %>%
  filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN"))

fData<-fData %>%
  cc_sea(lon="decimalLongitude", lat="decimalLatitude")

#remove duplicates
fData<-fData %>%
  distinct(decimalLongitude, decimalLatitude, speciesKey, datasetKey, .keep_all = TRUE)

#one fell swoop
#  filter(!is.na(decimalLatitude),!is.na(decimalLongitude))
#  filter(countryCode %in% c("US", "CA", "MX"))
#  filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN"))
#  cc_sea(lon="decimalLongitude", lat="decimalLatitude")
#  distinct(decimalLongitude, decimalLatitude, speciesKey, datasetKey, .keep_all = TRUE)

write_csv(fData, "data/cleanedData.csv")
