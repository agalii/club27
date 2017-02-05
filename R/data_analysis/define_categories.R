
# sportspeople
sport <- read.csv(file = 'data/additional/sport_clean.csv',  stringsAsFactors = F)
sport <- unique(as.vector(sport[,1]))

# musicpeople
music  <- read.csv(file = 'data/additional/music_clean.csv',  stringsAsFactors = F)
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
              'admiral$', 'diktator$', 'marshall$', 'kriegsherr$', 'brigadeführer$', 'soldat$'), 
            c('freiheitskämpfer$', 'befreiungskrieg$', 'unabhängigkeitskrieg$', 'revolutionär$', '^rose$', 'regimekritiker$', 'aktivist$', 'aufstand'), 
            c('journalist$', 'berichterstatter$'), 
            c('maler$', 'künstler$', 'zeichner$', 'grafiker$', 'graphiker$', 'skulpturist$', 'bildhauer$', 'karikaturist$')) 

attributes_main <- list(cat, att_main)
save(attributes_main, file = 'data/additional/attributes_main.RData')

# attributes to find all categories #########################################
# Unfortunately, these attributes differ slightly from the ones used in 'find_main_categories',
# because secondary properties can also be hidden at the beginning of a word,
# such as Militärpfarrer
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
                c('offizier', 'general', 'leutnant', 'mayor', 'kommandant', 'leutnant', 'admiral', 'diktator', 'marshall', 'kriegsherr', 'brigadeführer', 'soldat', 'militär'),
                c('widerstand', 'freiheitskämpfer', 'befreiungskrieg', 'unabhängigkeitskrieg', 'revolutionär', '^rose$', 'regimekritiker', 'aktivist', 'aufstand'),
                c('journalist', 'berichterstatt'),
                c('maler', 'künstler', 'zeichner', 'grafiker', 'graphiker', 'skulptur', 'bildhauer', 'karikatur'))

attributes_all <- list(cat, att_all)
save(attributes_all, file = 'data/additional/attributes_all.RData')
#############################################################################