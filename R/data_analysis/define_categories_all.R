


# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# 'data/additional/attributes_all.RData'
fn_output <- args[1]

# sportspeople
# 'data/additional/sport_clean.csv'
sport <- read.csv(file = args[2],  stringsAsFactors = F)
sport <- unique(as.vector(sport[,1]))

# musicpeople
# 'data/additional/music_clean.csv'
music  <- read.csv(file = args[3],  stringsAsFactors = F)
music  <- unique(as.vector(music[,1]))



# attributes to find all categories #########################################
# Unfortunately, these attributes differ slightly from the ones used in 'find_main_categories',
# because secondary properties can also be hidden at the beginning of a word,
# such as Militärpfarrer
cat <- c('musician', 'singer', 'actor', 'athlete', 'politician', 'showbiz', 'author', 'scientist', 'cleric', 'military', 'resistance', 'journalist', 'artist')

att_all <- list(c('musiker', 'komponist', 'dirigent', 'orchester', 'organist', 'schlagzeuger', 'virtuos', music),
                c('sänger'),
                c('schauspieler', 'theaterspieler'),
                c('sportler', 'olympia', 'läufer', sport),
                c('politiker', 'gouverneur', 'governeur', 'präsident', 'mdl', 'mdb', 'minister', 'bürgermeister'),
                c('film', 'fernseh', 'bühne', 'show', 'entertain', 'regisseur', 'kamera(mann|frau)', 'kabrett'),
                c('autor', 'schriftsteller', 'dichter', 'lyriker', 'essayist'),
                c('wissenschaftler','mathematiker', 'olog(e$|$)','forsch', 'geodät', 'kartograph',
                  'historiker', 'ökonom', 'geograph', 'linguist', 'germanist', 'botaniker', 'physiker',
                  'chemiker', 'astronom', 'anatom', 'medizin', 'philosoph'),
                c('geistliche(r$|$)', 'bischof', 'pfarrer', 'rabbi', 'pastor', 'kardinal', 'prediger', 'missionar', 'papst'),
                c('offizier', 'general', 'leutnant', 'mayor', 'kommandant', 'leutnant', 'admiral', 'diktator', 'marschall', 'kriegsherr', 'brigadeführer', 'soldat', 'militär'),
                c('widerstand', 'freiheitskämpfer', 'befreiungskrieg', 'unabhängigkeitskrieg', 'revolutionär', '^rose$', 'regimekritiker', 'aktivist', 'aufstand'),
                c('journalist', 'berichterstatt'),
                c('maler', 'künstler', 'zeichner', 'grafiker', 'graphiker', 'skulptur', 'bildhauer', 'karikatur'))

attributes_all <- list(cat, att_all)

save(attributes_all, file = fn_output)
#############################################################################

