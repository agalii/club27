PLOT_STACKED_INPUT = \
	data/output/data_to_plot/aux_data_for_plots.csv \
	data/output/data_to_plot/group_distribution_c27.csv \
	data/output/data_to_plot/group_distribution_all.csv

figure_drafts/stacked_comparison_up_down.svg: $(PLOT_STACKED_INPUT) R/plot/stacked_comparison.R
	Rscript R/plot/stacked_comparison.R $@ $(PLOT_STACKED_INPUT)


AGE_DIST_INPUT = \
	data/output/data_to_plot/aux_data_for_plots.csv \
	data/output/data_to_plot/age_distributions_combis.csv \
	data/output/data_to_plot/age_distributions_combis_5yr.csv

figure_drafts/age_dist_combined_groups.svg: $(AGE_DIST_INPUT) R/plot/age_distribution_per_category.R
	Rscript R/plot/age_distribution_per_category.R $@ $(AGE_DIST_INPUT)


.DEFAULT_GOAL := all
all: figure_drafts/stacked_comparison_up_down.svg figure_drafts/age_dist_combined_groups.svg
