plot_figs <- function(lst, settings) {
  path_vec <- NULL
  for (i in seq_along(settings$fig_path)) {
    df             <- lst[[settings$fig_tab[i]]]
    mat            <- df[, -c(1, 2)]
    path_file_name <- settings$fig_path[i]
    file_name      <- basename(path_file_name)
    file_path      <- dirname(path_file_name)
    treshold       <- as.numeric(settings$treshold[i])
    treshold       <- c(-treshold, treshold)[c(any(mat < -treshold, na.rm = TRUE), any(treshold < mat, na.rm = TRUE))]
    path_vec[i] <- nicerplot::nplot(df, style = "tall", type = "bar--", title = settings$fig_title[i], y_title = settings$fig_y_title[i], footnote = settings$fig_footnote[i], turn = TRUE, hline_bold = treshold, hline_bold_lwd = 2, hline_bold_col = settings$treshold_exceed_col, file = file_name, destination_path = file_path)
  }
  
  path_vec
}