# SZu-monitor: CPB vs. UWV
SZu stands for 'socialezekerheidsuitgaven'. The SZu-monitor generates two `mutfiles` for correcting Mimosi model estimates. In addition, it compares CPB's and UWV's social security expenditure estimates. It provides both visual (png) and tabular (xlsx) outputs to highlight key differences.

- [SZu-monitor: CPB vs. UWV](#szu-monitor-cpb-vs-uwv)
- [Getting Started](#getting-started)
- [Input](#input)
  - [Settings](#settings)
- [Output](#output)
  - [Wage-Related Output](#wage-related-output)
  - [Non-Wage-Related Benefits](#non-wage-related-benefits)

## Getting started
Download [this batch-file](https://raw.githubusercontent.com/data-science-made-easy/szu-monitor/refs/heads/master/download-szu-monitor.bat) to install the latest version of SZu-monitor (right-click with mouse > Save Link As). This will create a `szu-monitor` directory containing the 'compare-cpb-uwv.bat' file to run the monitor. Before running, consider updating the `settings` tab in `comparison-cpb-uwv.xlsx`.

## Input
The monitor uses `comparison-cpb-uwv.xlsx`, which includes a `settings` tab and a template for several 'output' tabs.

### Settings
The `settings` tab allows easy adjustment of parameters like `run` (e.g., 661), `run_type` (`jan` or `jun`), and `year`. It also defines file paths for input and output, including time series for variables that appear in formulas on the output tabs.

### Output
The monitor produces:

  - two figures (pngs) and an xlsx-file for wage-related benefits
  - an additional xlsx-file for non-wage-related benefits

Both Excel files can be used as `mutfiles` to correct Mimosi's estimates. Paths to the xlsx-files and pngs are defined in the `settings` tab.

#### Wage-related output tabs
The three 'output' tabs in the `comparison-cpb-uwv.xlsx` file will be processed. Their results will appear in the first xlsx-file. The tabs compare CPB's and UWV's estimates across various funds and arrangements:

  - (i) *price per year* differences
  - (ii) *price* differences
  - (iii) *exogenous variables*

#### Non-wage-related benefits
The non-wage-related benefits are compared only for a few variables, listed in `comparison-cpb-uwv.xlsx`'s `settings` tab.
