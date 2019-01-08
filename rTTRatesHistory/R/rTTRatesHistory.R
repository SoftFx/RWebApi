
GetBars <- function(server, symbol, barsType = "Bid", periodicity = "M1", startTime, endTime, count) {
  tempStartTime <- as.double(startTime)*1000
  history <- data.table()
  maxCount <- 1000
  if(count == 0) {
    repeat{
      bars <- GetBarFromWeb(server, symbol, barsType, periodicity, tempStartTime, maxCount)
      excludeIndex <-ifelse(is.null(history[.N]$Timestamp), numeric(0), bars[Timestamp==history[.N]$Timestamp,which=T])
      if(!is.na(excludeIndex))
        bars <-bars[-excludeIndex]
      if(nrow(bars) == 0) {
        break;
      }else{
        endTimeInMs <- as.double(endTime) * 1000
        if(bars[.N]$Timestamp >= endTimeInMs){
          history = rbind(history, bars[Timestamp <= endTimeInMs])
          break;
        }
      }
      history <- rbind(history, bars)
      tempStartTime <- history[.N]$Timestamp
    }
  }else{
    if(abs(count) < maxCount){
      history <- GetBarFromWeb(server, symbol, barsType, periodicity, tempStartTime, count)
    }else{
      history <- GetBarFromWeb(server, symbol, barsType, periodicity, tempStartTime, maxCount * sign(count))
    }
  }
  history$Timestamp <- as.POSIXct(history$Timestamp/1000, origin = "1970-01-01", tz = "GMT")
  setkey(history, Timestamp)
  return(history)
}

GetTicks <- function(server, symbol, startTime, endTime, count) {
  tempStartTime <- as.double(startTime)*1000
  history <- data.table()
  maxCount <- 1000
  if(count == 0) {
    repeat{
      ticks <- GetTicksFromWeb(server, symbol, tempStartTime, maxCount)
      excludeIndex <-ifelse(is.null(history[.N]$Timestamp), numeric(0), ticks[Timestamp==history[.N]$Timestamp,which=T])
      if(!is.na(excludeIndex))
        ticks <-ticks[-excludeIndex]
      if(nrow(ticks) == 0) {
        break;
      }else{
        endTimeInMs <- as.double(endTime) * 1000
        if(ticks[.N]$Timestamp >= endTimeInMs){
          history = rbind(history, ticks[Timestamp <= endTimeInMs])
          break;
        }
      }
      history <- rbind(history, ticks)
      tempStartTime <- history[.N]$Timestamp
    }
  }else{
    if(abs(count) < maxCount){
      history <- GetTicksFromWeb(server, symbol, tempStartTime, count)
    }else{
      history <- GetTicksFromWeb(server, symbol, tempStartTime, maxCount * sign(count))
    }
  }
  history$Timestamp <- as.POSIXct(history$Timestamp/1000, origin = "1970-01-01", tz = "GMT")
  setkey(history, Timestamp)
  return(history)
}

GetBidAskBar <- function(server, symbol, periodicity = "M1", startTime, endTime, count) {
  bidBars <- GetBars(server, symbol, barsType = "Bid", periodicity, startTime, endTime, count)
  askBars <- GetBars(server, symbol, barsType = "Ask", periodicity, startTime, endTime, count)
  bidAskBars <- merge(bidBars, askBars)
  colnames(bidAskBars) <- c("Timestamp", "BidVolume", "BidClose", "BidLow", "BidHigh", "BidOpen",
                            "AskVolume", "AskClose", "AskLow", "AskHigh", "AskOpen")
  return(bidAskBars)
}

#' Set the server from which the info will be read
#'@param serverName a character. Server
#'@param port a numeric. Port number
#'@examples
#'connection <- ttInitialize(serverName = "cryptottlivewebapi.xbtce.net", port = "8443")
#'
#'symbols <- connection$GetSymbolsInfo()
#'
#'bars <- connection$GetBarsHistrory("BTCUSD", barsType = "Bid", periodicity = "M1", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"), count = 0)
#'
#'ticks <- connection$GetTickHistory("BTCUSD", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"), count = 0)
#'
#'currentQuotes <- connection$GetCurrentQuotes()
#'@export
ttInitialize <- function(serverName = "cryptottlivewebapi.xbtce.net", port = "8443"){
  options(scipen = 999, digits.secs = 6)
  require(data.table)
  require(jsonlite)
  require(httr)
  options(httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE, sslversion = 6))
  options(scipen = 999, digits.secs = 6)

  server <- paste(serverName, port, sep = ":")
  list(
    GetSymbolsInfo = function(){
      return(GetSymbolsInfoFromWeb(server))
    },
    GetCurrentQuotes = function() {
      return(GetCurrentQuotesFromWeb(server))
    },
    GetBarsHistory = function(symbol, barsType = "Bid", periodicity = "M1", startTime, endTime = as.POSIXct(Sys.Date(), tz = "GMT"), count = 0){
      if(barsType == "BidAsk"){
        return(GetBidAskBar(server, symbol, periodicity, startTime, endTime, count))
      }
      if(barsType == "Bid" | barsType == "Ask"){
        return(GetBars(server, symbol, barsType, periodicity, startTime, endTime, count))
      }
      stop("Wrong barsType")
    },
    GetTickHistory = function(symbol, startTime, endTime = as.POSIXct(Sys.Date(), tz = "GMT"), count = 0) {
      return(GetTicks(server, symbol, startTime, endTime, count))
    },
    GetTicksByTimestamp = function(timestamp) {
      symbols <- GetSymbolsInfoFromWeb(server)
      symbols <- symbols[!grepl("_L$", symbols$Symbol)]
      symbols <- symbols[!grepl("#", symbols$Symbol)]
      quotes <- foreach(symbol = symbols$Symbol, .combine = rbind) %do%{
        quote <- GetTicks(server, symbol, timestamp, timestamp, -1)
        quote <- quote[, Symbol:= symbol]
        quote
      }
      return(quotes)
    }
  )
}
