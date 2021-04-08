# ae-dyn-forecast

This repository contains code which can be used to constuct a simple dynamic forecasting model.

Suppose you have two sets of count data counts1 (A&E Admissions) and counts2 (A&E Attendances) and they are related to one another via

$ counts1 = \beta_{1} counts2 + n_t $

where $n_t$ is assumed to follow an ARIMA Process.


Then the scripts in this repository will:

1. Fit an ARIMA model with exogenous variables to the time series counts2 (A&E Attendances);
2. Fit a time varying linear regression model with ARIMA errors to the time series counts1 (A&E Admissions), using counts2 as a regessor.

The exogenous variables used in step 1 include:
- Day of the week variables;
- Lockdown indicators;
- Holiday indicators;
- Fourier terms for the yearly seasonality.

The code can be edited to include additional variables and currently runs using simulated count data.

Please get in touch if you would like support implementing this forecsting model, in particular, integrating it with Qlik Sense. 

