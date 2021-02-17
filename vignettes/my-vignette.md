---
title: "my-vignette"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{my-vignette}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---




```r
library(RTTWebClient)
library(lubridate)
#> Warning in Sys.timezone(): unable to identify current timezone 'C':
#> please set environment variable 'TZ'
#> 
#> Attaching package: 'lubridate'
#> The following objects are masked from 'package:RTTWebClient':
#> 
#>     hour, isoweek, mday, minute, month, quarter, second, wday, week,
#>     yday, year
#> The following objects are masked from 'package:base':
#> 
#>     date, intersect, setdiff, union
```

# Example of RTTWebApi methods (basic class)

## Init Public(default) Client Obj (reference R class)

```r
ttWebClient <- InitPublicWebClient(server = "ttlivewebapi.fxopen.com")
#or use InitPrivateWebClient(server = "tt.tt-ag.st.soft-fx.eu", port = 8443, id = "", key = "", secret = "") to set a private connect. Need set HMAC id, key and secret
```

## Get Dividends data.table

```r
print(ttWebClient$GetDividendsFromWeb())
#>               Time   Fee GrossRate                 Id Symbol
#>   1: 1575469800000 0.010   0.62000 637109102118537856   QCOM
#>   2: 1575901800000 0.015   0.06000 637111300181153920   GCAP
#>   3: 1575556200000 0.015   0.22987 637111339454521216    SQM
#>   4: 1583280000000 0.010   0.62000 637188401729915648   QCOM
#>   5: 1583280000000 0.010   3.63000 637188401841963136    BLK
#>  ---                                                        
#> 584: 1606833015000 0.010  10.00000 637417728857099776   COST
#> 585: 1607524215000 0.010   0.41500 637417728857099776    PPL
#> 586: 1607005815000 0.010   0.79000 637418593174907520    GPC
#> 587: 1610116215000 0.010   0.24500 637418593174907520    HRL
#> 588: 1606746615000 0.010   1.29000 637422049204887552    MCD
```

## Get Symbol data.table

