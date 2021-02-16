ttWebHost <- InitRTTWebApiHost(server = "tt.tt-ag.st.soft-fx.eu")

test_that("Is Dividends right format", {
  divs = ttWebHost$GetDividends()
  expect_equal(typeof(divs), "list")
  expect_true(is.data.table(divs))
  divsColNames <- colnames(divs)
  expect_identical(divsColNames, c("Time", "Fee", "GrossRate", "Id", "Symbol" ))
})

