#' Set options to use number in normal format
options(scipen = 999)

#' Get current time in ms
getTimestamp = function() {
  return(round(as.double(Sys.time()) * 1000))
}

#' Generate HMAC Headers from
getHMACHeaders = function(url, id, key, secret, method = "GET", body = "") {
  timestamp1 <- getTimestamp()
  signature <- paste0(timestamp1, id, key, method, url, body)
  hash_value <- base64enc::base64encode(hmac(secret, signature, algo = "sha256", raw = TRUE))
  auth_value <- paste("HMAC",paste(id, key, timestamp1, hash_value, sep = ":"))
  return(auth_value)
}

#' RTTWebClient Class
#' @name RTTWebClient
#' @field web_api_address. Server address. Character
#' @field web_api_port. Port. Integer
#' @field web_api_id. Web Api Id. Character
#' @field web_api_key. Web Api Key. Character
#' @field web_api_secrer. Web Api Secret. Character
#' @exportClass RTTWebClient
RTTWebClient <- setRefClass("RTTWebClient",
                           fields = list(web_api_address = "character",
                                         web_api_port = "integer",
                                         web_api_id = "character",
                                         web_api_key = "character",
                                         web_api_secret= "character")
                           )


#' Get All Dividend by private connection
#' @name GetDividendsFromWeb
#' @return a data.table with dividends.
RTTWebClient$methods(
  GetDividendsFromWeb = function() {
    url_rel <- paste("/api/v2/dividend")
    address <- .self$web_api_address
    if(!grepl("^https://", address))
      address <- paste0("https://", address)

    portPattern <- paste0(":", .self$web_api_port, "$")
    if(!grepl(portPattern, address))
      address <- paste0(address, ":", .self$web_api_port)

    url_abs <- paste0(address, url_rel)
    connect <- httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE),
                         add_headers(Authorization = getHMACHeaders(url_abs, .self$web_api_id, .self$web_api_key, .self$web_api_secret)))
    data <- httr::content(connect, "text", encoding = "UTF-8")
    if(connect$status_code != 200) {
      stop(paste("status_code is not OK", connect$status_code, as.character(data)))
    }
    dividends <- fromJSON(data)
    dividends <- as.data.table(dividends)
    return(dividends)
  }
)

#' Get All Dividend by public connection
#' @name GetPublicDividendsFromWeb
#' @return a data.table with dividends.
RTTWebClient$methods(
  GetDividendsFromWeb = function() {
    url_rel <- paste("/api/v2/public/dividend")
    address <- .self$web_api_address
    if(!grepl("^https://", address))
      address <- paste0("https://", address)

    portPattern <- paste0(":", .self$web_api_port, "$")
    if(!grepl(portPattern, address))
      address <- paste0(address, ":", .self$web_api_port)

    url_abs <- paste0(address, url_rel)
    connect <- httr::GET(url_abs, httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L, verbose = FALSE))
    data <- httr::content(connect, "text", encoding = "UTF-8")
    if(connect$status_code != 200) {
      stop(paste("status_code is not OK", connect$status_code, as.character(data)))
    }
    dividends <- fromJSON(data)
    dividends <- as.data.table(dividends)
    return(dividends)
  }
)


