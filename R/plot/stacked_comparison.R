library(showtext)
font.add('default', 'fonts/urw-gothic-l-book.ttf')
font.add('ubuntu', 'fonts/Ubuntu-L.ttf') # for special characters only

# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# file name for output .svg
fn_output <- args[1]

# load required data
# auxiliary data, containing colors and legend labels per group
# 'data/output/data_to_plot/aux_data_for_plots.csv'
aux_data <- read.csv(file = args[2], stringsAsFactors = F)

# data set containing group distributions for club 27
# 'data/output/data_to_plot/group_distribution_c27.csv' 
cat_c27  <- read.csv(file = args[3], stringsAsFactors = F)

# data set containing group distributions for reference group
# either all or all_but_c27
# 'data/output/data_to_plot/group_distribution_all_but_c27.csv'
# 'data/output/data_to_plot/group_distribution_all.csv'
cat_all  <- read.csv(file = args[4], stringsAsFactors = F)


 
# define parameters and functions needed during plotting ################
# index to split figure in gaining and loosing groups
i_center <- max(which(cat_c27$gain >= 0))

# handmade arrow...
arrow <- data.frame(x = c(0, -0.25, -0.14, -0.4, 0, 0.4, 0.14, 0.21, 0), 
                    y = c(0, -0.5, 26.5, 26, 39, 25, 26, +0.5, 0))
# standard grey...
sg    <- rgb(0.8,0.8,0.8)

# color scale transformation function
cstf  <- function(data) {(3-sqrt(abs(data)))/2.9} 

# plot sinus wave polygon to link left and right rectangles
sinus_polygon <- function(c_off, a_off, c_per, a_per, grey_value = 0.8) {
  # left and right border for link with sinus polygons
  l <- 2.2
  r <- 7.8
  xp <- seq(l, r, length.out = 20)
  
  amp_b  <- (c_off - a_off) / 2
  yoff_b <- a_off + amp_b
  lambda <- (8.2 - 1.8) * 0.25  # wave length
  xoff   <- 2.4 + lambda / 2
  bot    <- amp_b*sin(xoff+xp/lambda) + yoff_b
  
  amp_t  <- (c_per + c_off - (a_per + a_off)) / 2
  yoff_t <- a_per + a_off + amp_t
  top    <- rev(amp_t*sin(xoff+xp/lambda) + yoff_t)
  
  lc     <- rgb(grey_value, grey_value, grey_value, maxColorValue = 1)
  
  polygon(c(xp, rev(xp)), c(bot, top), col = lc, border = lc, xpd = T)
}


# ######################################################### plot
# fn_output <- 'figure_drafts/stacked_comparison_up_down.svg'
svg(filename = fn_output, width = 10, height = 7, pointsize = 12, onefile = T)
par(mar = c(0, 0, 0, 0), family = 'default') 
showtext.begin() # has to be removed if font in svg needs to changed subsequntly

cat_all$off <- NA
cat_c27$off <- NA

plot(1, 1, type = 'n', xlim = c(-1.5, 13.5), ylim = c(-95, 145), 
     xlab = '', ylab = '', frame.plot = F, axes = F)

# auxiliar drawings
points(c(-1.23, 13), c(0, 0), type = 'l', lwd = 3, col = rgb(0.3,0.3,0.3))
polygon(0.8*arrow$x-1 , 5+arrow$y, col = sg, border = sg, xpd = T)
text(-0.5, 5, 'Höherer Anteil am Club 27', srt = 90, pos = 4)
polygon(-0.8*arrow$x-1 , -5-arrow$y, col = sg, border = sg, xpd = T)
text(-0.5, -55.6, 'Geringerer Anteil', srt = 90, pos = 4)

# draw rectangles and linking polygons
# offsets between rectangles and first offset
inter <- 5 
all_off <- inter
c27_off <- inter

######################################################################
# plot all groups with INcreased percentage in club 27
for (i in i_center:1) {
  color <- cat_all$color[i]
  cat_all$off[i] <- all_off
  rect(0, all_off, 2, cat_all$percent[i] + all_off, col = color, border = color, xpd = T)
  
  cat_c27$off[i] <- c27_off
  rect(8, c27_off, 10, cat_c27$percent[i] + c27_off, col = color, border = color, xpd = T)
  
  # print label next to rectangle
  ytext <- c27_off + cat_c27$percent[i] / 2
  text(10.3, ytext, labels =  cat_c27$legend[i], pos = 4)
  points(c(10, 10.35), c(ytext, ytext), type = 'l', col = color)
  
  # plot sinus wave polygon link
  sinus_polygon(c27_off, all_off, cat_c27$percent[i], cat_all$percent[i], cstf(cat_c27$gain[i]))
  
  # for the next step
  all_off <- all_off + cat_all$percent[i] + inter
  c27_off <- c27_off + cat_c27$percent[i] + inter
}

text(9, cat_c27$percent[1] + cat_c27$off[1] + 3, labels = 'Club 27', pos = 3, cex = 1.5)
text(1, cat_all$percent[1] + cat_all$off[1] + 3, labels = 'Gesamt', pos = 3, cex = 1.5)

######################################################################
# plot all groups with DEcreased percentage in club 27
# start at the bottom --> bottom offset needs to be calculated first
all_off <- -sum(inter + cat_all$percent[(i_center+1):nrow(cat_all)])
c27_off <- all_off

# compensate for too narrow spaces to properly print labels
# theshold indicates minimum space needed
ytext_o <- all_off-12
threshold <- 12

for (i in nrow(cat_c27):(i_center+1)) {
  color <- cat_all$color[i]
  cat_all$off[i] <- all_off
  rect(0, all_off, 2, cat_all$percent[i] + all_off, col = color, border = color, xpd = T)
  
  cat_c27$off[i] <- c27_off
  rect(8, c27_off, 10, cat_c27$percent[i] + c27_off, col = color, border = color, xpd = T)
  
  # plot labels, either in center of rectangle or one threshold above last one
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
  
  # plot sinu wave polygon link between rectangles
  sinus_polygon(c27_off, all_off, cat_c27$percent[i], cat_all$percent[i], cstf(cat_c27$gain[i]))
  
  # for the next step
  all_off <- all_off + cat_all$percent[i] + inter
  c27_off <- c27_off + cat_c27$percent[i] + inter
}

# plot legend for grey scale manually #####################################
leg_lab <- c(3, 30, 60, 90, 300, 780)

leg_col <- rgb(cstf(leg_lab/100), cstf(leg_lab/100), cstf(leg_lab/100))
x1 <- 0
for (i in 1:length(leg_lab)) {
  rect(x1, 135, x1+0.35, 130, col = leg_col[i], border = leg_col[i])
  text(x1+0.175, 130, labels = leg_lab[i], pos = 1, cex = 0.8)
  x1 <- x1 + 0.65
}

text(x1-0.13, 130, labels = '%', pos = 1, cex = 0.8)
text(-0.2, 141, labels = 'Mehr oder weniger als in der Gesamtmenge', pos = 4)

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
# for (i in (i_center+1):nrow(cat_c27)) {
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
