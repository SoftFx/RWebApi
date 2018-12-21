library(rTTRatesHistory)

connection <- ttInitialize(serverName = "cryptottlivewebapi.xbtce.net", port = "8443")

symbols <- connection$GetSymbolsInfo()

bars <- connection$GetBarsHistory("BTCUSD", barsType = "Bid", periodicity = "M1", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"))
#Get 300 bars ahead from the startTime
bar_1 <- connection$GetBarsHistory("BTCUSD", barsType = "Bid", periodicity = "M1", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"), 300)
#Get 300 bars back from the startTime
bar_2 <- connection$GetBarsHistory("BTCUSD", barsType = "Bid", periodicity = "M1", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"), -300)

ticks <- connection$GetTickHistory("BTCUSD", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"))
#Get 300 ticks ahead from the startTime
ticks_1 <- connection$GetTickHistory("BTCUSD", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"), 300)
#Get 300 ticks back from the startTime
ticks_2 <- connection$GetTickHistory("BTCUSD", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"), -300)

currentQuotes <- connection$GetCurrentQuotes()
