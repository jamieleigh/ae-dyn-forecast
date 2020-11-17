##########################################

forecast_tvlm <- function(data, newdata, h, response = "counts", exp = c("counts_2", "counts_3")){
  ###################################################
  #### Fit a time varying linear regression model ###
  ###################################################
  
  tvlm_model <-
    tvLM(data = data, formula = formula(paste0(response," ~ ",paste0(exp, collapse = " + "))))
  
  
  ###################################################
  #### Model the errors using auto.arima() ##########
  ###################################################
  
  # Get residuals
  data_res <- tvlm_model$residuals
  res_ts <-
    ts(data_res,
       frequency = 7)
  
  # Fit auto.arima
  residual_model <- auto.arima(data_res, seasonal=TRUE)
  
  
  #######################
  #### Get Forecasts ####
  #######################
  fc_lr <-
    tvReg::forecast(tvlm_model, newdata =  as.matrix(newdata), n.ahead = h)
  
  fc_error <- forecast::forecast(residual_model, h = h)
  
  tvlm_model_forecast <- fc_lr + fc_error$mean
  
  return(tvlm_model_forecast)
  
}













