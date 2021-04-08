# ae-dyn-forecast
During the COVID-19 pandemic, forecasting is particularly difficult. It is therefore important that models are as flexible and as dynamic as possible. A&E conversion rates during the pandemic have been time varying. Therefore, if you are attempting to forecast daily admissions using A&E attendance numbers, it is important to capture features such as this. 

This repository contains code which can be used to construct a simple dynamic forecasting model which captures a time varying conversion rate. 

Suppose you have two sets of count data counts1 (A&E Admissions) and counts2 (A&E Attendances) and they are related to one another via

counts1 = beta_1 counts2 + n_t

where n_t is assumed to follow an ARIMA Process.


Then the scripts in this repository will:

1. Fit "the best fitting" ARIMA model with exogenous variables to the time series counts2 (A&E Attendances).
2. Fit a time varying linear regression model with ARIMA errors to the time series counts1 (A&E Admissions), using counts2 as a regressor.

The exogenous variables used in step 1 include:
- Day of the week variables.
- Lockdown indicators.
- Holiday indicators.
- Fourier terms for the yearly seasonality.

The main R packages used are the 'forecast' package to run the ‘auto.arima()’ routine, and the 'tvReg' package to fit the time varying linear regression model. 

The code can be edited to include additional variables, for example weather data. It currently runs using simulated count data; however, these should be replaced using your own data. It currently accepts three sets of count data, the third could be 'Walk in Centre Attendances', or 'Ambulance Arrivals', for example. 

Please get in touch if you would like support implementing this forecasting model and integrating it with Qlik Sense.


