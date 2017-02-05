# prepare data as needed for stacked_comparison plot ############################

# get input arguments from makefile
args <- commandArgs(trailingOnly = T)

# file name for output .csv
fn_output <- args[1]
# data/output/data_to_plot/group_distributions_allref.csv
# old versions: 
# 'data/output/data_to_plot/group_distribution_c27.csv'
# 'data/output/data_to_plot/group_distribution_all.csv'
# 'data/output/data_to_plot/group_distribution_all_but_c27.csv'

# should entire data set or all but club 27 be used as reference: subset or all
subset   <- args[2]

# load required data
# aux_data  <- read.csv(file = 'data/output/data_to_plot/aux_data_for_plots.csv', stringsAsFactors = F)
aux_data  <- read.csv(file = args[3], stringsAsFactors = F)

# data set containing main categories per entry 
# wiki_main <- read.csv(file = 'data/output/main_categories.csv', stringsAsFactors = F)
wiki_main <- read.csv(file = args[4], stringsAsFactors = F)



club27 <- subset(wiki_main, age == 27)

if (subset == 'subset') {
  reference <- subset(wiki_main, age != 27)
} else {
  reference <- wiki_main
}

dist_table <- function(data, cn = c('cat', 'total', 'percent')) {
  cats           <- as.data.frame(table(data), responseName = 'total')
  cats$percent   <- 100 * cats$total / sum(cats$total)
  colnames(cats) <- cn
  return(cats)
}

cat_c27    <- dist_table(club27$main, c('cat', 'tot_c27', 'per_c27'))
cat_ref    <- dist_table(reference$main, c('cat', 'tot_all', 'per_ref'))

cats       <- merge(cat_c27, cat_ref, by = 'cat', all = T)
cats       <- merge(cats, aux_data, by = 'cat', all = T)

# order both data sets according percentage of in-/decrease
cats$gain  <- (cats$per_c27 - cats$per_ref) / cats$per_ref
i_order    <- order(-cats$gain)
cats       <- cats[i_order,]


write.csv(cats, file = fn_output, row.names = F)


