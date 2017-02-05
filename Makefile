

AGE_DIST_ALL1_INPUT = \
	data/additional/attributes_all.RData \
	data/output/all_categories_wide.csv

data/output/data_to_plot/age_distributions_combis.csv: $(AGE_DIST_ALL1_INPUT) R/data_analysis/age_distributions_1yr.R
	Rscript R/data_analysis/age_distributions_1yr.R $@ all $(AGE_DIST_ALL1_INPUT)



AGE_DIST_MAIN1_INPUT = \
	data/additional/attributes_all.RData \
	data/output/main_categories.csv

data/output/data_to_plot/age_distributions_main.csv: $(AGE_DIST_MAIN1_INPUT) R/data_analysis/age_distributions_1yr.R
	Rscript R/data_analysis/age_distributions_1yr.R $@ main $(AGE_DIST_MAIN1_INPUT)



AGE_DIST_ALL5_INPUT = \
	data/additional/attributes_all.RData \
	data/output/data_to_plot/age_distributions_combis.csv

data/output/data_to_plot/age_distributions_combis_5yr.csv: $(AGE_DIST_ALL5_INPUT) R/data_analysis/age_distributions_5yr.R
	Rscript R/data_analysis/age_distributions_5yr.R $@ $(AGE_DIST_ALL5_INPUT)



AGE_DIST_MAIN5_INPUT = \
	data/additional/attributes_all.RData \
	data/output/data_to_plot/age_distributions_main.csv

data/output/data_to_plot/age_distributions_main_5yr.csv: $(AGE_DIST_MAIN5_INPUT) R/data_analysis/age_distributions_5yr.R
	Rscript R/data_analysis/age_distributions_5yr.R $@ $(AGE_DIST_MAIN5_INPUT)



PLOT_STACKED_INPUT = \
	data/output/data_to_plot/aux_data_for_plots.csv \
	data/output/data_to_plot/group_distribution_c27.csv \
	data/output/data_to_plot/group_distribution_all.csv

figure_drafts/stacked_comparison_up_down.svg: $(PLOT_STACKED_INPUT) R/plot/stacked_comparison.R
	Rscript R/plot/stacked_comparison.R $@ $(PLOT_STACKED_INPUT)



PLOT_AGE_DIST_INPUT = \
	data/output/data_to_plot/aux_data_for_plots.csv \
	data/output/data_to_plot/age_distributions_combis.csv \
	data/output/data_to_plot/age_distributions_combis_5yr.csv

figure_drafts/age_dist_combined_groups.svg: $(PLOT_AGE_DIST_INPUT) R/plot/age_distribution_per_category.R
	Rscript R/plot/age_distribution_per_category.R $@ $(PLOT_AGE_DIST_INPUT)


.DEFAULT_GOAL := all
all: figure_drafts/stacked_comparison_up_down.svg figure_drafts/age_dist_combined_groups.svg data/output/data_to_plot/age_distributions_main.csv data/output/data_to_plot/age_distributions_combis.csv data/output/data_to_plot/age_distributions_combis_5yr.csv data/output/data_to_plot/age_distributions_main_5yr.csv
