# 1. age_distribution for groups, considering all groups a person belongs to
# 2. age_distribution for groups, considering all groups a person belongs to


# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# file name for output .svg
fn_output <- args[1]

# should main category or all categories be considered: main or all
criteria <- args[2]

# load required data
# load list of categories as used in find_main_cat and find_all_cat
# 'data/additional/attributes_all.RData'
load(file = args[3])
cat <- attributes_all[[1]]

# data set containing either main or all categories per entry 
# fn <- 'data/output/all_categories_wide.csv'
# fn <- 'data/output/main_categories.csv'
wiki_data <- read.csv(file = args[4], stringsAsFactors = F)





# get age distribution of all entries
age_dist <- data.frame(age = 1:125)
this     <- as.data.frame(table(wiki_data$age), responseName = 'all')
age_dist <- merge(age_dist, this, by.x = 'age', by.y = 'Var1', all = T)

# get age distribution for all categories depending on criterion 'all' or 'main'
for (c in c(cat, 'other')) {
  if (criteria == 'all') {
    age      <- wiki_data$age[which(wiki_data[, c])]
  } else {
    age      <- subset(wiki_data, main == c, select = 'age')
  }
  this       <- as.data.frame(table(age), responseName = c)
  age_dist   <- merge(age_dist, this, by = 'age', all = T)
}

age_dist$age <- as.integer(age_dist$age)
age_dist     <- age_dist[order(age_dist$age),]
age_dist[is.na(age_dist)] <- 0

# fn <- 'data/output/data_to_plot/age_distributions_combis.csv'
# fn <- 'data/output/data_to_plot/age_distributions_main.csv'
write.csv(age_dist, file = fn_output, row.names = F)



#########################################################










