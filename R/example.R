library(rTTRatesHistory)

connection <- ttInitialize(serverName = "cryptottlivewebapi.xbtce.net", port = "8443")

symbols <- connection$GetSymbolsInfo()

bars <- connection$GetBarsHistrory("BTCUSD", barsType = "Bid", periodicity = "M1", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"))

ticks <- connection$GetTickHistory("BTCUSD", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"))

currentQuotes <- connection$GetCurrentQuotes()
