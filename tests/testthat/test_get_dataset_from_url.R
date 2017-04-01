context("get_dataset_from_url")

test_that("simple dataset", {
  skip_on_cran()
  url <- paste0("https://datagovau.s3.amazonaws.com/bioregionalassessm",
                "ents/LEB/PED/DATA/Resources/Other/110_Context_statement",
                "NTGAB_Selected_Wetlands/062801f2-dcf9-4a2d-b65b-52f20d4",
                "da721.zip")
  dataset <- get_dataset_from_url(url)
  expect_is(dataset, "list")
  expect_true(inherits(dataset[[1]], c("sf", "data.frame")))
  expect_equal(names(dataset), c("NTGAB_Selected_Wetlands.shp",
                                 "NTGAB_Selected_Wetlands.xml"))
})

test_that("complex dataset", {
  skip_on_cran()
  url <- paste0("http://eatlas.org.au/files/au-ga-ausbath-09-v4-contour/",
                "ausbath_09_v4_contour_simp300m.gs.shp.zip")
  dataset <- get_dataset_from_url(url)
  expect_is(dataset, "list")
  expect_true(all(sapply(dataset, inherits, "sf")))
  expect_equal(names(dataset), c("ausbath_09_v4_contour_100m_simp300m.shp",
                                 "ausbath_09_v4_contour_200m_simp300m.shp",
                                 "ausbath_09_v4_contour_20m_simp300m.shp",
                                 "ausbath_09_v4_contour_400m_simp300m.shp",
                                 "ausbath_09_v4_contour_40m_simp300m.shp"))
})

test_that("invalid arguments", {
    expect_error(get_dataset_from_url("www.google.com/awefiowaef.zip"))
    expect_error(get_dataset_from_url("www.awejfianwefew.com/awefiowaef.zip"))
    expect_error(get_dataset_from_url("wajefiawef"))
    expect_error(get_dataset_from_url(NULL))
    expect_error(get_dataset_from_url(NULL, force = TRUE))
    expect_error(get_dataset_from_url(0))
    expect_error(get_dataset_from_url(NULL, force = TRUE))
})
