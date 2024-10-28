rm(list = ls())
cpblib::use_cpblib()
source("r/constants.r")
source("r/functions-helpers.r")
source("r/functions-input.r")
source("r/functions-processing.r")
source("r/functions-plot.r")
source("r/functions-xlsx.r")

work_file <- "comparison-cpb-uwv.xlsx"

###
### Mutfile, Price and volume comparison CPB vs UWV (wage-related benefit)
###

## INPUT
##

# read settings
settings <- resolve_settings(work_file, sheet = "settings")

# get data: c('naam', 'label', y1, y2, y3)] == colnames(mat)
mat_input <- get_file("file_mdf", settings, prefix_col = 1:2)
mat_input <- rbind(mat_input, setNames(get_file("file_uwv", settings, prefix_col = 2:3), colnames(mat_input)))

## PROCESSING
##

# perform calculations on all but first tab
lst <- process_sheets(work_file, mat_input, settings)

# decorate mutdata tab
lst <- decorate(lst, mat_input, settings)

## OUTPUT
##
fig_path                          <- plot_figs(lst, settings) # create figs
xlsx_wage_related_price_diff_path <- save_xlsx_wage_related(lst, settings) # save xlsx


###
### Social security (non-wage-related benefits)
###
lst <- get_non_wage_related_tabels(mat_input, settings)
xlsx_non_wage_related <- save_xlsx_non_wage_related(lst, settings)

cat(paste0("\n",
  "Results 'social security' CPB minus UWV\n",
  "---------------------------------------\n",
  "\n",
  "Wage-related social security expenditures:\n",
  "- figure with 'price per year' differences: ", fig_path[1], ".\n",
  "- figure with 'price' differences:          ", fig_path[2], "\n",
  "- xlsx-file with three tabs\n",
  "  ('price per year' differences, 'price'\n",
  "  differences, mutfile):                    ", xlsx_wage_related_price_diff_path, "\n",
  "\n",
  "Non-wage-related social security expenditures:\n",
  "- xlsx-file (mutfile):                      ", xlsx_non_wage_related, "\n\n"
))
