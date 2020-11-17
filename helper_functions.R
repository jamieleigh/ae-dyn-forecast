#Convert dates to xreg matrix
getXreg <- function(all_dates, xreg_dates){
  xreg <- data.frame(date = all_dates)
  
  vars <-
    sapply(
      X = xreg_dates,
      FUN = function(x) {
        ifelse(all_dates %in% x, 1, 0)
      }
    )
  
  return(cbind(xreg,vars))
}




