
# read raw data
input_file <- 'data/raw/dewiki-20170101-persons.tsv'
wiki_data  <- read.delim(input_file, stringsAsFactors = F, quote = '')

#### clean up dates ####
# remove all entries without Geburts- or Sterbedatum
i_non     <- which(nchar(wiki_data$sterbedatum) == 0 | nchar(wiki_data$geburtsdatum) == 0)
wiki_data <- wiki_data[-i_non,]
rm(i_non)

# remove all vague and before christ entries
rm_indicators <- c('v. Chr.', '\\', '/', 'um', 'zwischen', 'vor', 'nach', 'oder', 'unsicher', 'Jahrhundert', 'Jahrtausend', 'Nullember', 'Monat', 'xxx',  '±')
for (rm in rm_indicators) {
  i_rm_gd <- grep(rm, wiki_data$geburtsdatum, fixed = T)
  i_rm_sd <- grep(rm, wiki_data$sterbedatum, fixed = T)
  i_rm <- unique(c(i_rm_gd, i_rm_sd))
  if (length(i_rm) > 0) {
    wiki_data <- wiki_data[-i_rm, ]
  }
}
rm(i_rm_gd, i_rm_sd, i_rm, rm)
# maybe implement a check of significance for all 'oder' entries 
# and keep all cases where it doesn't impact the lifespan of a person
# 'um' entries with a proper date might be used anyway...
# alternatively bc entries could be flegged to properly calulate age

# replace months names by numbers (necessary because my computer's language is english)
months <- c('Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember')
for (i in 1:length(months)) {
  wiki_data$geburtsdatum <- gsub(months[i], paste(i, '.', sep = ''), wiki_data$geburtsdatum)
  wiki_data$sterbedatum  <- gsub(months[i], paste(i, '.', sep = ''), wiki_data$sterbedatum)
}

wiki_data$geburtsdatum <- gsub('Jänner', '1.', wiki_data$geburtsdatum)
wiki_data$sterbedatum  <- gsub('Jänner', '1.', wiki_data$sterbedatum)

# check for remaining cases of characters that don't belong to the date
# 'vermutlich', 'getauft' and 'begraben' are considered OK, 
# anything else should have been eliminated above (rm_indicator) 
library(stringr)

# function to check that only 'valid' character strings are left and remove them
char_check_cleanup <- function(data, valid_strings) {
  check   <- data[grep('[a-zA-Z]+', data)]
  strings <- unique(str_extract(check, '[a-zA-Z]+'))
  if (all(strings %in% valid_strings)) {
    data  <- gsub('[a-zA-Z]', '', data)
    data  <- gsub(' ', '', data)
    # ugly work around, find regular expression for '.'
    data <- gsub('.', ' ', data, fixed = T)
    return(data)
  }
  else {
    invalid <- strings[-which(strings %in% valid_strings)]
    print(paste('Invalid strings detected. Please check:', invalid))
  }
}

val_str <- c('vermutlich', 'getauft', 'begraben')
wiki_data$geburtsdatum <- char_check_cleanup(wiki_data$geburtsdatum, val_str)
wiki_data$sterbedatum  <- char_check_cleanup(wiki_data$sterbedatum, val_str)

fn <- 'data/output/intermediate_backups/wiki_data_cleaned_up.csv'
write.csv(wiki_data, file = fn, row.names = F)

#############################################################################
wiki_data <- read.csv(file = fn,  stringsAsFactors = F)

# select entries with dates of the format d m y 
val_form  <- '^\\d{1,2}\\s\\d{1,2}\\s\\d{1,4}$'
i_date    <- intersect(grep(val_form, wiki_data$geburtsdatum), 
                       grep(val_form, wiki_data$sterbedatum))
wiki_data <- wiki_data[i_date, ]

# convert dates
wiki_data$birth <- strptime(wiki_data$geburtsdatum, format = '%e %m %Y', tz = 'CET')
wiki_data$death <- strptime(wiki_data$sterbedatum, format = '%e %m %Y', tz = 'CET')

# calculate age
age_days      <- difftime(wiki_data$death, wiki_data$birth, units = 'days')
wiki_data$age <- floor(as.numeric(age_days) / 365)

# remove entries with negative age or age above the oldest human ever 
# (122 yr, according to data set)
i_ex <- which(wiki_data$age < 0 | wiki_data$age > 122)
wiki_data <- wiki_data[-i_ex, ]

# check for NAs, should return empty 
i_na <- which(is.na(wiki_data$age))
wiki_data$birth[i_na]
wiki_data$death[i_na]
wiki_data[i_na, ]

i_rm_col  <- which(colnames(wiki_data) %in% c('alternativnamen', 'geburtsdatum', 'sterbedatum'))
wiki_data <- wiki_data[, -i_rm_col]

fn <- 'data/output/intermediate_backups/wiki_data_age.csv'
write.csv(wiki_data, file = fn, row.names = F)
