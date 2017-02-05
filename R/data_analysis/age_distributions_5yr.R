# cluster age_distributions into 5yr bins

# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# file name for output .csv
# 'data/output/data_to_plot/age_distributions_combis_5yr.csv'
# 'data/output/data_to_plot/age_distributions_main_5yr.csv'
fn_output <- args[1]

# load required data
# load list of categories as used in find_main_cat and find_all_cat
# 'data/additional/attributes_all.RData'
load(file = args[2])
cat <- attributes_all[[1]]

# data set containing age distributions for different categories 
# fn <- 'data/output/data_to_plot/age_distributions_combis.csv'
# fn <- 'data/output/data_to_plot/age_distributions_main.csv'
age_dist <- read.csv(file = args[3], stringsAsFactors = F)



# calculate 5 year bins for better plotting
bins     <- data.frame(bin = seq(0, 125, by = 5))
bins[,c('all', cat, 'other')] <- NA

for (i in 2:nrow(bins)) {
  i_age    <- which(age_dist$age >= bins$bin[i-1] & age_dist$age < bins$bin[i])
  this_bin <- colSums(age_dist[i_age, 2:ncol(age_dist)], na.rm = T)
  bins[i, 2:ncol(bins)] <- this_bin
  #dist[j-1, i+2] <- sum(sub$age[i_age])
}
bins <- bins[-1,]

write.csv(bins, file = fn_output, row.names = F)
