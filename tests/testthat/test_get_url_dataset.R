context("get_url_dataset")

url <- paste0("https://datagovau.s3.amazonaws.com/bioregionalassessm",
              "ents/LEB/PED/DATA/Resources/Other/110_Context_statement",
              "NTGAB_Selected_Wetlands/062801f2-dcf9-4a2d-b65b-52f20d4",
              "da721.zip")
dataset <- get_url_dataset(url)

test_that("Check class", {
    expect_is(dataset, "list")
    expect_equal(class(dataset[[1]]), c("sf", "data.frame"))
})

test_that("Bad url tests", {
    expect_error(get_url_dataset("www.google.com/awefiowaef.zip"))
    expect_error(get_url_dataset("www.awejfianwefew.com/awefiowaef.zip"))
    expect_error(get_url_dataset("wajefiawef"))
    expect_error(get_url_dataset(NULL))
    expect_error(get_url_dataset(NULL, force = TRUE))
    expect_error(get_url_dataset(0))
    expect_error(get_url_dataset(NULL, force = TRUE))
})


# try finding a random text file online and see what happens
# test if force doesn't work if file over 100Mb