```r
print(ttWebClient$GetSymbolsInfoFromWeb())
#>       DefaultSlippage MinCommission LimitsCommission Commission TradeAmountStep
#>    1:            0.02             0                0          0             0.1
#>    2:            0.02             0                0          0             0.1
#>    3:            0.02             0                0          0             0.1
#>    4:            0.02             0                0          0             0.1
#>    5:            0.02             0                0          0             0.1
#>   ---                                                                          
#> 1446:            0.02             0                0          0             1.0
#> 1447:            0.02             0                0          0             1.0
#> 1448:            0.02             0                0          0             1.0
#> 1449:            0.02             0                0          0             1.0
#> 1450:            0.02             0                0          0             1.0
#>       MaxTradeAmount MinTradeAmount IsLongOnly IsCloseOnly SwapEnabled
#>    1:          10000            0.1      FALSE       FALSE        TRUE
#>    2:          10000            0.1      FALSE       FALSE        TRUE
#>    3:          10000            0.1      FALSE       FALSE        TRUE
#>    4:          10000            0.1      FALSE       FALSE        TRUE
#>    5:          10000            0.1      FALSE       FALSE        TRUE
#>   ---                                                                 
#> 1446:         100000            1.0      FALSE       FALSE        TRUE
#> 1447:         100000            1.0      FALSE       FALSE        TRUE
#> 1448:         100000            1.0      FALSE       FALSE        TRUE
#> 1449:         100000            1.0      FALSE       FALSE        TRUE
#> 1450:         100000            1.0      FALSE       FALSE        TRUE
#>       IsTradeAllowed TripleSwapDay SwapSizeLong SwapSizeShort    Color
#>    1:           TRUE             3      -0.0225       -0.0175 -4173747
#>    2:          FALSE             3      -0.0225       -0.0175 -4173747
#>    3:           TRUE             3      -0.0153       -0.0247 -4173747
#>    4:          FALSE             3      -0.0153       -0.0247 -4173747
#>    5:           TRUE             3      -0.0153       -0.0247 -4173747
#>   ---                                                                 
#> 1446:          FALSE             3      -0.0150       -0.0450 -3278081
#> 1447:           TRUE             3      -0.0150       -0.0450 -3278081
#> 1448:          FALSE             3      -0.0150       -0.0450 -3278081
#> 1449:           TRUE             3      -0.0150       -0.0450 -3278081
#> 1450:          FALSE             3      -0.0150       -0.0450 -3278081
#>       ProfitCurrencyPrecision MarginCurrencyPrecision Precision
#>    1:                       2                       2         1
#>    2:                       2                       2         1
#>    3:                       2                       2         1
#>    4:                       2                       2         1
#>    5:                       2                       2         1
#>   ---                                                          
#> 1446:                       2                       2         2
#> 1447:                       2                       2         2
#> 1448:                       2                       2         2
#> 1449:                       2                       2         2
#> 1450:                       2                       2         2
#>       HiddenLimitOrderMarginReduction StopOrderMarginReduction MarginFactor
#>    1:                               1                        1         0.02
#>    2:                               1                        1         0.02
#>    3:                               1                        1         0.02
#>    4:                               1                        1         0.02
#>    5:                               1                        1         0.02
#>   ---                                                                      
#> 1446:                               1                        1         0.20
#> 1447:                               1                        1         0.20
#> 1448:                               1                        1         0.20
#> 1449:                               1                        1         0.20
#> 1450:                               1                        1         0.20
#>       MarginHedged ContractSize MarginMode ProfitMode       SwapType
#>    1:          0.5           10        CFD        CFD PercentPerYear
#>    2:          0.5           10        CFD        CFD PercentPerYear
#>    3:          0.5           10        CFD        CFD PercentPerYear
#>    4:          0.5           10        CFD        CFD PercentPerYear
#>    5:          0.5           10        CFD        CFD PercentPerYear
#>   ---                                                               
#> 1446:          0.5            1        CFD        CFD PercentPerYear
#> 1447:          0.5            1        CFD        CFD PercentPerYear
#> 1448:          0.5            1        CFD        CFD PercentPerYear
#> 1449:          0.5            1        CFD        CFD PercentPerYear
#> 1450:          0.5            1        CFD        CFD PercentPerYear
#>       CommissionType CommissionChargeType SlippageType         ExtendedName
#>    1:     Percentage              PerDeal      Percent          S&P ASX 200
#>    2:     Percentage              PerDeal      Percent          S&P ASX 200
#>    3:     Percentage              PerDeal      Percent         Eurostoxx 50
#>    4:     Percentage              PerDeal      Percent         Eurostoxx 50
#>    5:     Percentage              PerDeal      Percent               CAC 40
#>   ---                                                                      
#> 1446:     Percentage               PerLot      Percent Zions Bancorporation
#> 1447:     Percentage               PerLot      Percent           Zoom Video
#> 1448:     Percentage               PerLot      Percent           Zoom Video
#> 1449:     Percentage               PerLot      Percent               Zoetis
#> 1450:     Percentage               PerLot      Percent               Zoetis
#>                 SecurityDescription     SecurityName StatusGroupId
#>    1:               Indices Group 1      CFD Index 1     CFD 00-01
#>    2:  Last trades: Indices Group 1      CFD Index 1     CFD 00-01
#>    3:               Indices Group 1      CFD Index 1     CFD 00-01
#>    4:  Last trades: Indices Group 1      CFD Index 1     CFD 00-01
#>    5:               Indices Group 1      CFD Index 1     CFD 00-01
#>   ---                                                             
#> 1446: Last trades: US Stocks & ETFs US Stocks & ETFs     US Stocks
#> 1447:              US Stocks & ETFs US Stocks & ETFs     US Stocks
#> 1448: Last trades: US Stocks & ETFs US Stocks & ETFs     US Stocks
#> 1449:              US Stocks & ETFs US Stocks & ETFs     US Stocks
#> 1450: Last trades: US Stocks & ETFs US Stocks & ETFs     US Stocks
#>       MinCommissionCurrency  Schedule
#>    1:                   USD CFD 00-01
#>    2:                   USD CFD 00-01
#>    3:                   USD CFD 00-01
#>    4:                   USD CFD 00-01
#>    5:                   USD CFD 00-01
#>   ---                                
#> 1446:                   USD US Stocks
#> 1447:                   USD US Stocks
#> 1448:                   USD US Stocks
#> 1449:                   USD US Stocks
#> 1450:                   USD US Stocks
#>                                           Description ProfitCurrency
#>    1:                    Australia 200 Index (AUS200)            AUD
#>    2:       Last trades: Australia 200 Index (AUS200)            AUD
#>    3:                         Europe 50 Index (ESX50)            EUR
#>    4:            Last trades: Europe 50 Index (ESX50)            EUR
#>    5:                          France 40 Index (FCHI)            EUR
#>   ---                                                               
#> 1446:   Last trades: Zions Bancorporation N.A. (ZION)            USD
#> 1447:              Zoom Video Communications Inc (ZM)            USD
#> 1448: Last trades: Zoom Video Communications Inc (ZM)            USD
#> 1449:                       Zoetis Inc. Class A (ZTS)            USD
#> 1450:          Last trades: Zoetis Inc. Class A (ZTS)            USD
#>       MarginCurrency    Symbol         ISIN
#>    1:            ASX   #AUS200 XC0006013624
#>    2:            ASX #AUS200_L XC0006013624
#>    3:            ESX    #ESX50 EU0009658145
#>    4:            ESX  #ESX50_L EU0009658145
#>    5:            CAC     #FCHI FR0003500008
#>   ---                                      
#> 1446:           ZION    ZION_L US9897011071
#> 1447:             ZM        ZM US98980L1017
#> 1448:             ZM      ZM_L US98980L1017
#> 1449:            ZTS       ZTS US98978V1035
#> 1450:            ZTS     ZTS_L US98978V1035
```

