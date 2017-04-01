context("get_ausmacrodata")

test_that("output", {
  skip_on_cran()
  x <- get_ausmacrodata("crtdoirymmdir")
  expect_is(x, "xts")
})

test_that("invalid arguments", {
  expect_error(get_ausmacrodata(
    "http://ausmacrodata.org/series.php?id=gdpcknaasaq33782371"),
    "HTTP error 404.")
  expect_error(get_ausmacrodata("string"), "HTTP error 404.")
  expect_error(get_ausmacrodata(NULL))
  expect_error(get_ausmacrodata(12))
})
