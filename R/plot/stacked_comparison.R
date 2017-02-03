library(showtext)
font.add('default', 'fonts/urw-gothic-l-book.ttf')
font.add('ubuntu', 'fonts/Ubuntu-L.ttf') # for special characters only


fn        <- 'data/output/data_to_plot/aux_data_for_plots.csv'
aux_data <- read.csv(file = fn, stringsAsFactors = F)

fn <- 'data/output/main_categories.csv'
wiki_main <- read.csv(file = fn, stringsAsFactors = F)
# str(wiki_main)

club27 <- subset(wiki_main, age == 27)
others <- subset(wiki_main, age != 27)

cat_c27 <- as.data.frame(table(club27$main), responseName = 'total')
# cat_all <- as.data.frame(table(wiki_main$main), responseName = 'total')
cat_all <- as.data.frame(table(others$main), responseName = 'total')

cat_all$percent <- 100 * cat_all$total / sum(cat_all$total)
cat_c27$percent <- 100 * cat_c27$total / sum(cat_c27$total)

cat_all <- merge(cat_all, aux_data, by.x = 'Var1', by.y = 'cat', all = T)
cat_c27 <- merge(cat_c27, aux_data, by.x = 'Var1', by.y = 'cat', all = T)

# order both data sets according percentage of in-/decrease
cat_c27$gain <- (cat_c27$percent - cat_all$percent) / cat_all$percent
i_order <- order(-cat_c27$gain)
cat_all <- cat_all[i_order,]
cat_c27 <- cat_c27[i_order,] 
i_centre <- max(which(cat_c27$gain >= 0))

arrow <- data.frame(x = c(0, -0.25, -0.14, -0.4, 0, 0.4, 0.14, 0.21, 0), 
                    y = c(0, -0.5, 26.5, 26, 39, 25, 26, +0.5, 0))

svg(filename = 'figure_drafts/stacked_comparison_sinus_up_down.svg', width = 10, height = 7, pointsize = 12, onefile = T)
par(mar = c(0, 0, 0, 0), family = 'default') 
showtext.begin() # has to be removed if font in svg needs to changed subsequntly

cat_all$off <- NA
cat_c27$off <- NA

plot(1, 1, type = 'n', xlim = c(-1.5, 13.5), ylim = c(-100, 140), 
     xlab = '', ylab = '', frame.plot = F) #, axes = F)

points(c(-1.23, 13), c(0, 0), type = 'l', lwd = 3, col = rgb(0.3,0.3,0.3))
polygon(0.8*arrow$x-1 , 5+arrow$y, col = rgb(0.8,0.8,0.8), border = rgb(0.8,0.8,0.8), xpd = T)
text(-0.5, 5, 'Höherer Anteil am Club 27', srt = 90, pos = 4)
polygon(-0.8*arrow$x-1 , -5-arrow$y, col = rgb(0.8,0.8,0.8), border = rgb(0.8,0.8,0.8), xpd = T)
text(-0.5, -55.6, 'Geringerer Anteil', srt = 90, pos = 4)

# left and right border for link with sinus polygons
l <- 2.2
r <- 7.8
xp <- seq(l, r, length.out = 20)

# offsets between rectangles and first offset
inter <- 5 
all_off <- inter
c27_off <- inter

for (i in i_centre:1) {
  color <- cat_all$color[i]
  cat_all$off[i] <- all_off
  rect(0, all_off, 2, cat_all$percent[i] + all_off, col = color, border = color, xpd = T)
  
  cat_c27$off[i] <- c27_off
  rect(8, c27_off, 10, cat_c27$percent[i] + c27_off, col = color, border = color, xpd = T)
  
  ytext <- c27_off + cat_c27$percent[i] / 2
  text(10.3, ytext, labels =  cat_c27$legend[i], pos = 4)
  points(c(10, 10.35), c(ytext, ytext), type = 'l', col = color)
  
  # plot sinu wave polygon link
  amp_b  <- (c27_off - all_off) / 2
  yoff_b <- all_off + amp_b
  lambda <- (8.2 - 1.8) * 0.5 * 0.5                        # wave length
  xoff <- 2.4 + lambda / 2
  
  bot <- amp_b*sin(xoff+xp/lambda)+yoff_b
  
  amp_t  <- (cat_c27$percent[i] + c27_off - (cat_all$percent[i] + all_off)) / 2
  yoff_t <- cat_all$percent[i] + all_off + amp_t
  
  top <- rev(amp_t*sin(xoff+xp/lambda) + yoff_t)
  
  zero <- 7.8
  maxc <- 9
  lc <- rgb(zero-cat_c27$gain[i], zero-cat_c27$gain[i], zero-cat_c27$gain[i], maxColorValue = maxc)
  polygon(c(xp, rev(xp)), c(bot, top), col = lc, border = lc, xpd = T)
  
  # for the next step
  all_off <- all_off + cat_all$percent[i] + inter
  c27_off <- c27_off + cat_c27$percent[i] + inter
}

