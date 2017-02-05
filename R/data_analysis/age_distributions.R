fn <- 'data/output/all_categories_wide.csv'
wiki_data <- read.csv(file = fn, stringsAsFactors = F)

load(file = 'data/additional/attributes_all.RData')
cat <- attributes_all[[1]]

# get age distribution for all categories
age_dist <- data.frame(age = 1:125)
this     <- as.data.frame(table(wiki_data$age), responseName = 'all')
age_dist <- merge(age_dist, this, by.x = 'age', by.y = 'Var1', all = T)

for (c in c(cat, 'other')) {
  age  <- wiki_data$age[which(wiki_data[, c])]
  this <- as.data.frame(table(age), responseName = c)
  age_dist <- merge(age_dist, this, by = 'age', all = T)
}

age_dist$age <- as.integer(age_dist$age)
age_dist <- age_dist[order(age_dist$age),]

age_dist[is.na(age_dist)] <- 0

write.csv(age_dist, file = 'data/output/data_to_plot/age_distributions_combis.csv', row.names = F)


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

write.csv(bins, file = 'data/output/data_to_plot/age_distributions_combis_5yr.csv', row.names = F)

################################################# same for main categories
fn <- 'data/output/main_categories.csv'
wiki_data <- read.csv(file = fn, stringsAsFactors = F)

load(file = 'data/additional/attributes_all.RData')
cat <- attributes_all[[1]]

# get age distribution for main categories
age_dist <- data.frame(age = 1:125)
this     <- as.data.frame(table(wiki_data$age), responseName = 'all')
age_dist <- merge(age_dist, this, by.x = 'age', by.y = 'Var1', all = T)

for (c in c(cat, 'other')) {
  age  <- subset(wiki_data, main == c, select = 'age')
  this <- as.data.frame(table(age), responseName = c)
  age_dist <- merge(age_dist, this, by = 'age', all = T)
}

age_dist$age <- as.integer(age_dist$age)
age_dist <- age_dist[order(age_dist$age),]

age_dist[is.na(age_dist)] <- 0

write.csv(age_dist, file = 'data/output/data_to_plot/age_distributions_main.csv', row.names = F)


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

write.csv(bins, file = 'data/output/data_to_plot/age_distributions_main_5yr.csv', row.names = F)

