##################################################################################################
# properties to clusters/categories
# use only the first mentioned valid property to identify the main cluster 

fn <- 'data/output/intermediate_backups/simplified_properties_wide.csv'
wiki_data <- read.csv(file = fn, stringsAsFactors = F)

# load RData, containing categories and attributes to identify groups
load(file = 'data/additional/attributes_main.RData')
cat <- attributes_main[[1]]
att <- attributes_main[[1]]


# apply columnwise, loop through properties
ip <- which(substr(colnames(wiki_data), 1, 8) == 'property')
wd <- wiki_data[, c(1, ip)]

done <- NULL

for (c in 2:ncol(wd)) {
  wd$main  <- NA
  wd$main2 <- NA # main2 only needed to check for ambiguity
  
  for (i in 1:length(cat)) {
    for (a in att[[i]]) {
      i_a  <- grep(a, wd[ , c])  
      i_a1 <- i_a[which(is.na(wd$main[i_a]))]
      i_a2 <- i_a[which(!is.na(wd$main[i_a]))]
      wd$main[i_a1]  <- cat[i]
      wd$main2[i_a2] <- cat[i]
    }
  }
  
  done <- rbind(wd[which(!is.na(wd$main) & is.na(wd$main2)), ], done)
  wd2  <- wd[which(!is.na(wd$main) & !is.na(wd$main2)), ]
  if (nrow(wd2) > 0) {
    print(paste('Second step error within property', c))
    break
  }
  wd   <- wd[which(is.na(wd$main) & is.na(wd$main2)), ]
}

# remaining entries are not covered by defined categories and attributes and summarized as 'others' 
wd$main   <- 'other'
done      <- rbind(wd, done)

wiki_main <- merge(wiki_data[, 1:8], done[, c('title', 'main')], by = 'title', all = T)

write.csv(wiki_main, file = 'data/output/main_categories.csv', row.names = F)