## Get BarHistory data.table

```r
print(ttWebClient$GetBarFromWeb("EURUSD", "Bid","M1", round(as.double(now("UTC")) * 1000), count = -10))
#>        Volume   Close     Low    High    Open     Timestamp
#>  1:  20800000 1.21059 1.21059 1.21071 1.21069 1613496240000
#>  2:  13000000 1.21056 1.21045 1.21059 1.21059 1613496300000
#>  3:  12400000 1.21069 1.21046 1.21070 1.21055 1613496360000
#>  4:  11200000 1.21070 1.21065 1.21076 1.21069 1613496420000
#>  5:  74550000 1.21075 1.21070 1.21080 1.21071 1613496480000
#>  6:  17400000 1.21078 1.21071 1.21080 1.21076 1613496540000
#>  7:  15200000 1.21081 1.21076 1.21086 1.21078 1613496600000
#>  8: 206350000 1.21078 1.21072 1.21080 1.21075 1613496660000
#>  9:  14400000 1.21079 1.21073 1.21080 1.21080 1613496720000
#> 10:   6800000 1.21088 1.21075 1.21090 1.21079 1613496780000
```


#Example of RTTWebApiHost (Wrapper about RTTWebClient to make request from R easy)

## Init RTTWebApiHost obj

```r
ttWebApiHost <- InitRTTWebApiHost(server = "ttlivewebapi.fxopen.com")
```

## Get Dividends data.table

