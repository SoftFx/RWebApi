
GetBars <- function(GetBarMethod, symbol, barsType = "Bid", periodicity = "M1", startTime, endTime, count) {
  tempStartTime <- as.double(startTime)*1000
  history <- data.table()
  maxCount <- 1000
  if(count == 0) {
    repeat{
      bars <- GetBarMethod(symbol, barsType, periodicity, tempStartTime, maxCount)
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
      history <- GetBarMethod(symbol, barsType, periodicity, tempStartTime, count)
    }else{
      history <- GetBarMethod(symbol, barsType, periodicity, tempStartTime, maxCount * sign(count))
    }
  }
  history$Timestamp <- as.POSIXct(history$Timestamp/1000, origin = "1970-01-01", tz = "GMT")
  setkey(history, Timestamp)
  return(history)
}

GetTicks <- function(GetTickMethod, symbol, startTime, endTime, count) {
  tempStartTime <- as.double(startTime)*1000
  history <- data.table()
  maxCount <- 1000
  if(count == 0) {
    repeat{
      ticks <- GetTickMethod(symbol, tempStartTime, maxCount)
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
      history <- GetTickMethod(symbol, tempStartTime, count)
    }else{
      history <- GetTickMethod(symbol, tempStartTime, maxCount * sign(count))
    }
  }
  history$Timestamp <- as.POSIXct(history$Timestamp/1000, origin = "1970-01-01", tz = "GMT")
  setkey(history, Timestamp)
  return(history)
}

GetBidAskBar <- function(GetBarMethod, symbol, periodicity = "M1", startTime, endTime, count) {
  bidBars <- GetBars(GetBarMethod, symbol, barsType = "Bid", periodicity, startTime, endTime, count)
  askBars <- GetBars(GetBarMethod, symbol, barsType = "Ask", periodicity, startTime, endTime, count)
  bidAskBars <- merge(bidBars, askBars)
  colnames(bidAskBars) <- c("Timestamp", "BidVolume", "BidClose", "BidLow", "BidHigh", "BidOpen",
                            "AskVolume", "AskClose", "AskLow", "AskHigh", "AskOpen")
  return(bidAskBars)
}

