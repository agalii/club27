# required libraries 
library(stringr)


#############################################################################
# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# file name for output .csv
fn_output <- args[1]
# 'data/output/intermediate_backups/wiki_data_cleaned_up.csv'

# read raw data
wiki_data <- read.delim(file = args[2], stringsAsFactors = F, quote = '')
# wiki_data  <- read.delim(file = 'data/raw/dewiki-20170101-persons.tsv', stringsAsFactors = F, quote = '')



#### clean up dates ####
# remove all entries without Geburts- or Sterbedatum
i_non     <- which(nchar(wiki_data$sterbedatum) == 0 | nchar(wiki_data$geburtsdatum) == 0)
wiki_data <- wiki_data[-i_non,]

# remove all vague and before christ entries
rm_indicators <- c('v. Chr.', '\\', '/', 'um', 'zwischen', 'vor', 'nach', 'oder', 'unsicher', 'Jahrhundert', 'Jahrtausend', 'Nullember', 'Monat', 'xxx',  '±')
for (rm in rm_indicators) {
  i_rm_gd <- grep(rm, wiki_data$geburtsdatum, fixed = T)
  i_rm_sd <- grep(rm, wiki_data$sterbedatum, fixed = T)
  i_rm    <- unique(c(i_rm_gd, i_rm_sd))
  if (length(i_rm) > 0) {
    wiki_data <- wiki_data[-i_rm, ]
  }
}

# replace months names by numbers (to be independent from computer's language)
months <- c('Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember')
for (i in 1:length(months)) {
  wiki_data$geburtsdatum <- gsub(months[i], paste(i, '.', sep = ''), wiki_data$geburtsdatum)
  wiki_data$sterbedatum  <- gsub(months[i], paste(i, '.', sep = ''), wiki_data$sterbedatum)
}

wiki_data$geburtsdatum <- gsub('Jänner', '1.', wiki_data$geburtsdatum)
wiki_data$sterbedatum  <- gsub('Jänner', '1.', wiki_data$sterbedatum)

# function to check that only 'valid' character strings are left and remove them
char_check_cleanup <- function(data, valid_strings) {
  check   <- data[grep('[a-zA-Z]+', data)]
  strings <- unique(str_extract(check, '[a-zA-Z]+'))
  if (all(strings %in% valid_strings)) {
    data  <- gsub('[a-zA-Z]', '', data)
    data  <- gsub(' ', '', data)
    return(data)
  } else {
    invalid <- strings[-which(strings %in% valid_strings)]
    print(paste('Invalid strings detected. Please check:', invalid))
  }
}

# 'vermutlich', 'getauft' and 'begraben' are considered OK, 
# anything else should have been eliminated above (rm_indicator) 
val_str <- c('vermutlich', 'getauft', 'begraben')
wiki_data$geburtsdatum <- char_check_cleanup(wiki_data$geburtsdatum, val_str)
wiki_data$sterbedatum  <- char_check_cleanup(wiki_data$sterbedatum, val_str)


write.csv(wiki_data, file = fn_output, row.names = F)
