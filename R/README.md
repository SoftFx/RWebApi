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