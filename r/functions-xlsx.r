decoreate_mutdata <- function(df, mat_input, settings) {
  index_NA <- which(is.na(df[,1]))
  if (length(index_NA)) df <- df[-index_NA, ]
  label <- setNames(mat_input[[LABEL]], mat_input[[NAAM]])[df[, 1]] # label autons
  df <- cbind(df[1], label, df[2:ncol(df)])
  colnames(df)[1] <- NAAM
  df <- rbind(c(MUT_REMARK_LAB, settings[[MUT_REMARK_TXT]], rep(NA, ncol(df) - 2)), df)
  for (j in 3:ncol(df)) df[, j] <- as.numeric(df[, j])
  
  df
}

decorate_diff_sheet <- function(df) {
  df <- df[!apply(df[, -c(1, 2)], 1, function(x) all(is.na(x))), ] # remove empty lines
  df[duplicated(df[, FUND]), 1] <- NA # remove dups for clearness
  
  df
}

decorate <- function(lst, mat_input, settings) {
  for (i in seq_along(lst)) {
    if (MUTDATA == names(lst)[i]) {
      lst[[i]] <- decoreate_mutdata(lst[[MUTDATA]], mat_input, settings)
    } else {
      lst[[i]] <- decorate_diff_sheet(lst[[i]])
    }
  }
    
  lst
}

save_xlsx_wage_related <- function(lst, settings) {
  wb <- openxlsx::createWorkbook()

  sheet_name <- names(lst)
  for (i in seq_along(sheet_name)) {
    mat <- lst[[i]]
    openxlsx::addWorksheet(wb, sheet_name[i], zoom = as.numeric(settings$zoom)) # create sheet
    openxlsx::writeData(wb, sheet_name[i], mat) # add data

    # Detect values that exceed treshold
    treshold <- as.numeric(settings$treshold[i])
    row_extreme <- col_extreme <- NULL
    if (!is.na(treshold)) {
      for (row in (if (MUTDATA == sheet_name[i]) 2 else 1):(nrow(mat))) {
        for (col in 3:ncol(mat)) {  # assume numeric values from col 3 on
          value <- mat[row, col]
          if (!is.na(value) && (value < -treshold || treshold < value)) {
            row_extreme <- c(row_extreme, 1 + row)
            col_extreme <- c(col_extreme, col)
          }
        }
      }
    }
    
    # add formatting
    style_bold     <- openxlsx::createStyle(textDecoration = "bold")
    style_bold_col <- openxlsx::createStyle(textDecoration = "bold", fontColour = settings$treshold_exceed_col)
    openxlsx::addStyle(wb, sheet_name[i], style = style_bold, rows = 1, cols = 1:ncol(mat), gridExpand = TRUE)                # bold header
    openxlsx::addStyle(wb, sheet_name[i], style = style_bold, rows = 1 + 0:nrow(mat), cols = 1:2, gridExpand = TRUE)          # bold first two columns
    openxlsx::addStyle(wb, sheet_name[i], style = style_bold_col, rows = row_extreme, cols = col_extreme, gridExpand = FALSE)
    for (j in 1:ncol(mat)) openxlsx::setColWidths(wb, sheet_name[i], cols = j, widths = "auto")                               # make columns as wide as content
  }
 
  # save
  openxlsx::saveWorkbook(wb, file = settings$file_mut, overwrite = TRUE)
  
  settings$file_mut
}


save_xlsx_non_wage_related <- function(lst, settings) {
  sn <- settings$tab_social_security
  style_bold_col <- openxlsx::createStyle(textDecoration = "bold", fontColour = settings$treshold_exceed_col)
  m  <- 2 + ncol(lst[[3]])
  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, sn, zoom = as.numeric(settings$zoom)) # create sheet
  openxlsx::writeData(wb, sheet = sn, x = lst[[3]])
  openxlsx::writeData(wb, sheet = sn, x = names(lst)[3], startCol = m)
  openxlsx::addStyle(wb, sn, style = style_bold_col, rows = 1, cols = m, gridExpand = FALSE)
  n <- 4 + nrow(lst[[3]])
  openxlsx::writeData(wb, sheet = sn, x = lst[[1]], startRow = n)
  openxlsx::writeData(wb, sheet = sn, x = names(lst)[1], startRow = n, startCol = m)
  openxlsx::addStyle(wb, sn, style = style_bold_col, rows = n, cols = m, gridExpand = FALSE)
  n <- 3 + n + nrow(lst[[1]])
  openxlsx::writeData(wb, sheet = sn, x = lst[[2]], startRow = n)
  openxlsx::writeData(wb, sheet = sn, x = names(lst)[2], startRow = n, startCol = m)
  openxlsx::addStyle(wb, sn, style = style_bold_col, rows = n, cols = m, gridExpand = FALSE)
  
  for (j in 1:ncol(lst[[1]])) openxlsx::setColWidths(wb, sn, cols = j, widths = "auto") # make columns as wide as content
    
  openxlsx::saveWorkbook(wb, file = settings$file_social_security, overwrite = TRUE)
 
  settings$file_social_security 
}
