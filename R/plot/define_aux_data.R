
# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# file name for output .csv
fn_output <- args[1]
# fn_output <- 'data/output/data_to_plot/aux_data_for_plots.csv'

############################################################
# define color ramp and legend names for all groups
cmin <- c(188, 189, 34)  # dark green
clow <- c(219, 219, 141) # light green
chig <- c(174, 199, 232) # light blue
cmax <- c(31, 119, 180)  # dark blue
ColorMax <- rgb(214, 39, 40, maxColorValue = 255)   # dark red
# dark blue - light blue
ColorMHi <- rgb(seq(cmax[1], chig[1], length = 4),  # Red
                seq(cmax[2], chig[2], length = 4),  # Green
                seq(cmax[3], chig[3], length = 4),  # Blue
                maxColorValue = 255)
# light blue - light green
ColorMLo <- rgb(seq(chig[1], clow[1], length = 7), 
                seq(chig[2], clow[2], length = 7),
                seq(chig[3], clow[3], length = 7), 
                maxColorValue = 255)
# light green - dark green 
ColorLow <- rgb(seq(clow[1], cmin[1], length = 4),
                seq(clow[2], cmin[2], length = 4),
                seq(clow[3], cmin[3], length = 4), 
                maxColorValue = 255)

aux_data <- data.frame(cat    = c('resistance', 'athlete', 'singer', 'other', 'military', 'author', 'actor', 
                                  'musician', 'artist', 'journalist', 'cleric', 'showbiz', 'scientist', 'politician'),
                       legend = c('Widerstandskämpfer:in', 'Athlet:in', 'Sänger:in', 'andere', 'Militär', 'Autor:in', 'Schauspieler:in', 
                                  'Musiker:in', 'Künstler:in', 'Journalist:in', 'Geistliche:r', 'Showbiz', 'Wissenschaftler:in', 'Politiker:in'), 
                       color  = c(ColorMax, ColorMHi, ColorMLo[-1], ColorLow[-1]),
                       stringsAsFactors = F)


write.csv(aux_data, file = fn_output, row.names = F)
