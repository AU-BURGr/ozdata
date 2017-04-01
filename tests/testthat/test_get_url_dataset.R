context("get_url_dataset")

test_that("output", {
  skip_on_cran()
  url <- paste0("https://datagovau.s3.amazonaws.com/bioregionalassessm",
                "ents/LEB/PED/DATA/Resources/Other/110_Context_statement",
                "NTGAB_Selected_Wetlands/062801f2-dcf9-4a2d-b65b-52f20d4",
                "da721.zip")
  dataset <- get_url_dataset(url)
  expect_is(dataset, "list")
  expect_true(inherits(dataset[[1]], c("sf", "data.frame")))
})

test_that("invalid arguments", {
    expect_error(get_url_dataset("www.google.com/awefiowaef.zip"))
    expect_error(get_url_dataset("www.awejfianwefew.com/awefiowaef.zip"))
    expect_error(get_url_dataset("wajefiawef"))
    expect_error(get_url_dataset(NULL))
    expect_error(get_url_dataset(NULL, force = TRUE))
    expect_error(get_url_dataset(0))
    expect_error(get_url_dataset(NULL, force = TRUE))
})
