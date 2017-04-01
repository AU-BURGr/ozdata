context("get_url")

test_that("object", {
  skip_on_cran()
  expect_is(get_url(id = "062801f2-dcf9-4a2d-b65b-52f20d4da721"),
                    "character")
  expect_equal(get_url(id = "062801f2-dcf9-4a2d-b65b-52f20d4da721"),
               paste0("https://datagovau.s3.amazonaws.com/",
                      "bioregionalassessments/LEB/PED/DATA/Resources/Other/",
                      "110_Context_statementNTGAB_Selected_Wetlands/",
                      "062801f2-dcf9-4a2d-b65b-52f20d4da721.zip"))
})

test_that("invalid arguments", {
    expect_error(get_url("awefuiaweunfaweofasdfjk"))
    expect_error(get_url("www.ozdata.com"))
})
