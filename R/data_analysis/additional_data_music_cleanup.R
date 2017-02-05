

# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# file name for output .csv
fn_output <- args[1]
# fn_output <- 'data/additional/music_clean.csv'

# 'data/additional/music.csv'
music <- read.table(file = args[2], sep = ',', stringsAsFactors = F, quote = '')

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

write.csv(music_clean, file = fn_output, row.names = F)

