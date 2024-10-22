
# clean up raw data ###
CLEANUP_DATE = data/raw/dewiki-20170101-persons.tsv

data/output/intermediate_backups/wiki_data_cleaned_up.csv: $(CLEANUP_DATE) R/data_analysis/date_cleanup.R
	Rscript R/data_analysis/date_cleanup.R $@ $(CLEANUP_DATE)


#
CALCULATE_AGE = data/output/intermediate_backups/wiki_data_cleaned_up.csv

data/output/intermediate_backups/wiki_data_age.csv: $(CALCULATE_AGE) R/data_analysis/age_calculation.R
	Rscript R/data_analysis/age_calculation.R $@ $(CALCULATE_AGE)


#
CLEANUP_PROPERTIES = data/output/intermediate_backups/wiki_data_age.csv

data/output/intermediate_backups/simplified_properties.csv: $(CLEANUP_PROPERTIES) R/data_analysis/property_cleanup.R
	Rscript R/data_analysis/property_cleanup.R $@ $(CLEANUP_PROPERTIES)


# define relevant categories and attributes for further analysis
ADDITIONAL_MUSIC = data/additional/music.csv

data/additional/music_clean.csv: $(ADDITIONAL_MUSIC) R/data_analysis/additional_data_music_cleanup.R
	Rscript R/data_analysis/additional_data_music_cleanup.R $@ $(ADDITIONAL_MUSIC)


#
ADDITIONAL_SPORT = data/additional/sport.tsv

data/additional/sport_clean.csv: $(ADDITIONAL_SPORT) R/data_analysis/additional_data_sport_cleanup.R
	Rscript R/data_analysis/additional_data_sport_cleanup.R $@ $(ADDITIONAL_SPORT)


#
DEFINE_CATS_ALL = \
	data/additional/sport_clean.csv \
	data/additional/music_clean.csv

data/additional/attributes_all.RData: $(DEFINE_CATS_ALL) R/data_analysis/define_categories_all.R
	Rscript R/data_analysis/define_categories_all.R $@ $(DEFINE_CATS_ALL)


#
DEFINE_CATS_MAIN = \
	data/additional/sport_clean.csv \
	data/additional/music_clean.csv

data/additional/attributes_main.RData: $(DEFINE_CATS_MAIN) R/data_analysis/define_categories_main.R
	Rscript R/data_analysis/define_categories_main.R $@ $(DEFINE_CATS_MAIN)



# define colors and legend labels for all cetegories to used for plotting

data/output/data_to_plot/aux_data_for_plots.csv: R/plot/define_aux_data.R
	Rscript R/plot/define_aux_data.R $@


# actual analysis
# analyse properties from 'kurzbeschreibung to extract groups for all entries
# all groups per entry
FIND_ALL_CATEGORIES = \
	data/additional/attributes_all.RData \
	data/output/intermediate_backups/simplified_properties.csv

data/output/all_categories.csv: $(FIND_ALL_CATEGORIES) R/data_analysis/find_all_categories.R
	Rscript R/data_analysis/find_all_categories.R $@ $(FIND_ALL_CATEGORIES)


# the first group per entry
FIND_MAIN_CATEGORIES = \
	data/additional/attributes_main.RData \
	data/output/intermediate_backups/simplified_properties.csv

data/output/main_categories.csv: $(FIND_MAIN_CATEGORIES) R/data_analysis/find_main_categories.R
	Rscript R/data_analysis/find_main_categories.R $@ $(FIND_MAIN_CATEGORIES)


# get group distribution for club27 and entire data set ('all', as opposed to 'subset')
GROUP_DIST_ALL = \
	data/output/data_to_plot/aux_data_for_plots.csv \
	data/output/main_categories.csv

data/output/data_to_plot/group_distributions_allref.csv: $(GROUP_DIST_ALL) R/data_analysis/group_distributions_main_to_plot.R
	Rscript R/data_analysis/group_distributions_main_to_plot.R $@ all $(GROUP_DIST_ALL)


# get age distribution within groups, 1yr and 5yr bins
AGE_DIST_ALL1_INPUT = \
	data/additional/attributes_all.RData \
	data/output/all_categories.csv

data/output/data_to_plot/age_distributions_combis.csv: $(AGE_DIST_ALL1_INPUT) R/data_analysis/age_distributions_1yr.R
	Rscript R/data_analysis/age_distributions_1yr.R $@ all $(AGE_DIST_ALL1_INPUT)


#
AGE_DIST_ALL5_INPUT = \
	data/additional/attributes_all.RData \
	data/output/data_to_plot/age_distributions_combis.csv

data/output/data_to_plot/age_distributions_combis_5yr.csv: $(AGE_DIST_ALL5_INPUT) R/data_analysis/age_distributions_5yr.R
	Rscript R/data_analysis/age_distributions_5yr.R $@ $(AGE_DIST_ALL5_INPUT)



#AGE_DIST_MAIN1_INPUT = \
#	data/additional/attributes_all.RData \
#	data/output/main_categories.csv
#
#data/output/data_to_plot/age_distributions_main.csv: $(AGE_DIST_MAIN1_INPUT) R/data_analysis/age_distributions_1yr.R
#	Rscript R/data_analysis/age_distributions_1yr.R $@ main $(AGE_DIST_MAIN1_INPUT)



#AGE_DIST_MAIN5_INPUT = \
#	data/additional/attributes_all.RData \
#	data/output/data_to_plot/age_distributions_main.csv
#
#data/output/data_to_plot/age_distributions_main_5yr.csv: $(AGE_DIST_MAIN5_INPUT) R/data_analysis/age_distributions_5yr.R
#	Rscript R/data_analysis/age_distributions_5yr.R $@ $(AGE_DIST_MAIN5_INPUT)


# plot! 
PLOT_STACKED_INPUT = \
	data/output/data_to_plot/aux_data_for_plots.csv \
	data/output/data_to_plot/group_distributions_allref.csv 

figures/stacked_comparison_up_down.svg: $(PLOT_STACKED_INPUT) R/plot/stacked_comparison.R
	Rscript R/plot/stacked_comparison.R $@ $(PLOT_STACKED_INPUT)


#
PLOT_AGE_DIST_INPUT = \
	data/output/data_to_plot/aux_data_for_plots.csv \
	data/output/data_to_plot/age_distributions_combis.csv \
	data/output/data_to_plot/age_distributions_combis_5yr.csv

figures/age_dist_combined_groups.svg: $(PLOT_AGE_DIST_INPUT) R/plot/age_distribution_per_category.R
	Rscript R/plot/age_distribution_per_category.R $@ $(PLOT_AGE_DIST_INPUT)



.DEFAULT_GOAL := all
all: figures/stacked_comparison_up_down.svg figures/age_dist_combined_groups.svg 

