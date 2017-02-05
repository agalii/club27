# required libraries 
library(stringr)

# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# file name for output .csv
fn_output <- args[1]
# fn_output <- 'data/output/intermediate_backups/wiki_data_age_test.csv'

# read data
wiki_data <- read.csv(file = args[2], stringsAsFactors = F)
# fn <- 'data/output/intermediate_backups/wiki_data_cleaned_up.csv'


# select entries with dates of the format d.m.Y 
val_form  <- '^\\d{1,2}\\.\\d{1,2}\\.\\d{1,4}$'
i_date    <- intersect(grep(val_form, wiki_data$geburtsdatum), 
                       grep(val_form, wiki_data$sterbedatum))
wiki_data <- wiki_data[i_date, ]

# convert dates
wiki_data$birth <- strptime(wiki_data$geburtsdatum, format = '%e.%m.%Y', tz = 'CET')
wiki_data$death <- strptime(wiki_data$sterbedatum, format = '%e.%m.%Y', tz = 'CET')

# calculate age
age_days      <- difftime(wiki_data$death, wiki_data$birth, units = 'days')
wiki_data$age <- floor(as.numeric(age_days) / 365)

# remove entries with negative age or age above the oldest human ever 
# (122 yr, according to data set)
i_ex <- which(wiki_data$age < 0 | wiki_data$age > 122)
wiki_data <- wiki_data[-i_ex, ]

# check for NAs, should return empty 
i_na <- which(is.na(wiki_data$age))
if (length(i_na) != 0) {
  print('NAs in wiki_data$age! Go to age_calculation.R and check!')
}

i_rm_col  <- which(colnames(wiki_data) %in% c('alternativnamen', 'geburtsdatum', 'sterbedatum'))
wiki_data <- wiki_data[, -i_rm_col]

write.csv(wiki_data, file = fn_output, row.names = F)


