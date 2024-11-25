resolve_value <- function(value, resolved) {
  variable_syntax <- regmatches(value, regexpr("\\$\\{([^}]+)\\}", value)) # get ${...}
  variable_name <- sub("\\$\\{([^}]+)\\}", "\\1", variable_syntax)         # strip ${...} resulting in ...

  if (is.null(resolved[[variable_name]])) stop(paste0("Variable '", variable_name, "' not found!", collapse = ""))

  res_val <- if (is.na(resolved[[variable_name]])) "" else resolved[[variable_name]]

  sub(paste0("\\$\\{", variable_name, "\\}"), res_val, value)
}

resolve_settings <- function(work_file, sheet) {
  settings <- openxlsx::read.xlsx(work_file, sheet)
  resolved <- list()

  for (i in 1:nrow(settings)) {
    param <- settings[[PARAMETER]][i]
    value <- settings[[VALUE]][i]
    sep   <- settings[[SEP]][i]
    while (grepl("\\$\\{[^}]+\\}", value)) {
      value <- resolve_value(value, resolved)
    }
    
    if (!is_empty(sep)) value <- trimws(gsub("\\s+", " ", unlist(strsplit(value, sep)))) # split
    resolved[[param]]         <- value # add
  }

  return(resolved)
}

get_existing_file_name <- function(file_param, settings) {
  file_name_vec <- settings[[file_param]]
  file_name <- NULL
  for (f in file_name_vec) {
    if (file.exists(f)) {
      file_name <- f
      break
    }
  }

  if (is.null(file_name)) stop(paste0("Parameter '", file_param, "' does not refer to any existing file. Please open '", file.path(getwd(), work_file), "' and provide a path to an existing file to parameter '", file_param, "'."))

  file_name
}

get_file <- function(file_param, settings, prefix_col) {
  if (JAN == settings$run_type) {
    years <- as.numeric(settings$year) + as.numeric(settings$years_delta_jan)
  } else if (JUN == settings$run_type) {
    years <- as.numeric(settings$year) + as.numeric(settings$years_delta_jun)
  } else stop(paste0("Setting 'run_type' should be element {", JAN, ", ", JUN, "}. Current value: ", settings$run_type))

  file_name <- get_existing_file_name(file_param, settings)
  mat       <- openxlsx::read.xlsx(file_name, sheet = 1)
  index     <- which(colnames(mat) %in% years)

  mat[, c(prefix_col, index)]
}

get_sheet <- function(work_file, i) openxlsx::read.xlsx(work_file, sheet = i)
