# rTTRatesHistory
This package was created to replace rFdk without using rClr. It works with WebAPi and downloads QuotesHistory, BarsHistory, SymbolInfo directly from WebAPI

# Prerequisites
This package use httr, jsonlite, data.table r libraries. Please install them before using.

# How to install rrTTRatesHistory?
```
if(!require(devtools)) {install.packages("devtools"); library(devtools)}
if(require(rTTRatesHistory)) {detach("package:rTTRatesHistory", unload=TRUE); remove.packages("rTTRatesHistory")}
install_github("SoftFx/TTWebClient-R",subdir = "R/rTTRatesHistory")	 

```

# Examples
 You can use function ttInitialize to set server name and port:
1) cryptottlivewebapi.xbtce.net - xBTCe WebAPI
2) ttlivewebapi.fxopen.com - TT Live WebAPI

Port is 8443 as default

To get Quotes, Bars, etc. info you should call function from R list object which was created by ttInitialize with the appropriate parameters. 
See code below

```
library(rTTRatesHistory)

connection <- ttInitialize(serverName = "cryptottlivewebapi.xbtce.net", port = "8443")

symbols <- connection$GetSymbolsInfo()

bars <- connection$GetBarsHistrory("BTCUSD", barsType = "Bid", periodicity = "M1", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"))

ticks <- connection$GetTickHistory("BTCUSD", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"))

currentQuotes <- connection$GetCurrentQuotes()	 

```
