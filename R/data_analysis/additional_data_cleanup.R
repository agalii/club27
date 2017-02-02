
# The data on sports and instruments stem from wikipedia
# They are used to identify a wide variety of different sub-categories for athletes and musicians
# different possible usage has to be regarded, 
# such as the nouns and adjectives, which makes the procedure kind of messy 

sport <- read.csv(file = 'data/additional/sport.tsv',  sep = '\t', stringsAsFactors = F)
sport <- sport$Sportart

# all lower case and remove unnecessary puntuation, spaces and explanations
# please note that all entries containing a space are removed 
# and the relevent ones have to be added manually again afterwards
sport <- tolower(sport)
sport <- gsub('\\(.+\\)', '', sport)
sport <- gsub(', .+', '', sport)
sport <- gsub(' $', '', sport)
space <- sport[grep(' ', sport)]
sport <- sport[-grep(' ', sport)]

# the data set contains different spellings for sz, so both versions have to be considered
sportss <- sport[grep('ß', sport)]
sport <- gsub('ß', 'ss', sport)
sport <- c(sport, sportss)

# The following were removed above due to spaces
sport <- c(sport, c('badminton','eishockey','football','frisbee','fünfkampf','handball','hockey',
                    'kegeln','rugby','schwertkunst','shaolin','ski','gymnastik','turmspringen','turnen'))

dash  <- sport[grep('-', sport)]
sport <- sport[-grep('-', sport)]

sport <- sport[-which(nchar(sport) < 5)]
sport <- c(sport, 'dame', 'go', 'golf', 'judo', 'polo', 'skat', 'ski', 'bobfahren') 

sport <- sport[-which(sport %in% c('eishockey', 'rollhockey', 'tischtennis', 'beachvolleyball', 'feldhandball', 'poolbillard'))] # doubles with hockey

ers <- sport[grep('en$', sport)]
ers <- gsub('en$', 'er', ers)
ers <- ers[-grep('renner$', ers)]

kämpfer <- sport[grep('kampf$', sport)]
kämpfer <- gsub('kampf$', 'kämpfer', kämpfer)

sport <- c(sport, ers, kämpfer)

ss <- paste(sport, 'spieler$', sep = '')
so <- paste('^', sport, '$', sep = '')

sport_clean <- unique(c(ss, so))

write.csv(sport_clean, file = 'data/additional/sport_clean.csv', row.names = F)




########################
music <- read.table(file = 'data/additional/music.csv', sep = ',', stringsAsFactors = F, quote = '')
music <- as.vector(music[,1])
music <- tolower(music)
music <- music[-grep(' ', music)]
music <- music[-grep('-', music)]
music <- music[-which(nchar(music) <= 5)]
music <- c(music, 'banjo', 'cello', 'geige', 'harfe', 'horn', 'laute', 'leier', 'oboe', 'orgel', 'pauke', 'piano', 'sitar', 'tuba', 'viola', '^bass')

music <- music[-which(music %in% c('bratsche', 'violoncello', 'bassklarinette',
                                   'baritonsaxophon', 'tenorsaxophon', 'sopransaxophon', 'altsaxophon', 
                                   'waldhorn', 'bassgitarre', 'flügelhorn', 'bassklarinettist'))] # double with ratsche cello...

# find all musicpeople
ms     <- paste(music, '.spieler$', sep = '')
mist   <- paste(substr(music, 1, nchar(music)-1), '.?ist$', sep = '')

musice <- music[grep('e$', music)]
mr     <- paste(musice, 'r$', sep = '')

music_clean  <- unique(c(ms, mist, mr))

write.csv(music_clean, file = 'data/additional/music_clean.csv', row.names = F)

