
#############################################################################
library(showtext)
font.add('default', 'fonts/urw-gothic-l-book.ttf')
font.add('ubuntu', 'fonts/Ubuntu-L.ttf') # for special characters only
# library(grid)

# read required data
fn <- 'data/output/data_to_plot/age_distributions_combis.csv'
age_dist <- read.csv(file = fn, stringsAsFactors = F)
fn <- 'data/output/data_to_plot/age_distributions_combis_5yr.csv'
bins     <- read.csv(file = fn, stringsAsFactors = F)

fn        <- 'data/output/data_to_plot/aux_data_for_plots.csv'
aux_data <- read.csv(file = fn, stringsAsFactors = F)


svg(filename = 'figure_drafts/age_dist_combi_pillars.svg', width = 10, height = 7, pointsize = 12, onefile = T)
par(mfrow = c(2, 1), oma = c(1, 0, 0.5, 0), mar = c(3, 5, 0, 2), family = 'default') 
# layout(matrix(c(1:8, 1, 9:15, 1, 16:22, 1, 23:29), ncol = 4, byrow = F), heights = c(0.6, rep(1, 7)))
showtext.begin() # has to be removed if font in svg needs to changed subsequntly

#########################################################
# plot entire age range in 5yr bins
plot(1, 1, type = 'n', xlim = c(0, 125), ylim = c(0, 20), 
     xlab = '', ylab = '', frame.plot = F, axes = F)

for (line in seq(0, 16, by = 4)) {
  points(c(-3.6, 120), rep(line, 2), lty = 2, col = rgb(0.8,0.8,0.8), lwd = 1, type = 'l')
  text(-3.6, line, labels = line, col = rgb(0.8,0.8,0.8), pos = 2, xpd = T)
}

rect(24, -0.5, 30, 10, col = rgb(0.8,0.8,0.8), border = NA)
# basic categories
for (i in 1:nrow(aux_data)) {
  i_col <- which(colnames(bins) == aux_data$cat[i])
  points(bins$bin-2.5, 100*bins[, i_col]/sum(bins[, i_col]), 
         col = aux_data$color[i], lwd = 2, type = 'l')
}

axis(1, at = seq(0, 120, by = 20), mgp = c(3,0.5,0), lwd.ticks = 0, line = 0.5)

#########################################################
# plot zoomed in age range in 1yr bins
# ia <- which(age_dist$age >= 24 & age_dist$age <= 30)
relevant <- c('resistance', 'athlete', 'singer')
i_rel <- which(aux_data$cat %in% relevant)

i_other <- which(colnames(age_dist) %in% aux_data$cat[-i_rel])
age_dist$other2 <- rowSums(age_dist[, i_other])
c_other <- aux_data$color[which(aux_data$cat == 'other')]

plot(1, 1, type = 'n', xlim = c(24.5, 33.5), ylim = c(0, 1.5), 
     xlab = '', ylab = '', frame.plot = F, axes = F)


for (line in seq(0, 1.2, by = 0.4)) {
  points(c(24.3, 29.5), rep(line, 2), lty = 2, col = rgb(0.8,0.8,0.8), lwd = 1, type = 'l')
  text(24.3, line, labels = line, col = rgb(0.8,0.8,0.8), pos = 2, xpd = T)
}

# pillars ###########################################
# rect(26.8, -0.1, 27.2, 1, col = rgb(0.8,0.8,0.8), border = NA)
ia <- which(age_dist$age >= 25 & age_dist$age < 30)
x_int <- 0.15
x_off <- -1.5 * x_int

# basic categories
for (i in rev(i_rel)) {
  i_col <- which(colnames(age_dist) == aux_data$cat[i])
  for (a in ia) {
    points(rep(age_dist$age[a]+x_off, 2), c(0, 100*age_dist[a, i_col]/sum(age_dist[, i_col])),
           col = aux_data$color[i], lwd = 8, type = 'l', xpd = T)
  }
  x_off <- x_off + x_int
}

for (a in ia) {
  points(rep(age_dist$age[a]+x_off, 2), c(0, 100*age_dist$other2[a]/sum(age_dist$other2)),
         col = c_other, lwd = 8, type = 'l', xpd = T)
}

legend(29.9, 1.42, legend = aux_data$legend, col = aux_data$color, 
       seg.len = 0.7, lwd = 2, ncol = 2, bty = 'n', x.intersp = 0.7, y.intersp = 1, xpd = T)
legend(30, 0.32, legend = c(aux_data$legend[rev(i_rel)], 'andere'), 
       col = c(aux_data$color[rev(i_rel)], c_other), 
       seg.len = 0.1, lwd = 8, ncol = 1, bty = 'n', x.intersp = 1.5, y.intersp = 1, xpd = T)

axis(1, at = c(24.5,29.5), labels = F, mgp = c(3,0.5,0), lwd.ticks = 0, line = 0.5)
axis(1, at = 25:29, tick = F, mgp = c(3,0.5,0), line = 0.5)

# pillars ###########################################

showtext.end()
dev.off()

