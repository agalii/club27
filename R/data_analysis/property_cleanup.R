#############################################################################
# remove unnecessary stuff from 'kurzbeschreibung'
# split 'kurzbeschreibung' into single properties
# simplify properties by removing gender, case, etc. endings



# get input arguments from makefile #########################################
args <- commandArgs(trailingOnly = T)

# file name for output .csv
fn_output <- args[1]
# fn_output <- 'data/output/intermediate_backups/simplified_properties_wide.csv'

# load data
wiki_data <- read.csv(file = args[2], stringsAsFactors = F)
# wiki_data <- read.csv(file = 'data/output/intermediate_backups/wiki_data_age.csv', stringsAsFactors = F)


#############################################################################
# unify spelling and pre-remove unnecessary properties
short <- wiki_data$kurzbeschreibung
short <- tolower(short)

remove <- c('\\(.+\\)', 'essin$', 'in$', '(^|\\s)us-')
for (rm in remove) {
  short <- gsub(rm, '', short)
} 

remove <- c(', ', '; ', ' und ', ' des ', ' im ', ' von ', ' aus ', ' dem ', 
            ' den ', ' als ', ' eine ', ' ein ', 'essin ', 'in ',
            ' sowie ', ' etc. ',  '/', '\\', '"', ' zum ', '„', '“', 
            ' zur ', ' für ', 'US-', '-', ' wurde ', '^ ', 
            ' am ', ' an ', ' der ', ' beteiligt ', ' das ', ' vermutlich ', 
            ' zuletzt ', '-union ', '-league ', '  ', '^ ')
for (rm in remove) {
  short <- gsub(rm, ' ', short, fixed = T)
}

short <- gsub('-spieler', 'spieler', short, fixed = T)
# short <- gsub('ß', 'ss', short)

# split 'kurzbeschreibung' into single words ---> uncategorized properties
## create empty columns to be filled
columns   <- ncol(wiki_data)
n_property <- 30
wiki_data[, paste('property', 1:n_property, sep = '')] <- NA

for (i in 1:nrow(wiki_data)) {
  cs  <- strsplit(short[i], ' ')[[1]]
  lcs <- length(cs)
  if (lcs > n_property) {
    print(paste('At least', lcs, 'property columns needed!'))
    break
  }
  if (lcs > 0) {
    wiki_data[i, columns + (1:lcs)] <- cs
  }
  if (i %% 10000 == 0) {
    print(paste('Row', i, 'completed'))
  }
}

# cut completely empty columns
while(all(is.na(wiki_data[,ncol(wiki_data)]))) {
  wiki_data <- wiki_data[, -ncol(wiki_data)]
}

# fn <- 'data/output/intermediate_backups/raw_properties_wide.csv'
# write.csv(wiki_data, file = fn, row.names = F)
# #############################################################################
# # unify properties
# wiki_data <- read.csv(file = fn,  stringsAsFactors = F)

## apply columnwise
ip <- which(substr(colnames(wiki_data), 1, 8) == 'property')

# unify adjectives
adjectiv1 <- c('licher$', 'lichem$', 'lichen$', 'liches$', 'liche$')
adjectiv2 <- c('ischer$', 'ischem$', 'ischen$', 'isches$', 'ische$', 
               'ischstämmiger$', 'ischstämmigen$', 'ischstämmige$', 'ischstämmig$')
deutsch <- c('deutscher$', 'deutschem$', 'deutschen$', 'deutsches$', 'deutsche$', 
             'deutschstämmiger$', 'deutschstämmigen$', 'deutschstämmige$', 'deutschstämmig$')

for (p in ip) {
  r <- which(!is.na(wiki_data[ , p]))
  for (a1 in adjectiv1) {
    wiki_data[r , p] <- gsub(a1, 'lich', wiki_data[r , p])
  }
  for (a2 in adjectiv2) {
    wiki_data[r , p] <- gsub(a2, 'isch', wiki_data[r , p])
  }
  for (d in deutsch) {
    wiki_data[r , p] <- gsub(d, 'deutsch', wiki_data[r , p])
  }
  
  # unify arzt/ärztin
  wiki_data[r , p] <- gsub('ärzt$', 'arzt', wiki_data[r , p])
  # american occuring in Eigennamen only
  wiki_data[grep('american', wiki_data[ , p]), p] <- NA
}

write.csv(wiki_data, file = fn_output, row.names = F)
