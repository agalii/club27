


# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# 'data/additional/attributes_main.RData'
fn_output <- args[1]

# sportspeople
# 'data/additional/sport_clean.csv'
sport <- read.csv(file = args[2],  stringsAsFactors = F)
sport <- unique(as.vector(sport[,1]))

# musicpeople
# 'data/additional/music_clean.csv'
music  <- read.csv(file = args[3],  stringsAsFactors = F)
music  <- unique(as.vector(music[,1]))




cat <- c('musician', 'singer', 'actor', 'athlete', 'politician', 'showbiz', 'author', 'scientist', 'cleric', 'military', 'resistance', 'journalist', 'artist')

# attributes to find main categories ########################################
att_main <- list(c('musiker$', 'komponist$', 'dirigent$', 'organist$', 'schlagzeuger$', 'virtuos.?$', music), 
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
                   'admiral$', 'diktator$', 'marschall$', 'kriegsherr$', 'brigadeführer$', 'soldat$'), 
                 c('freiheitskämpfer$', 'befreiungskrieg$', 'unabhängigkeitskrieg$', 'revolutionär$', '^rose$', 'regimekritiker$', 'aktivist$', 'aufstand'), 
                 c('journalist$', 'berichterstatter$'), 
                 c('maler$', 'künstler$', 'zeichner$', 'grafiker$', 'graphiker$', 'skulpturist$', 'bildhauer$', 'karikaturist$')) 

attributes_main <- list(cat, att_main)
save(attributes_main, file = fn_output)

