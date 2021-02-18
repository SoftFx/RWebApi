ttPublicClient <- InitPublicWebClient(server = "ttlivewebapi.fxopen.com")

test_that("Is Last 10 Ticks right format", {
  ticks <- ttPublicClient$GetTicksFromWeb("EURUSD", round(as.double(now("UTC")) * 1000), count = -10)
  expect_equal(typeof(ticks), "list")
  expect_true(is.data.table(ticks))
  ticksColNames <- colnames(ticks)
  expect_identical(ticksColNames, c("Timestamp", "BidPrice", "BidVolume", "BidType","AskPrice","AskVolume", "AskType"  ))
})
