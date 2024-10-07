# SZu-monitor: CPB vs. UWV
Goal of the SZu-monitor is to produce two so-called `mutfile`s. One can supply these files as corrections to the Mimosi model. In addition to producing the `mutfile`s, the monitor also compares several of CPB's with UWV's estimates for social security expenditures. Run the `compare-cpb-uwv.r` script in R, or run `compare-cpb-uwv.bat` in Windows Explorer, to generate visual and tabular outputs that highlight differences between the two sets of estimates.

## Input
The monitor uses data from the `comparison-cpb-uwv.xlsx` file, which contains a `settings` tab and `output` tabs (with some formulas).

### Settings
This tab is parameterized for easy adjustments. Users typically need to modify the `run` (e.g., 661), `run_type` (`jan` or `jun`), and `year` parameters for each session. The `settings` tab also defines file paths for input and output, specifying the time series for the relevant variables.

### Output tabs
The three output tabs compare CPB's with UWV's estimates of (i) price per year differences, (ii) price differences, and (iii) exogenous variables, for a series of for funds and corresponding arrangements. One can use the resulting xlsx file as a so-called `mutfile` to supply corrections to Mimosi.

## Output
  * two png figures showing differences (paths defined in `settings` tab)
  * two xlsx files (paths defined in `settings` tab)

