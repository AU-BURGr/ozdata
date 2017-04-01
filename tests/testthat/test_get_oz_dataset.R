context("get_oz_dataset")

test_that("output", {
  id <- "062801f2-dcf9-4a2d-b65b-52f20d4da721"
  d <- get_oz_dataset(id)
  expect_equal(names(d), id)
  expect_is(d, "list")
  expect_equal(names(d[[1]]), get_url(id)[1])
  expect_is(d[[1]], "list")
  expect_is(d[[1]][[1]][[1]], "sf")
  expect_is(d[[1]][[1]][[2]], "data.frame")
})

test_that("invalid arguments", {
  expect_error(get_oz_dataset("asdf"))
  expect_error(get_oz_dataset(NULL))
  expect_error(get_oz_dataset(character(0)))
})