```r
print(ttWebApiHost$GetDividends())
#>               Time   Fee GrossRate                 Id Symbol
#>   1: 1575469800000 0.010   0.62000 637109102118537856   QCOM
#>   2: 1575901800000 0.015   0.06000 637111300181153920   GCAP
#>   3: 1575556200000 0.015   0.22987 637111339454521216    SQM
#>   4: 1583280000000 0.010   0.62000 637188401729915648   QCOM
#>   5: 1583280000000 0.010   3.63000 637188401841963136    BLK
#>  ---                                                        
#> 584: 1606833015000 0.010  10.00000 637417728857099776   COST
#> 585: 1607524215000 0.010   0.41500 637417728857099776    PPL
#> 586: 1607005815000 0.010   0.79000 637418593174907520    GPC
#> 587: 1610116215000 0.010   0.24500 637418593174907520    HRL
#> 588: 1606746615000 0.010   1.29000 637422049204887552    MCD
```

## Get Symbol data.table

```r
print(ttWebApiHost$GetSymbolsInfo())
#>       DefaultSlippage MinCommission LimitsCommission Commission TradeAmountStep
#>    1:            0.02             0                0          0             0.1
#>    2:            0.02             0                0          0             0.1
#>    3:            0.02             0                0          0             0.1
#>    4:            0.02             0                0          0             0.1
#>    5:            0.02             0                0          0             0.1
#>   ---                                                                          
#> 1446:            0.02             0                0          0             1.0
#> 1447:            0.02             0                0          0             1.0
#> 1448:            0.02             0                0          0             1.0
#> 1449:            0.02             0                0          0             1.0
#> 1450:            0.02             0                0          0             1.0
#>       MaxTradeAmount MinTradeAmount IsLongOnly IsCloseOnly SwapEnabled
#>    1:          10000            0.1      FALSE       FALSE        TRUE
#>    2:          10000            0.1      FALSE       FALSE        TRUE
#>    3:          10000            0.1      FALSE       FALSE        TRUE
#>    4:          10000            0.1      FALSE       FALSE        TRUE
#>    5:          10000            0.1      FALSE       FALSE        TRUE
#>   ---                                                                 
#> 1446:         100000            1.0      FALSE       FALSE        TRUE
#> 1447:         100000            1.0      FALSE       FALSE        TRUE
#> 1448:         100000            1.0      FALSE       FALSE        TRUE
#> 1449:         100000            1.0      FALSE       FALSE        TRUE
#> 1450:         100000            1.0      FALSE       FALSE        TRUE
#>       IsTradeAllowed TripleSwapDay SwapSizeLong SwapSizeShort    Color
#>    1:           TRUE             3      -0.0225       -0.0175 -4173747
#>    2:          FALSE             3      -0.0225       -0.0175 -4173747
#>    3:           TRUE             3      -0.0153       -0.0247 -4173747
#>    4:          FALSE             3      -0.0153       -0.0247 -4173747
#>    5:           TRUE             3      -0.0153       -0.0247 -4173747
#>   ---                                                                 
#> 1446:          FALSE             3      -0.0150       -0.0450 -3278081
#> 1447:           TRUE             3      -0.0150       -0.0450 -3278081
#> 1448:          FALSE             3      -0.0150       -0.0450 -3278081
#> 1449:           TRUE             3      -0.0150       -0.0450 -3278081
#> 1450:          FALSE             3      -0.0150       -0.0450 -3278081
#>       ProfitCurrencyPrecision MarginCurrencyPrecision Precision
#>    1:                       2                       2         1
#>    2:                       2                       2         1
#>    3:                       2                       2         1
#>    4:                       2                       2         1
#>    5:                       2                       2         1
#>   ---                                                          
#> 1446:                       2                       2         2
#> 1447:                       2                       2         2
#> 1448:                       2                       2         2
#> 1449:                       2                       2         2
#> 1450:                       2                       2         2
#>       HiddenLimitOrderMarginReduction StopOrderMarginReduction MarginFactor
#>    1:                               1                        1         0.02
#>    2:                               1                        1         0.02
#>    3:                               1                        1         0.02
#>    4:                               1                        1         0.02
#>    5:                               1                        1         0.02
#>   ---                                                                      
#> 1446:                               1                        1         0.20
#> 1447:                               1                        1         0.20
#> 1448:                               1                        1         0.20
#> 1449:                               1                        1         0.20
#> 1450:                               1                        1         0.20
#>       MarginHedged ContractSize MarginMode ProfitMode       SwapType
#>    1:          0.5           10        CFD        CFD PercentPerYear
#>    2:          0.5           10        CFD        CFD PercentPerYear
#>    3:          0.5           10        CFD        CFD PercentPerYear
#>    4:          0.5           10        CFD        CFD PercentPerYear
#>    5:          0.5           10        CFD        CFD PercentPerYear
#>   ---                                                               
#> 1446:          0.5            1        CFD        CFD PercentPerYear
#> 1447:          0.5            1        CFD        CFD PercentPerYear
#> 1448:          0.5            1        CFD        CFD PercentPerYear
#> 1449:          0.5            1        CFD        CFD PercentPerYear
#> 1450:          0.5            1        CFD        CFD PercentPerYear
#>       CommissionType CommissionChargeType SlippageType         ExtendedName
#>    1:     Percentage              PerDeal      Percent          S&P ASX 200
#>    2:     Percentage              PerDeal      Percent          S&P ASX 200
#>    3:     Percentage              PerDeal      Percent         Eurostoxx 50
#>    4:     Percentage              PerDeal      Percent         Eurostoxx 50
#>    5:     Percentage              PerDeal      Percent               CAC 40
#>   ---                                                                      
#> 1446:     Percentage               PerLot      Percent Zions Bancorporation
#> 1447:     Percentage               PerLot      Percent           Zoom Video
#> 1448:     Percentage               PerLot      Percent           Zoom Video
#> 1449:     Percentage               PerLot      Percent               Zoetis
#> 1450:     Percentage               PerLot      Percent               Zoetis
#>                 SecurityDescription     SecurityName StatusGroupId
#>    1:               Indices Group 1      CFD Index 1     CFD 00-01
#>    2:  Last trades: Indices Group 1      CFD Index 1     CFD 00-01
#>    3:               Indices Group 1      CFD Index 1     CFD 00-01
#>    4:  Last trades: Indices Group 1      CFD Index 1     CFD 00-01
#>    5:               Indices Group 1      CFD Index 1     CFD 00-01
#>   ---                                                             
#> 1446: Last trades: US Stocks & ETFs US Stocks & ETFs     US Stocks
#> 1447:              US Stocks & ETFs US Stocks & ETFs     US Stocks
#> 1448: Last trades: US Stocks & ETFs US Stocks & ETFs     US Stocks
#> 1449:              US Stocks & ETFs US Stocks & ETFs     US Stocks
#> 1450: Last trades: US Stocks & ETFs US Stocks & ETFs     US Stocks
#>       MinCommissionCurrency  Schedule
#>    1:                   USD CFD 00-01
#>    2:                   USD CFD 00-01
#>    3:                   USD CFD 00-01
#>    4:                   USD CFD 00-01
#>    5:                   USD CFD 00-01
#>   ---                                
#> 1446:                   USD US Stocks
#> 1447:                   USD US Stocks
#> 1448:                   USD US Stocks
#> 1449:                   USD US Stocks
#> 1450:                   USD US Stocks
#>                                           Description ProfitCurrency
#>    1:                    Australia 200 Index (AUS200)            AUD
#>    2:       Last trades: Australia 200 Index (AUS200)            AUD
#>    3:                         Europe 50 Index (ESX50)            EUR
#>    4:            Last trades: Europe 50 Index (ESX50)            EUR
#>    5:                          France 40 Index (FCHI)            EUR
#>   ---                                                               
#> 1446:   Last trades: Zions Bancorporation N.A. (ZION)            USD
#> 1447:              Zoom Video Communications Inc (ZM)            USD
#> 1448: Last trades: Zoom Video Communications Inc (ZM)            USD
#> 1449:                       Zoetis Inc. Class A (ZTS)            USD
#> 1450:          Last trades: Zoetis Inc. Class A (ZTS)            USD
#>       MarginCurrency    Symbol         ISIN
#>    1:            ASX   #AUS200 XC0006013624
#>    2:            ASX #AUS200_L XC0006013624
#>    3:            ESX    #ESX50 EU0009658145
#>    4:            ESX  #ESX50_L EU0009658145
#>    5:            CAC     #FCHI FR0003500008
#>   ---                                      
#> 1446:           ZION    ZION_L US9897011071
#> 1447:             ZM        ZM US98980L1017
#> 1448:             ZM      ZM_L US98980L1017
#> 1449:            ZTS       ZTS US98978V1035
#> 1450:            ZTS     ZTS_L US98978V1035
```

