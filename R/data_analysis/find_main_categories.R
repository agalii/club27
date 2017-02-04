##################################################################################################
# properties to clusters/categories
# use only the first mentioned valid property to identify the main cluster 

fn <- 'data/output/intermediate_backups/simplified_properties_wide.csv'
wiki_data <- read.csv(file = fn, stringsAsFactors = F)

# sportspeople
sport <- read.csv(file = 'data/additional/sport_clean.csv',  stringsAsFactors = F)
sport <- unique(as.vector(sport[,1]))

# musicpeople
music  <- read.csv(file = 'data/additional/music_clean.csv',  stringsAsFactors = F)
music  <- unique(as.vector(music[,1]))

cat <- c('musician', 'singer', 'actor', 'athlete', 'politician', 'showbiz', 'author', 'scientist', 'cleric', 'military', 'resistance', 'journalist', 'artist')
att <- list(c('musiker$', 'komponist$', 'dirigent$', 'organist$', 'schlagzeuger$', 'virtuos.?$', music), 
            c('sänger$'), 
            c('schauspieler$', 'theaterspieler$'), 
            c('sportler$', 'läufer$', sport), 
            c('politiker$', 'gouverneur$', 'goveneur$', 'präsident$', 'mdl$', 'mdb$', 'minister$', 'bürgermeister$'), 
            c('moderator$', 'entertainer$', 'regisseur$', 'kamera(mann$|frau$)', 'kabrettist$'), 
            c('autor$', 'schriftsteller$', 'dichter$', 'lyriker$', 'essayist$', 'poet$'), 
            c('wissenschaftler$','mathematiker$', 'olog(e$|$)','forscher$', 'geodät$', 
              'kartograph$', 'historiker$', 'ökonom$', 'geograph$', 'linguist$', 'germanist$', 
              'botaniker$', 'physiker$', 'chemiker$', 'astronom$', 'anatom$', 'mediziner$', 'philosoph$'), 
            c('geistliche(r$|$)', 'bischof$', 'pfarrer$', 'rabbi$', 'imam', 'pastor$', 'kardinal$', 'prediger$', 'missionar$'), 
            c('offizier$', 'general$', 'leutnant$', 'mayor$', 'kommandant$',  
              'admiral$', 'diktator$', 'marshall$', 'kriegsherr$', 'brigadeführer$', 'soldat$'), 
            c('freiheitskämpfer$', 'befreiungskrieg$', 'unabhängigkeitskrieg$', 'revolutionär$', '^rose$', 'regimekritiker$', 'aktivist$', 'aufstand'), 
            c('journalist$', 'berichterstatter$'), 
            c('maler$', 'künstler$', 'zeichner$', 'grafiker$', 'graphiker$', 'skulpturist$', 'bildhauer$', 'karikaturist$')) 


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


# prepare data as needed for stacked_comparison plot ############################
# fn <- 'data/output/main_categories.csv'
# wiki_main <- read.csv(file = fn, stringsAsFactors = F)

fn       <- 'data/output/data_to_plot/aux_data_for_plots.csv'
aux_data <- read.csv(file = fn, stringsAsFactors = F)

club27 <- subset(wiki_main, age == 27)
others <- subset(wiki_main, age != 27)

dist_table <- function(data, aux) {
  cat         <- as.data.frame(table(data), responseName = 'total')
  cat$percent <- 100 * cat$total / sum(cat$total)
  cat         <- merge(cat, aux, by.x = 'data', by.y = 'cat', all = T)
  return(cat)
}

cat_c27    <- dist_table(club27$main, aux_data)
cat_all    <- dist_table(wiki_main$main, aux_data)
cat_others <- dist_table(others$main, aux_data)

# order both data sets according percentage of in-/decrease 
cat_c27$gain <- (cat_c27$percent - cat_all$percent) / cat_all$percent
i_order      <- order(-cat_c27$gain)
cat_c27      <- cat_c27[i_order,] 
cat_all      <- cat_all[i_order,]
cat_others   <- cat_others[i_order,]


write.csv(cat_c27, file = 'data/output/data_to_plot/group_distribution_c27.csv', row.names = F)
write.csv(cat_all, file = 'data/output/data_to_plot/group_distribution_all.csv', row.names = F)
write.csv(cat_others, file = 'data/output/data_to_plot/group_distribution_all_but_c27.csv', row.names = F)

