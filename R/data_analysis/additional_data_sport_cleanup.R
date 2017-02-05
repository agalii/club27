
# The data on sports and instruments stem from wikipedia
# They are used to identify a wide variety of different sub-categories for athletes and musicians
# different possible usage has to be regarded, 
# such as the nouns and adjectives, which makes the procedure kind of messy 


# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# file name for output .csv
fn_output <- args[1]
# fn_output <- 'data/additional/sport_clean.csv'

# 'data/additional/sport.tsv'
sport <- read.csv(file = args[2],  sep = '\t', stringsAsFactors = F)
sport <- sport$Sportart


# all lower case and remove unnecessary punctuation, spaces and explanations
# please note that all entries containing a space are removed 
# and the relevent ones have to be added manually again afterwards
sport <- tolower(sport)
sport <- gsub('\\(.+\\)', '', sport)
sport <- gsub(', .+', '', sport)
sport <- gsub(' $', '', sport)
space <- sport[grep(' ', sport)]
sport <- sport[-grep(' ', sport)]

# The following were removed above due to spaces
sport <- c(sport, c('badminton','football','frisbee','fünfkampf','handball','hockey','kegeln',
                    'rugby','schwertkunst','shaolin','ski','gymnastik','turmspringen','turnen'))

dash  <- sport[grep('-', sport)]
sport <- sport[-grep('-', sport)]

sport <- sport[-which(nchar(sport) < 5)]
sport <- c(sport, 'dame', 'go', 'golf', 'judo', 'polo', 'skat', 'ski', 'bobfahren') 

# sport <- sport[-which(sport %in% c('eishockey', 'rollhockey', 'tischtennis', 'beachvolleyball', 'feldhandball', 'poolbillard'))] # doubles with hockey
# sport <- sport[-which(sport %in% c('rollhockey', 'tischtennis', 'beachvolleyball', 'feldhandball', 'poolbillard'))] # doubles with hockey
sport <- sport[-grep('hockey', sport)]
sport <- sport[-grep('tennis', sport)]
sport <- sport[-grep('volleyball', sport)]
sport <- sport[-grep('handball', sport)]
sport <- sport[-grep('billard', sport)]
sport <- sport[-grep('rugby', sport)]
sport <- sport[-grep('fussball', sport)]
sport <- sport[-grep('fußball', sport)]
sport <- c(sport, 'hockey', 'tennis', 'volleyball', 'handball', 'billard', 'rugby', 'fussball', 'fußball')

ers <- sport[grep('en$', sport)]
ers <- gsub('en$', 'er', ers)
ers <- ers[-grep('renner$', ers)]

kämpfer <- sport[grep('kampf$', sport)]
kämpfer <- gsub('kampf$', 'kämpfer', kämpfer)

sport <- c(sport, ers, kämpfer)

ss <- paste(sport, 'spieler$', sep = '')
so <- paste('^', sport, '$', sep = '')

sport_clean <- unique(c(ss, so))

write.csv(sport_clean, file = fn_output, row.names = F)