## Get BarHistory data.table

```r
print(ttWebApiHost$GetBarsHistory("EURUSD", "Bid","M1", now("UTC") - days(1), now("UTC")))
#>          Volume   Close     Low    High    Open           Timestamp
#>    1:  59704000 1.21328 1.21326 1.21340 1.21336 2021-02-15 17:33:00
#>    2:  15300000 1.21327 1.21326 1.21329 1.21329 2021-02-15 17:34:00
#>    3:   2600000 1.21332 1.21327 1.21332 1.21327 2021-02-15 17:35:00
#>    4:  24804000 1.21330 1.21324 1.21336 1.21334 2021-02-15 17:36:00
#>    5:  22204000 1.21335 1.21330 1.21335 1.21330 2021-02-15 17:37:00
#>   ---                                                              
#> 1424:  17400000 1.21078 1.21071 1.21080 1.21076 2021-02-16 17:29:00
#> 1425:  15200000 1.21081 1.21076 1.21086 1.21078 2021-02-16 17:30:00
#> 1426: 206350000 1.21078 1.21072 1.21080 1.21075 2021-02-16 17:31:00
#> 1427:  14400000 1.21079 1.21073 1.21080 1.21080 2021-02-16 17:32:00
#> 1428:   7400000 1.21087 1.21075 1.21090 1.21079 2021-02-16 17:33:00
```

