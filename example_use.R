library("lubridate")
library("timeDate")
library("forecast")
library("tvReg")
source("helper_functions.R")
source("forecast_autoarima.R")
source("forecast_tvLM.R")

set.seed(1)
# Generate some pretend counts data for which some proportion of counts 2 and 3 contribute to counts
data = data.frame(date = seq(as.Date("2017-03-23"), Sys.Date(), 1),
                  counts = round(rnorm(length(
                    seq(as.Date("2017-03-23"), Sys.Date(), 1)
                  ), 200, 20)))

data$counts_2 <-
  round(data$counts * c(rnorm(n=floor(length(data$counts)/ 2), 1.3, 0.05),
                        rnorm(n=ceiling(length(data$counts)/2), 1.6, 0.05)))


data$counts_3 <-
  round(data$counts * c(rnorm(n=floor(length(data$counts)/ 2), 1.15, 0.05),
                        rnorm(n=ceiling(length(data$counts)/2), 1.3, 0.05)))


# Run auto.arima model on counts 2 & 3

forecast_counts_2 <-
  forecast_autoarima(data = data.frame(date = data$date, counts = data$counts_2),
                     h = 7)

forecast_counts_3 <-
  forecast_autoarima(data = data.frame(date = data$date, counts = data$counts_3),
                     h = 7)

# Run tvLM model on counts, using counts 2 & 3 as regressors 
forecast_counts <-
  forecast_tvlm(
    data = data,
    newdata = data.frame(counts_2 = forecast_counts_2$mean, counts_3 = forecast_counts_3$mean),
    h = 7,
    response = "counts",
    exp = c("counts_2", "counts_3")
  )