######################################################################
# Up and down 
# start at the bottom ---> bottom needs to be calculated first
all_off <- -sum(inter + cat_all$percent[(i_centre+1):nrow(cat_all)])
c27_off <- all_off
ytext_o <- all_off-12
threshold <- 12

for (i in nrow(cat_c27):(i_centre+1)) {
  color <- cat_all$color[i]
  cat_all$off[i] <- all_off
  rect(0, all_off, 2, cat_all$percent[i] + all_off, col = color, border = color, xpd = T)
  
  cat_c27$off[i] <- c27_off
  rect(8, c27_off, 10, cat_c27$percent[i] + c27_off, col = color, border = color, xpd = T)
  
  # plot label
  ytext <- c27_off + cat_c27$percent[i] / 2
  if ((ytext - ytext_o) > threshold) {
    text(10.3, ytext, labels =  cat_c27$legend[i], pos = 4)
    points(c(10, 10.35), c(ytext, ytext), type = 'l', col = color)
    ytext_o <- ytext
  } else {
    ytext_o <- ytext_o + threshold
    text(10.3, ytext_o, labels =  cat_c27$legend[i], pos = 4)
    points(c(10, 10.35), c(cat_c27$percent[i] + c27_off, ytext_o), type = 'l', col = color) #rgb(0.3,0.3,0.3)
  }
  
  # plot sinu wave polygon link
  amp_b  <- (c27_off - all_off) / 2
  yoff_b <- all_off + amp_b
  lambda <- (8.2 - 1.8) * 0.5 * 0.5                        # wave length
  xoff <- 2.4 + lambda / 2
  
  bot <- amp_b*sin(xoff+xp/lambda)+yoff_b
  
  amp_t  <- (cat_c27$percent[i] + c27_off - (cat_all$percent[i] + all_off)) / 2
  yoff_t <- cat_all$percent[i] + all_off + amp_t
  
  top <- rev(amp_t*sin(xoff+xp/lambda) + yoff_t)
  
  lc <- rgb(zero+cat_c27$gain[i], zero+cat_c27$gain[i], zero+cat_c27$gain[i], maxColorValue = maxc)
  polygon(c(xp, rev(xp)), c(bot, top), col = lc, border = lc, xpd = T)
  
  # for the next step
  all_off <- all_off + cat_all$percent[i] + inter
  c27_off <- c27_off + cat_c27$percent[i] + inter
}

# plot legend
leg_lab <- seq(80, 780, by = 100)
leg_col <- rgb(zero-leg_lab/100, zero-leg_lab/100, zero-leg_lab/100, maxColorValue = maxc)
x1 <- 0
for (i in 1:length(leg_lab)) {
  rect(x1, 135, x1+0.3, 130, col = leg_col[i], border = leg_col[i])
  x1 <- x1 + 0.5
}

showtext.end()
dev.off()

######################################################################
# All to the same direction
# 
# all_off <- 5
# c27_off <- 5
# ytext_o <- -2
# threshold <- 9
# 
# for (i in (i_centre+1):nrow(cat_c27)) {
#   color <- cat_all$color[i]
#   cat_all$off[i] <- -all_off
#   rect(0, -all_off, 2, -(cat_all$percent[i] + all_off), col = color, border = color, xpd = T)
#   
#   cat_c27$off[i] <- -c27_off
#   rect(8, -c27_off, 10, -(cat_c27$percent[i] + c27_off), col = color, border = color, xpd = T)
#   
#   # plot label
#   ytext <- c27_off + cat_c27$percent[i] / 2
#   if ((ytext - ytext_o) > threshold) {
#     text(10.2, -ytext, labels =  cat_c27$legend[i], pos = 4)
#     ytext_o <- ytext
#   } else {
#     ytext_o <- ytext_o + threshold
#     text(10.2, -ytext_o, labels =  cat_c27$legend[i], pos = 4)
#     points(c(10, 10.35), c(-(cat_c27$percent[i] + c27_off), -ytext_o), type = 'l', col = color) #rgb(0.3,0.3,0.3)
#   }
#   
#   # plot sinu wave polygon link
#   amp_b  <- (c27_off - all_off) / 2
#   yoff_b <- all_off + amp_b
#   lambda <- (8.2 - 1.8) * 0.5 * 0.5                        # wave length
#   xoff <- 2.4 + lambda / 2
#   
#   bot <- amp_b*sin(xoff+xp/lambda)+yoff_b
#   
#   amp_t  <- (cat_c27$percent[i] + c27_off - (cat_all$percent[i] + all_off)) / 2
#   yoff_t <- cat_all$percent[i] + all_off + amp_t
#   
#   top <- rev(amp_t*sin(xoff+xp/lambda) + yoff_t)
#   
#   lc <- rgb(zero+cat_c27$gain[i], zero+cat_c27$gain[i], zero+cat_c27$gain[i], maxColorValue = maxc)
#   polygon(c(xp, rev(xp)), c(-bot, -top), col = lc, border = lc, xpd = T)
#   
#   # for the next step
#   all_off <- all_off + cat_all$percent[i] + 5
#   c27_off <- c27_off + cat_c27$percent[i] + 5
# }
# 
# showtext.end()
# dev.off()
