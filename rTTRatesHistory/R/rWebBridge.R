GetBarFromWeb <- function(server, symbol, barsType, periodicity, startTimeMs, count){
  querryInit <- paste("https://", server,"/api/v1/public/quotehistory",symbol, periodicity, "bars", barsType, sep= "/")
  querry <- paste0(querryInit,"?","timestamp=",round(startTimeMs,0),"&count=", count)
  connect <- GET(querry, config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE))
  if(connect$status_code != 200) {
    stop(paste("status_code is not OK", connect$status_code))
  }
  data <- content(connect, "text", encoding = "UTF-8")
  bars <- fromJSON(data)
  bars <- as.data.table(bars$Bars)
  return(bars)
}

GetTicksFromWeb <- function(server, symbol, startTimeMs, count){
  querryInit <- paste("https://", server,"/api/v1/public/quotehistory",symbol, "ticks", sep= "/")
  querry <- paste0(querryInit,"?","timestamp=",round(startTimeMs, 0),"&count=", count)
  connect <- httr::GET(querry, config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE))
  if(connect$status_code != 200) {
    stop(paste("status_code is not OK", connect$status_code))
  }
  data <- content(connect, "text", encoding = "UTF-8")
  ticks <- fromJSON(data)
  ticks <- ticks$Ticks
  ticks <- data.table("Timestamp" = ticks$Timestamp, "BidPrice" = ticks$BestBid$Price,
                      "BidVolume" = ticks$BestBid$Volume, "BidType" = ticks$BestBid$Type,  "AskPrice" = ticks$BestAsk$Price,
                      "AskVolume" = ticks$BestAsk$Volume, "AskType" = ticks$BestAsk$Type)
  return(ticks)
}

GetSymbolsInfoFromWeb <- function(server){
  querry = paste0("https://", server, "/api/v1/public/symbol")
  connect = httr::GET(querry, config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE))
  if(connect$status_code != 200) {
    stop(paste("status_code is not OK", connect$status_code))
  }
  data = content(connect, "text", encoding = "UTF-8")
  data = fromJSON(data)
  symbols <- as.data.table(data)
  setkey(symbols, "Symbol")
  return(symbols)
}

GetCurrentQuotesFromWeb <- function(server) {
  querry <-  paste0("https://", server,"/api/v1/public/tick")
  connect <- httr::GET(querry, config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE))
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
}
