context("get_ausmacrodata")

z <- get_ausmacrodata('crtdoirymmdir')
class(z)[1]

test_that("test class ", {
    expect_match(class(z)[1], "xts")

})

test_that("test url ", {
    expect_error(get_ausmacrodata("http://ausmacrodata.org/series.php?id=gdpcknaasaq33782371"),
                 "HTTP error 404.")
    expect_error(get_ausmacrodata("string!"),
                 "HTTP error 404.")
})

#get_ausmacrodata("http://yahoo.com/series.php?id=gdpcknaasaq")

