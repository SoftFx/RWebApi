
GetBars <- function(server, symbol, barsType = "Bid", periodicity = "M1", startTime, endTime) {
  querryInit <- paste("https://", server,"/api/v1/public/quotehistory",symbol, periodicity, "bars", barsType, sep= "/")
  startTime <- as.double(startTime)*1000
  tempStartTime <- startTime
  history <- data.table()
  repeat{
    querry <- paste0(querryInit,"?","timestamp=",tempStartTime,"&count=", 1000)
    connect <- GET(querry, config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE, sslversion = 6))
    if(connect$status_code != 200) {
      stop(paste("status_code is not OK", connect$status_code))
    }
    data <- content(connect, "text", encoding = "UTF-8")
    bars <- fromJSON(data)
    bars <- as.data.table(bars$Bars)
    bars <- bars[, Timestamp:= Timestamp/1000]
    bars <- bars[, Timestamp:=as.POSIXct(Timestamp, origin = "1970-01-01", tz = "GMT")]
    excludeIndex <-ifelse(is.null(history[.N]$Timestamp), numeric(0), bars[Timestamp==history[.N]$Timestamp,which=T])
    if(!is.na(excludeIndex))
      bars <-bars[-excludeIndex]
    if(nrow(bars) == 0) {
      break;
    }else{
      if(bars[.N]$Timestamp >= endTime){
        history = rbind(history, bars[Timestamp <= endTime])
        break;
      }
    }
    history <- rbind(history, bars)
    tempStartTime <- as.double(history[.N]$Timestamp)*1000
  }
  setkey(history, Timestamp)
  return(history)
}

GetBidAskBar <- function(server, symbol, periodicity = "M1", startTime, endTime) {
  bidBars <- GetBars(server, symbol, barsType = "Bid", periodicity, startTime, endTime)
  askBars <- GetBars(server, symbol, barsType = "Ask", periodicity, startTime, endTime)
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
#'bars <- connection$GetBarsHistrory("BTCUSD", barsType = "Bid", periodicity = "M1", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"))
#'
#'ticks <- connection$GetTickHistory("BTCUSD", as.POSIXct("2018-10-12 00:00:00", tz = "GMT"), as.POSIXct("2018-10-12 05:00:00", tz = "GMT"))
#'
#'currentQuotes <- connection$GetCurrentQuotes()
#'@export
ttInitialize <- function(serverName = "cryptottlivewebapi.xbtce.net", port = "8443"){
  options(scipen = 999, digits.secs = 6)
  require(data.table)
  require(jsonlite)
  require(httr)
  server <- paste(serverName, port, sep = ":")
  list(
    GetSymbolsInfo = function(){
      querry = paste0("https://", server, "/api/v1/public/symbol")
      connect = GET(querry, config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE, sslversion = 6))
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code))
      }
      data = content(connect, "text", encoding = "UTF-8")
      data = fromJSON(data)
      symbols <- as.data.table(data)
      setkey(symbols, "Symbol")
      return(symbols)
    },
    GetCurrentQuotes = function() {
      querry <-  paste0("https://", server,"/api/v1/public/tick")
      connect <- GET(querry, config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE, sslversion = 6))
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code))
      }
      data <- content(connect, "text", encoding = "UTF-8")
      ticks <- fromJSON(data)
      ticks <- data.table("TimeStamp" = ticks$Timestamp, "Symbol" = ticks$Symbol, "BidPrice" = ticks$BestBid$Price,
                          "BidVolume" = ticks$BestBid$Volume, "BidType" = ticks$BestBid$Type,  "AskPrice" = ticks$BestAsk$Price,
                          "AskVolume" = ticks$BestAsk$Volume, "AskType" = ticks$BestAsk$Type)

      setkey(ticks, Symbol)
      return(ticks)
    },
    GetBarsHistrory = function(symbol, barsType = "Bid", periodicity = "M1", startTime, endTime){
      if(barsType == "BidAsk"){
        return(GetBidAskBar(server, symbol, periodicity, startTime, endTime))
      }
      if(barsType == "Bid" | barsType == "Ask"){
        return(GetBars(server, symbol, barsType, periodicity, startTime, endTime))
      }
      stop("Wrong barsType")
    },
    GetTickHistory = function(symbol, startTime, endTime) {
      querryInit <- paste("https://", server,"/api/v1/public/quotehistory",symbol, "ticks", sep= "/")
      startTime <- as.double(startTime)*1000
      tempStartTime <- startTime
      history <- data.table()
      httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE, sslversion = 6)
      repeat{
        querry <- paste0(querryInit,"?","timestamp=",tempStartTime,"&count=", 1000)
        connect <- GET(querry)
        if(connect$status_code != 200) {
          stop(paste("status_code is not OK", connect$status_code))
        }
        data <- content(connect, "text", encoding = "UTF-8")
        ticks <- fromJSON(data)
        ticks <- ticks$Ticks
        ticks <- data.table("Timestamp" = ticks$Timestamp, "BidPrice" = ticks$BestBid$Price,
                            "BidVolume" = ticks$BestBid$Volume, "BidType" = ticks$BestBid$Type,  "AskPrice" = ticks$BestAsk$Price,
                            "AskVolume" = ticks$BestAsk$Volume, "AskType" = ticks$BestAsk$Type)
        ticks <- ticks[, Timestamp:= Timestamp/1000]
        ticks <- ticks[,Timestamp:=as.POSIXct(Timestamp, origin = "1970-01-01", tz = "GMT")]
        excludeIndex <-ifelse(is.null(history[.N]$Timestamp), numeric(0), ticks[Timestamp==history[.N]$Timestamp,which=T])
        if(!is.na(excludeIndex))
          ticks <-ticks[-excludeIndex]
        if(nrow(ticks) == 0) {
          break;
        }else{
          if(ticks[.N]$Timestamp >= endTime){
            history = rbind(history, ticks[Timestamp <= endTime])
            break;
          }
        }
        history <- rbind(history, ticks)
        tempStartTime <- as.double(history[.N]$Timestamp)*1000
        # tempStartTime1 = as.POSIXct(tempStartTime/1000, origin = "1970-01-01", tz = "GMT")
      }
      setkey(history, Timestamp)
      return(history)
    }
  )
}
