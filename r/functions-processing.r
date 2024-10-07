col_to_value <- function(expr, mat_input, i_var = NULL, settings) {
  # get time series
  lst <- list()
  for (i in 1:nrow(mat_input)) lst[[i]] <- as.numeric(mat_input[i, -c(1, 2)])
  names(lst) <- mat_input[, 1]
  
  # add variable used in exogenous calculations
  if (!is.null(i_var)) {
    lst <- c(i_var, lst)
    names(lst)[1] <- "i"
  }

  mat <- NULL
  env <- list2env(lst)
  for (i in seq_along(expr)) mat <- rbind(mat, eval(parse(text = expr[i]), envir = env))
  
  if (is.null(i_var)) {
    colnames(mat) <- colnames(mat_input)[-c(1,2)]
  } else {
    colnames(mat) <- colnames(mat_input)[2 + i_var] # TODO May be tricky but should be correct..
  }
  
  mat
}

process_sheets <- function(work_file, mat_input, settings) {
  sheet_name <- openxlsx::getSheetNames(work_file)
  lst <- list()
  for (i in 2:length(sheet_name)) { # iterate over sheets in right order so variables are defined before used
    sheet <- get_sheet(work_file, i)
    if (MUTDATA == sheet_name[i]) {
      mat <- NULL
      for (j in settings$i) {
        mat <- cbind(mat, col_to_value(expr = sheet[, RESULT], mat_input, i_var = as.numeric(j)))
      }
    } else {
      mat <- col_to_value(expr = sheet[, RESULT], mat_input)
    }
  
    if (!is.null(sheet[[VARIABLE]])) { # add results as variables for later computations
      index <- which(!is_empty(sheet[[VARIABLE]]))
      mat_with_vars <- cbind(sheet[[VARIABLE]], NA, mat)[index, ]
      colnames(mat_with_vars) <- colnames(mat_input)
      if (length(index)) mat_input <- rbind(mat_with_vars, mat_input)
    }
    
    # prepend columns *before* result
    mat <- as.data.frame(mat)
    if (MUTDATA == sheet_name[i]) {
      mat <- cbind(sheet[, EXOGENOUS], mat)
    } else {
      mat <- cbind(sheet[, 1:(which(RESULT == colnames(sheet)) - 1)], mat)
    }
    lst[[sheet_name[i]]] <- mat
  }
  
  lst
}

get_non_wage_related_tabels <- function(mat_input, settings) {
  lst <- setNames(list(data.frame(), data.frame(), data.frame()), c(settings$file_mdf[1], settings$file_uwv[1], settings$difference_table_name))
  for (v in settings$var_cpb) lst[[1]] <- rbind(lst[[1]], mat_input[which(v == mat_input[, 1]), ])
  for (v in settings$var_uwv) lst[[2]] <- rbind(lst[[2]], mat_input[which(v == mat_input[, 1]), ])
  lst[[3]] <- cbind(naam = settings$var_exo, label = mat_input$label[mat_input$naam %in% settings$var_exo], lst[[1]][, -c(1, 2)] - lst[[2]][, -c(1, 2)])
  for (i in 1:3) {
    lst[[i]] <- rbind(lst[[i]], c(settings$totaal, NA, colSums(lst[[i]][, -c(1, 2)])))
    lst[[i]][, -c(1, 2)] <- lapply(lst[[i]][, -c(1, 2)], as.numeric)
  }
  
  # fix exogenous
  lst[[3]] <- rbind(lst[[3]][1:(nrow(lst[[3]]) - 1), ], NA, lst[[3]][nrow(lst[[3]]), ]) # add blank row before 'total' so mimosi can read the exogenes
  lst[[3]] <- rbind(c(MUT_REMARK_LAB, settings[[MUT_REMARK_TXT]], rep(NA, ncol(lst[[3]]) - 2)), lst[[3]])
  
  lst
}
