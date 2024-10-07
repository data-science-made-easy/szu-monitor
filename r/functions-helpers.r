is_empty <- function(vec) sapply(vec, function(v) if (is.na(v)) return(TRUE) else return(0 == nchar(stringr::str_trim(v))))
