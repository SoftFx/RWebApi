# RTTWebClient
This package works with WebAPi of TickTrader Server. 

# Prerequisites
This package use httr, jsonlite, data.table r libraries. Please install them before using.

# How to install RTTWebClient?
```
if(!require(devtools)) {install.packages("devtools"); library(devtools)}
if(require(RTTWebClient)) {detach("package:rTTRatesHistory", unload=TRUE); remove.packages("RTTWebClient")}
install_github("SoftFx/TTWebClient-R",subdir = "RTTWebClient")	 

```

# Examples
 You can use function ttInitialize to set server name and port:
1) cryptottlivewebapi.fxopen.net - TT Exchange FXOPEN WebAPI
2) ttlivewebapi.fxopen.com - TT Live WebAPI

Port is 8443 as default

To get Quotes, Bars, etc. info you should call function from R list object which was created by ttInitialize with the appropriate parameters. 
See code below

```
library(RTTWebClient)
connection <- ttInitializeweb_api_address = "cryptottlivewebapi.fxopen.net", web_api_port = 8443)#for forex symbols from ttlivewebapi.fxopen.com

symbols <- connection$GetPublicSymbolInfo()

bars <- connection$GetPublicBarsHistory("BTCUSD", barsType = "Bid", periodicity = "M1", startTime = as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), endTime = as.POSIXct("2018-10-12 05:00:00", tz = "GMT"))
#Get 300 bars ahead from the startTime
bar_1 <- connection$GetPublicBarsHistory("BTCUSD", barsType = "Bid", periodicity = "M1", startTime = as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), count = 300)
#Get 300 bars back from the startTime
bar_2 <- connection$GetPublicBarsHistory("BTCUSD", barsType = "Bid", periodicity = "M1", startTime = as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), count = -300)

ticks <- connection$GetPublicTickHistory("BTCUSD", startTime = as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), endTime = as.POSIXct("2018-10-12 05:00:00", tz = "GMT"))
#Get 300 ticks ahead from the startTime
ticks_1 <- connection$GetPublicTickHistory("BTCUSD", startTime = as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), count = 300)
#Get 300 ticks back from the startTime
ticks_2 <- connection$GetPublicTickHistory("BTCUSD", startTime = as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), count = -300)

currentQuotes <- connection$GetPublicCurrentQuotes()
#Get all symbols 1 tick by timestamp
ticksByTimestamp <- connection$GetPublicTicksByTimestamp(as.POSIXct(Sys.Date(), tz = "GMT"))
 
```