## Get TicksHistory data.table

```r
print(ttWebApiHost$GetTickHistory("EURUSD",  now("UTC") - days(1), now("UTC")))
#>                   Timestamp BidPrice BidVolume BidType AskPrice AskVolume
#>      1: 2021-02-15 17:33:37  1.21335    500000     Bid  1.21338    500000
#>      2: 2021-02-15 17:33:41  1.21330  11601000     Bid  1.21335   1500000
#>      3: 2021-02-15 17:33:41  1.21330  11601000     Bid  1.21334    500000
#>      4: 2021-02-15 17:33:42  1.21331    500000     Bid  1.21334   1000000
#>      5: 2021-02-15 17:33:43  1.21331    500000     Bid  1.21334   2500000
#>     ---                                                                  
#> 104698: 2021-02-16 17:33:31  1.21088    200000     Bid  1.21092    750000
#> 104699: 2021-02-16 17:33:34  1.21088    200000     Bid  1.21091    211000
#> 104700: 2021-02-16 17:33:35  1.21088    200000     Bid  1.21091    761000
#> 104701: 2021-02-16 17:33:35  1.21087    200000     Bid  1.21091    761000
#> 104702: 2021-02-16 17:33:35  1.21087    200000     Bid  1.21090    750000
#>         AskType
#>      1:     Ask
#>      2:     Ask
#>      3:     Ask
#>      4:     Ask
#>      5:     Ask
#>     ---        
#> 104698:     Ask
#> 104699:     Ask
#> 104700:     Ask
#> 104701:     Ask
#> 104702:     Ask
```