#' Set the server from which the info will be read
#' @param web_api_address a character. WebApi Address.
#' @param web_api_port an integer. WebAPI port. Deafault is 8443.
#' @param web_api_id a character. WebApi Id.
#' @param web_api_key a character. WebApi Key.
#' @param web_api_secret a character. WebApi Secret.
#' @import jsonlite
#' @import httr
#' @import data.table
#' @export
RWebApiClient <- function(web_api_address, web_api_port = 8443, web_api_id = NULL, web_api_key = NULL, web_api_secret= NULL){
  options(scipen = 999)
  getTimestamp = function() {
    return(round(as.double(Sys.time()) * 1000))
  }

  getHMACHeaders = function(url, id, key, secret, method = "GET", body = "") {
    timestamp1 <- getTimestamp()
    signature <- paste0(timestamp1, id, key, method, url, body)
    hash_value <- base64enc::base64encode(hmac(secret, signature, algo = "sha256", raw = TRUE))
    auth_value <- paste("HMAC",paste(id, key, timestamp1, hash_value, sep = ":"))
    return(auth_value)
  }
  list(
    GetDividensFromWeb = function() {
      url_rel <- paste("/api/v2/dividend")
      address <- web_api_address
      if(!grepl("^https://", address))
        address <- paste0("https://", address)

      portPattern <- paste0(":", web_api_port, "$")
      if(!grepl(portPattern, address))
        address <- paste0(address, ":", web_api_port)

      url_abs <- paste0(address, url_rel)
      connect <- httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE),
                           add_headers(Authorization = getHMACHeaders(url_abs, web_api_id, web_api_key, web_api_secret)))
      data <- httr::content(connect, "text", encoding = "UTF-8")
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code, as.character(data)))
      }
      dividends <- fromJSON(data)
      dividends <- as.data.table(dividends)
      return(dividends)
    },
    GetCurrentQuotesFromWeb = function() {
      url_rel <- paste("/api/v2/tick")
      address <- web_api_address
      if(!grepl("^https://", address))
        address <- paste0("https://", address)

      portPattern <- paste0(":", web_api_port, "$")
      if(!grepl(portPattern, address))
        address <- paste0(address, ":", web_api_port)

      url_abs <- paste0(address, url_rel)
      connect <- httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE),
                           add_headers(Authorization = getHMACHeaders(url_abs, web_api_id, web_api_key, web_api_secret)))
      data <- httr::content(connect, "text", encoding = "UTF-8")
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code, as.character(data)))
      }
      # data <- content(connect, "text", encoding = "UTF-8")
      ticks <- fromJSON(data)
      ticks <- data.table("TimeStamp" = ticks$Timestamp, "Symbol" = ticks$Symbol, "BidPrice" = ticks$BestBid$Price,
                          "BidVolume" = ticks$BestBid$Volume, "BidType" = ticks$BestBid$Type,  "AskPrice" = ticks$BestAsk$Price,
                          "AskVolume" = ticks$BestAsk$Volume, "AskType" = ticks$BestAsk$Type)
    },
    GetSymbolsInfoFromWeb = function(){
      url_rel <- paste("/api/v2/symbol")
      address <- web_api_address
      if(!grepl("^https://", address))
        address <- paste0("https://", address)

      portPattern <- paste0(":", web_api_port, "$")
      if(!grepl(portPattern, address))
        address <- paste0(address, ":", web_api_port)

      url_abs <- paste0(address, url_rel)
      connect <- httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE),
                           add_headers(Authorization = getHMACHeaders(url_abs, web_api_id, web_api_key, web_api_secret)))
      data <- httr::content(connect, "text", encoding = "UTF-8")
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code, as.character(data)))
      }
      data = fromJSON(data)
      symbols <- as.data.table(data)
      setkey(symbols, "Symbol")
      return(symbols)
    },
    GetBarFromWeb = function(symbol, barsType, periodicity, startTimeMs, count){
      url_rel <- paste("/api/v2/quotehistory",symbol, periodicity, "bars", barsType, sep= "/")
      url_rel <- paste0(url_rel,"?","timestamp=",round(startTimeMs, 0),"&count=", count)

      address <- web_api_address
      if(!grepl("^https://", address))
        address <- paste0("https://", address)

      portPattern <- paste0(":", web_api_port, "$")
      if(!grepl(portPattern, address))
        address <- paste0(address, ":", web_api_port)

      url_abs <- paste0(address, url_rel)

      connect <- httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE),
                           add_headers(Authorization = getHMACHeaders(url_abs, web_api_id, web_api_key, web_api_secret)))

      data <- httr::content(connect, "text", encoding = "UTF-8")
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code, as.character(data)))
      }
      bars <- fromJSON(data)
      bars <- as.data.table(bars$Bars)
      return(bars)
    },
    GetTicksFromWeb = function(symbol, startTimeMs, count){
      url_rel <- paste("/api/v2/quotehistory",symbol, "ticks", sep= "/")
      url_rel <- paste0(url_rel,"?","timestamp=",round(startTimeMs, 0),"&count=", count)

      address <- web_api_address
      if(!grepl("^https://", address))
        address <- paste0("https://", address)

      portPattern <- paste0(":", web_api_port, "$")
      if(!grepl(portPattern, address))
        address <- paste0(address, ":", web_api_port)

      url_abs <- paste0(address, url_rel)

      connect <- httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE),
                           add_headers(Authorization = getHMACHeaders(url_abs, web_api_id, web_api_key, web_api_secret)))
      data <- httr::content(connect, "text", encoding = "UTF-8")
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code, as.character(data)))
      }
      ticks <- fromJSON(data)
      ticks <- ticks$Ticks
      ticks <- data.table("Timestamp" = ticks$Timestamp, "BidPrice" = ticks$BestBid$Price,
                          "BidVolume" = ticks$BestBid$Volume, "BidType" = ticks$BestBid$Type,  "AskPrice" = ticks$BestAsk$Price,
                          "AskVolume" = ticks$BestAsk$Volume, "AskType" = ticks$BestAsk$Type)
      return(ticks)
    },
    GetPublicBarFromWeb = function(symbol, barsType, periodicity, startTimeMs, count){
      url_rel <- paste("/api/v2/public/quotehistory",symbol, periodicity, "bars", barsType, sep= "/")
      url_rel <- paste0(url_rel,"?","timestamp=",round(startTimeMs, 0),"&count=", count)

      address <- web_api_address
      if(!grepl("^https://", address))
        address <- paste0("https://", address)

      portPattern <- paste0(":", web_api_port, "$")
      if(!grepl(portPattern, address))
        address <- paste0(address, ":", web_api_port)

      url_abs <- paste0(address, url_rel)
      connect <- httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE))
      data <- httr::content(connect, "text", encoding = "UTF-8")
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code, as.character(data)))
      }
      bars <- fromJSON(data)
      bars <- as.data.table(bars$Bars)
      return(bars)
    },

    GetPublicTicksFromWeb = function(symbol, startTimeMs, count){
      url_rel <- paste("/api/v2/public/quotehistory",symbol, "ticks", sep= "/")
      url_rel <- paste0(url_rel,"?","timestamp=",round(startTimeMs, 0),"&count=", count)

      address <- web_api_address
      if(!grepl("^https://", address))
        address <- paste0("https://", address)

      portPattern <- paste0(":", web_api_port, "$")
      if(!grepl(portPattern, address))
        address <- paste0(address, ":", web_api_port)

      url_abs <- paste0(address, url_rel)
      connect <- httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE))
      data <- httr::content(connect, "text", encoding = "UTF-8")
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code, as.character(data)))
      }
      ticks <- fromJSON(data)
      ticks <- ticks$Ticks
      ticks <- data.table("Timestamp" = ticks$Timestamp, "BidPrice" = ticks$BestBid$Price,
                          "BidVolume" = ticks$BestBid$Volume, "BidType" = ticks$BestBid$Type,  "AskPrice" = ticks$BestAsk$Price,
                          "AskVolume" = ticks$BestAsk$Volume, "AskType" = ticks$BestAsk$Type)
      return(ticks)
    },
    GetPublicSymbolsInfoFromWeb = function(){
      url_rel <- paste("/api/v2/public/symbol")
      address <- web_api_address
      if(!grepl("^https://", address))
        address <- paste0("https://", address)

      portPattern <- paste0(":", web_api_port, "$")
      if(!grepl(portPattern, address))
        address <- paste0(address, ":", web_api_port)

      url_abs <- paste0(address, url_rel)
      connect = httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE))
      data <- httr::content(connect, "text", encoding = "UTF-8")
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code, as.character(data)))
      }
      data = fromJSON(data)
      symbols <- as.data.table(data)
      setkey(symbols, "Symbol")
      return(symbols)
    },
    GetPublicCurrentQuotesFromWeb = function() {
      url_rel <- paste("/api/v2/public/tick")
      address <- web_api_address
      if(!grepl("^https://", address))
        address <- paste0("https://", address)

      portPattern <- paste0(":", web_api_port, "$")
      if(!grepl(portPattern, address))
        address <- paste0(address, ":", web_api_port)

      url_abs <- paste0(address, url_rel)
      connect <- httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE))
      data <- httr::content(connect, "text", encoding = "UTF-8")
      if(connect$status_code != 200) {
        stop(paste("status_code is not OK", connect$status_code, as.character(data)))
      }
      ticks <- fromJSON(data)
      ticks <- data.table("TimeStamp" = ticks$Timestamp, "Symbol" = ticks$Symbol, "BidPrice" = ticks$BestBid$Price,
                          "BidVolume" = ticks$BestBid$Volume, "BidType" = ticks$BestBid$Type,  "AskPrice" = ticks$BestAsk$Price,
                          "AskVolume" = ticks$BestAsk$Volume, "AskType" = ticks$BestAsk$Type)

      setkey(ticks, Symbol)
      return(ticks)
    }

  )
}


