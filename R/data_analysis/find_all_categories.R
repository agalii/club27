#############################################################################
# properties to clusters, identify all clusters per entry
# note that the list of attributes slightly differs from the one used for main clusteridentification

# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# file name for output .csv
fn_output <- args[1]
# fn_output <- 'data/output/all_categories.csv'

# load required data
# load RData containing categories and attributes to identify groups
load(file = args[2])
# load(file = 'data/additional/attributes_all.RData')
cat <- attributes_all[[1]]
att <- attributes_all[[2]]

# data set containing verbous propreties for each entry
wiki_data <- read.csv(file = args[3], stringsAsFactors = F)
# wiki_data <- read.csv(file = 'data/output/intermediate_backups/simplified_properties_wide.csv', stringsAsFactors = F)



ip <- which(substr(colnames(wiki_data), 1, 8) == 'property')

for (i in 1:length(cat)) {
  wiki_data[, paste(cat[i])] <- F
  
  for (a in att[[i]]) {
    for (p in ip) {
      wiki_data[grep(a, wiki_data[ , p]), paste(cat[i])] <- T
    }
  }
}

# papst occurs later in the kurzbeschreibung of people who had something to do with the pope,
# therefore the special treatment
wiki_data$cleric[which(wiki_data$property1 == 'papst' | wiki_data$property3 == 'papst')] <- T


# find entries that were not categorized and identify them as 'other'
icat <- which(colnames(wiki_data) %in% cat)

categorized <- NULL
for (i in icat) {
  categorized <- c(categorized, which(wiki_data[,i]))
  categorized <- unique(categorized)
}

wiki_data$other <- T
wiki_data$other[categorized] <- F

# check how many different clusters are dedicated to each entry
wiki_data$multiple <- 0
for (i in 1:nrow(wiki_data)) {
  wiki_data$multiple[i] <- length(which(wiki_data[i, icat] == T))
}

write.csv(wiki_data, file = fn_output, row.names = F)


# ###############################################################
# # convert wiki_data into long format
# # not adapted yet
# # install.packages('reshape2')
# library(reshape2)
# keep <- colnames(wiki_data)[c(2,4,6,8,10:12)]
# melted <- melt(wiki_data, id.vars = keep, measure.vars = colnames(wiki_data)[13:ncol(wiki_data)], na.rm = T)
# melted <- melted[-which(melted$value == ''), ]
# 
# write.csv(melted, 'data/output/raw_properties_long.csv', row.names = F)
# 
# 
###############################################################
