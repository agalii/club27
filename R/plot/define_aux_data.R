
# prelim colors
tableau20 = c(rgb(31, 119, 180, maxColorValue = 255), rgb(174, 199, 232, maxColorValue = 255), 
              rgb(255, 127, 14, maxColorValue = 255), rgb(255, 187, 120, maxColorValue = 255),  
              rgb(44, 160, 44, maxColorValue = 255), rgb(152, 223, 138, maxColorValue = 255), 
              rgb(214, 39, 40, maxColorValue = 255), rgb(255, 152, 150, maxColorValue = 255),  
              rgb(148, 103, 189, maxColorValue = 255), rgb(197, 176, 213, maxColorValue = 255), 
              rgb(140, 86, 75, maxColorValue = 255), rgb(196, 156, 148, maxColorValue = 255),  
              rgb(227, 119, 194, maxColorValue = 255), rgb(247, 182, 210, maxColorValue = 255), 
              rgb(127, 127, 127, maxColorValue = 255), rgb(199, 199, 199, maxColorValue = 255),  
              rgb(188, 189, 34, maxColorValue = 255), rgb(219, 219, 141, maxColorValue = 255), 
              rgb(23, 190, 207, maxColorValue = 255), rgb(158, 218, 229, maxColorValue = 255))  

# plot(1:20, c(1:10, 1:10), pch = 19, col = tableau20, cex = 5)

i_col = c(4, 14, 8, 1, 20, 19, 10, 13, 18, 7, 12, 17, 15, 2)
aux_data <- data.frame(cat    = c('showbiz', 'actor', 'musician', 'singer', 'artist', 'athlete', 'author', 
                                  'journalist', 'military', 'resistance', 'cleric', 'scientist', 'politician', 'other'),
                       legend = c('Showbiz', 'Schauspieler:in', 'Musiker:in', 'Sänger:in', 'Künstler:in', 
                                  'Athlet:in', 'Autor:in', 'Journalist:in', 'Militär', 'Widerstandskämpfer:in', 
                                  'Geistliche:r', 'Wissenschaftler:in', 'Politiker:in', 'andere'), 
                       color  = tableau20[i_col],
                       stringsAsFactors = F)

write.csv(aux_data, file = 'data/output/data_to_plot/aux_data_for_plots.csv', row.names = F)
