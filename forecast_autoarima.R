##########################################
# The below function 


# INPUT: 'data' a dataframe with collums 'date' and 'counts'
#                 'date'should be formatted as as.Date("YYYY-MM-DD")
#         'h' forcast horizon, integer

forecast_autoarima <- function(data, h = 7){
  
  ###########################################
  ######## Holidays and Events ##############
  ###########################################
  
  # Let's model the following holidays as single dates
  holiday_dates <-
    list(
      christmas     = as.Date(ChristmasDay(unique(year(
        data$date
      )))),
      christmas_eve = as.Date(ChristmasEve(unique(year(
        data$date
      )))),
      boxing_day    = as.Date(BoxingDay(unique(year(
        data$date
      )))),
      new_year      = as.Date(NewYearsDay(unique(c(
        year(data$date), year(data$date) + 1
      )))),
      bank_holidays = as.Date(holidayLONDON(unique(year(
        data$date
      ))))
    )
  
  
  # Let's include a level shift for Christmas too, and a level shift from lockdown until today
  level_dates <- list(
    lockdown =  seq(as.Date("2020-03-23"), Sys.Date(),1),
    christmas_preiod = as.Date(unlist(
      mapply(
        FUN = function(x, y) {
          seq(from = x + 1,
              to = y - 1,
              by = 1)
        },
        x = holiday_dates$boxing_day,
        y = holiday_dates$new_year[-which(holiday_dates$new_year < holiday_dates$boxing_day[1])],
        SIMPLIFY = F
      )
    ), origin = "1970-01-01")
  )
  
  # Put all dates together
  xreg_holidays_dates <- c(holiday_dates, level_dates)
  
  
  ########################################
  ###### Fit Model #######################
  ########################################
  
  # Estimate Fourier terms for yearly seasonality
  yearly_fourier <- fourier(ts(data$counts, frequency=365.25), K=5)
  
  
  # Convert holiday dates to a matrix to use in regression
  xreg_holidays <- getXreg(all_dates = data$date, xreg_holidays_dates)
  
  # Day of the Week
  day_of_week <- data.frame(dow = factor(wday(data$date)))
  xreg_dow    <- model.matrix( ~ dow , data=day_of_week )[,-1]
  
  # Put all our regressors together
  xreg = as.matrix(cbind(xreg_holidays, xreg_dow, yearly_fourier)[,-1])
  
  # Fit auto.arima model
  auto_model <-
    auto.arima(
      data$counts,
      xreg = xreg ,
      seasonal = FALSE
    )
  
  ####################################
  ###### Generate Forecasts ##########
  ####################################

  # Get forecast dates
  forecast_dates <-
    seq(
      from = tail(data$date, 1) + 1,
      to = tail(data$date, 1) + h,
      by = 1
    )
  
  # Get future holiday xreg
  xreg_holidays_forecast <-
    getXreg(all_dates = forecast_dates, xreg_holidays_dates)
  
  # Get future yearly fourier terms
  yearly_fourier_forecast <- fourier(ts(data$counts, frequency=365.25), K=5, h = h)
  
  # Get future dow
  day_of_week_forecast <- data.frame(dow = factor(wday(forecast_dates)))
  xreg_dow_forecast    <- model.matrix( ~ dow , data=day_of_week_forecast )[,-1]
  
  # Put all regressors together
  xreg_forecast = as.matrix(cbind(xreg_holidays_forecast, xreg_dow_forecast, yearly_fourier_forecast)[,-1])
  
  # Forecast (you should round these if you are dealing with counts)
  auto_model_forecast <-
    forecast::forecast(auto_model,
                       h = h,
                       xreg = xreg_forecast)
  
  return(auto_model_forecast)
  
}