#' Set the server from which the info will be read
#' @param web_api_address a character. WebApi Address.
#' @param web_api_port an integer. WebAPI port. Deafault is 8443.
#' @param web_api_id a character. WebApi Id.
#' @param web_api_key a character. WebApi Key.
#' @param web_api_secret a character. WebApi Secret.
#' @import jsonlite
#' @import httr
#' @import data.table
#' @export
ttInitialize <- function(web_api_address, web_api_port = 8443, web_api_id, web_api_key, web_api_secret){
  options(scipen = 999, digits.secs = 6)
  options(httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE, sslversion = 6))
  webApiClient <- RWebApiClient(web_api_address, web_api_port, web_api_id, web_api_key, web_api_secret)
  list(
    GetDividends = function() {
      return(webApiClient$GetDividensFromWeb())
    },
    GetSymbolsInfo = function(){
      return(webApiClient$GetSymbolsInfoFromWeb())
    },
    GetCurrentQuotes = function() {
      return(webApiClient$GetCurrentQuotesFromWeb())
    },
    GetBarsHistory = function(symbol, barsType = "Bid", periodicity = "M1", startTime, endTime = as.POSIXct(Sys.Date(), tz = "GMT"), count = 0){
      if(barsType == "BidAsk"){
        return(GetBidAskBar(webApiClient$GetBarFromWeb, symbol, periodicity, startTime, endTime, count))
      }
      if(barsType == "Bid" | barsType == "Ask"){
        return(GetBars(webApiClient$GetBarFromWeb, symbol, barsType, periodicity, startTime, endTime, count))
      }
      stop("Wrong barsType")
    },
    GetTickHistory = function(symbol, startTime, endTime = as.POSIXct(Sys.Date(), tz = "GMT"), count = 0) {
      return(GetTicks(webApiClient$GetTicksFromWeb, symbol, startTime, endTime, count))
    },
    GetTicksByTimestamp = function(timestamp) {
      symbols <- webApiClient$GetSymbolsInfoFromWeb()
      symbols <- symbols[!grepl("_L$", symbols$Symbol)]
      quotes <- foreach(symbol = symbols$Symbol, .combine = rbind) %do%{
        quote <- GetTicks(webApiClient$GetTicksFromWeb, sub("#", "%23", symbol), timestamp, timestamp, -1)
        quote <- quote[, Symbol:= symbol]
        quote
      }
      return(quotes)
    },
    GetPublicSymbolInfo = function(){
      return(webApiClient$GetPublicSymbolsInfoFromWeb())
    }, GetCurrentQuotes = function() {
      return(webApiClient$GetCurrentQuotesFromWeb())
    },
    GetPublicBarsHistory = function(symbol, barsType = "Bid", periodicity = "M1", startTime, endTime = as.POSIXct(Sys.Date(), tz = "GMT"), count = 0){
      if(barsType == "BidAsk"){
        return(GetBidAskBar(webApiClient$GetPublicBarFromWeb, symbol, periodicity, startTime, endTime, count))
      }
      if(barsType == "Bid" | barsType == "Ask"){
        return(GetBars(webApiClient$GetPublicBarFromWeb, symbol, barsType, periodicity, startTime, endTime, count))
      }
      stop("Wrong barsType")
    },
    GetPublicTickHistory = function(symbol, startTime, endTime = as.POSIXct(Sys.Date(), tz = "GMT"), count = 0) {
      return(GetTicks(webApiClient$GetPublicTicksFromWeb, symbol, startTime, endTime, count))
    },
    GetPublicTicksByTimestamp = function(timestamp) {
      symbols <- webApiClient$GetSymbolsInfoFromWeb()
      symbols <- symbols[!grepl("_L$", symbols$Symbol)]
      quotes <- foreach(symbol = symbols$Symbol, .combine = rbind) %do%{
        quote <- GetTicks(webApiClient$GetPublicTicksFromWeb, sub("#", "%23", symbol), timestamp, timestamp, -1)
        quote <- quote[, Symbol:= symbol]
        quote
      }
      return(quotes)
    },
    GetPublicCurrentQuotes = function() {
      return(webApiClient$GetPublicCurrentQuotesFromWeb())
    }
  )
}

# webApiClient <- RWebApiClient(web_api_address <- "https://alpha.tts.st.soft-fx.eu:8443",
#                               web_api_id <- "92c1546a-31ba-4fef-8474-6fbcb5908c37",
#                               web_api_key <- "2zXSFsXKaWQTsdsA",
#                               web_api_secret <- "dc6gRYMrJ2FMjQarJDARKHPzQ4Z9pF99aezX6ZJHBNJGZW4f442HGqGExEBZ8Mbc")
#
#
#
# web_api_address <- "https://ttlivewebapi.fxopen.net:8443"
# web_api_id <- "1d9d98ab-7585-4662-8ce1-cdca38bd3471"
# web_api_key <- "PgQM7Ze8b5xGNzYn"
# web_api_secret <- "qy9txmCdeGsDcpgTYd54DQd5CczzxS4YDQfFX6W7KHT25e2CtrJJEDhHtd3tYcQw"

# connect <- ttInitialize(web_api_address, web_api_id, web_api_key, "")
#
# connect$GetBarsHistory("EURUSD", "Bid", "M1", now("UTC"), count = -1)
# connect$GetPublicBarsHistory("EURUSD", "Bid", "M1", now("UTC"), count = -1)
