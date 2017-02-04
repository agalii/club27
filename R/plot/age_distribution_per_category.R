
#############################################################################
library(showtext)
font.add('default', 'fonts/urw-gothic-l-book.ttf')
font.add('ubuntu', 'fonts/Ubuntu-L.ttf') # for special characters only

# read required data
fn <- 'data/output/data_to_plot/age_distributions_combis.csv'
age_dist <- read.csv(file = fn, stringsAsFactors = F)
fn <- 'data/output/data_to_plot/age_distributions_combis_5yr.csv'
bins     <- read.csv(file = fn, stringsAsFactors = F)

fn        <- 'data/output/data_to_plot/aux_data_for_plots.csv'
aux_data <- read.csv(file = fn, stringsAsFactors = F)



svg_name <- 'figure_drafts/age_dist_combi_pillars.svg'
svg(filename = svg_name, width = 10, height = 7, pointsize = 12, onefile = T)
par(mfrow = c(2, 1), oma = c(1, 0, 0.5, 0), mar = c(3, 3, 0, 1), family = 'default') 
showtext.begin() # has to be removed if font in svg needs to changed subsequntly

######################################################### plot I
# plot entire age range in 5yr bins
plot(1, 1, type = 'n', xlim = c(0, 123), ylim = c(0, 20), 
     xlab = '', ylab = '', frame.plot = F, axes = F)

text(-3.6, 19, labels = 'Lebenserwartung verschiedener Gruppen (in % pro 5-Jahrescluster)', pos = 4, xpd = T)

for (line in seq(0, 16, by = 4)) {
  points(c(-3.6, 120), rep(line, 2), lty = 2, col = rgb(0.8,0.8,0.8), lwd = 1, type = 'l')
  text(-3.6, line, labels = line, col = rgb(0.8,0.8,0.8), pos = 2, xpd = T)
}
axis(1, at = seq(0, 120, by = 20), mgp = c(3,0.5,0), lwd.ticks = 0, line = 0.5)

rect(25, -0.2, 29, 16.2, col = rgb(0.9,0.9,0.9), border = NA)

# add lines for age distributions of all groups. 
# order was changed in a way to print most important groups (4:1) last for better visibility
for (i in c(5:nrow(aux_data), 4:1)) {
  i_col   <- which(colnames(bins) == aux_data$cat[i])
  percent <- 100*bins[, i_col]/sum(bins[, i_col])
  points(bins$bin-3, percent, col = aux_data$color[i], lwd = 2, type = 'l')
}

# add short explanation
point <- c(bins$bin[6]-3, 100*bins$resistance[6]/sum(bins$resistance))
points(point[1], point[2], col = aux_data$color[1], pch = 19)
points(c(22, point[1]), c(6.5, point[2]), col = aux_data$color[1], type = 'l')
text(22, 10, labels = '5.0 % aller Widerstands-', pos = 2, cex = 0.8) 
text(22, 8.5, labels = 'kämpfer:innen sterben', pos = 2, cex = 0.8) 
text(22, 7, labels = 'im Alter von 25-30 Jahren', pos = 2, cex = 0.8)


######################################################### plot II
# zoomed in age range in 1yr bins 25 - 29 for relevant groups
ia       <- which(age_dist$age >= 25 & age_dist$age < 30)
relevant <- c('resistance', 'athlete', 'singer')
i_rel    <- which(aux_data$cat %in% relevant)

# summarize all other (non-relevant) groups for comparison
i_other  <- which(colnames(age_dist) %in% aux_data$cat[-i_rel])
age_dist$other2 <- rowSums(age_dist[, i_other])

# adapt auxiliar data respectively
new_aux  <- c('other2', 'Zusammenfassung', aux_data$color[which(aux_data$cat == 'other')])
aux_data <- rbind(aux_data, new_aux)
i_rel    <- c(i_rel, nrow(aux_data))

# empty plot with heading and axes/guides
plot(1, 1, type = 'n', xlim = c(24.5, 35), ylim = c(0, 1.5), 
     xlab = '', ylab = '', frame.plot = F, axes = F)

text(24.3, 1.4, labels = 'Passende Überschrift missing', pos = 4, xpd = T)

for (line in seq(0, 1.2, by = 0.4)) {
  points(c(24.3, 29.5), rep(line, 2), lty = 2, col = rgb(0.8,0.8,0.8), lwd = 1, type = 'l')
  text(24.3, line, labels = line, col = rgb(0.8,0.8,0.8), pos = 2, xpd = T)
}

axis(1, at = c(24.5,29.5), labels = F, mgp = c(3,0.5,0), lwd.ticks = 0, line = 0.5)
axis(1, at = 25:29, tick = F, mgp = c(3,0.5,0), line = 0.5)

# add histogram manually
x_int <- 0.15
x_off <- -1.5 * x_int

for (i in i_rel) {
  i_col <- which(colnames(age_dist) == aux_data$cat[i])
  for (a in ia) {
    percent <- 100*age_dist[a, i_col]/sum(age_dist[, i_col])
    points(rep(age_dist$age[a]+x_off, 2), c(0, percent),
           col = aux_data$color[i], lwd = 8, type = 'l', xpd = T)
    # write percentage of club27
    if (age_dist$age[a] == 27) {
      text(age_dist$age[a]+x_off-0.167, percent+0.07, labels = paste(round(percent, digit = 1), '%'), 
           col = aux_data$color[i], pos = 4, cex = 0.8) 
    }
  }
  x_off <- x_off + x_int
}

# add legends for both plots
text(30, 1.25, labels = 'Gruppen mit überproporzionalem Anteil am Club 27', pos = 4, xpd = T)
legend(30, 1.2, legend = rep('', 3), 
       col = aux_data$color[i_rel[-4]],
       seg.len = 0.8, lwd = 2, bty = 'n', xpd = T)
legend(30.5, 1.2, legend = c(aux_data$legend[i_rel[-4]], 'Zusammenfassung anderer Gruppen'),
       col = aux_data$color[i_rel], 
       seg.len = 0.1, lwd = 8, bty = 'n', xpd = T)

text(30, 0.38, labels = 'Andere Gruppen', pos = 4, xpd = T)
legend(30, 0.47, legend = c(NA, aux_data$legend[4:8]),
       col = c(NA, aux_data$color[4:8]),
       seg.len = 0.8, lwd = 2, bty = 'n', xpd = T)
legend(32.5, 0.47, legend = aux_data$legend[9:14],
       col = aux_data$color[9:14], 
       seg.len = 0.8, lwd = 2, bty = 'n', xpd = T)

showtext.end()
dev.off()

