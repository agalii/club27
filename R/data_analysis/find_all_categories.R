
#############################################################################
# properties to clusters, identify all clusters per entry
# note that the list of attributes slightly differs from the one used for main clusteridentification
fn <- 'data/output/intermediate_backups/simplified_properties_wide.csv'
wiki_data <- read.csv(file = fn, stringsAsFactors = F)

# sportspeople
sport <- read.csv(file = 'data/additional/sport_clean.csv',  stringsAsFactors = F)
sport <- unique(as.vector(sport[,1]))

# musicpeople
music  <- read.csv(file = 'data/additional/music_clean.csv',  stringsAsFactors = F)
music  <- unique(as.vector(music[,1]))

# Jurist, arzt, psychologe/psychoanalytike/psychater, Architekt, Ingenieur, Richter, Diplomat, adliger
cat <- c('musician', 'singer', 'actor', 'athlete', 'politician', 'showbiz', 'author', 'scientist', 'cleric', 'military', 'resistance', 'journalist', 'artist')
att <- list(c('musiker', 'komponist', 'dirigent', 'orchester', 'organist', 'schlagzeuger', 'virtuos', music), 
            c('sänger'), 
            c('schauspieler', 'theaterspieler'), 
            # c('tänzer'),
            c('sportler', 'olympia', 'läufer', sport), 
            c('politiker', 'gouverneur', 'governeur', 'präsident', 'mdl', 'mdb', 'minister', 'bürgermeister'), 
            c('film', 'fernseh', 'bühne', 'show', 'entertain', 'regisseur', 'kamera(mann|frau)', 'kabrett'), 
            c('autor', 'schriftsteller', 'dichter', 'lyriker', 'essayist'), 
            c('wissenschaftler','mathematiker', 'olog(e$|$)','forsch', 'geodät', 'kartograph', 
              'historiker', 'ökonom', 'geograph', 'linguist', 'germanist', 'botaniker', 'physiker', 
              'chemiker', 'astronom', 'anatom', 'medizin', 'philosoph'), 
            c('geistliche(r$|$)', 'bischof', 'pfarrer', 'rabbi', 'pastor', 'kardinal', 'prediger', 'missionar', 'papst'), 
            c('offizier', 'general', 'leutnant', 'mayor', 'kommandant', 'leutnant', 'admiral', 'diktator', 'marshall', 'kriegsherr', 'brigadeführer', 'soldat', 'militär'), 
            c('widerstand', 'freiheitskämpfer', 'befreiungskrieg', 'unabhängigkeitskrieg', 'revolutionär', '^rose$', 'regimekritiker', 'aktivist', 'aufstand'), 
            c('journalist', 'berichterstatt'), 
            c('maler', 'künstler', 'zeichner', 'grafiker', 'graphiker', 'skulptur', 'bildhauer', 'karikatur')) # c('holocaust', '$kriegsjustiz') + 'opfer')


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

write.csv(wiki_data, file = 'data/output/properties_wide.csv', row.names = F)


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
