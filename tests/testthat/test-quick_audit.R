library("testthat")
library("senamhiR")
indat <- senamhiR("000401", 1998:2000)

context("Test `quick_audit()`")

## test quick audit by year and return percent missing values
test_that("quick_audit() can audit by year", {
  df <- quick_audit(indat, variables = c("Tmax", "Tmin"), by = "year")
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "3 obs")
  expect_output(str(df), "3 variables")
  expect_equal(df$`Tmax (C) pct NA`[1], 83.28767)
})

## test quick audit by month and return number of missing values
test_that("quick_audit() can audit by month", {
  df <- quick_audit(indat, variables = c("Tmax", "Tmin"), by = "month", report = "n")
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "36 obs")
  expect_output(str(df), "7 variables")
  expect_equal(df$`Tmax (C) tot NA`[3], 31)
})

## test quick_audit with missing variables and in reverse
test_that("quick_audit() can audit with missing variables", {
  df <- quick_audit(indat, by = "year", reverse = TRUE)
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "3 obs")
  expect_output(str(df), "13 variables")
  expect_lt(df$`Tmax (C) pct present`[1], 16.71233)
})

## test quick_audit warns if "year" or "month" not set correctly
test_that("quick_audit() will fail if `by` is neither \"month\" nor \"year\"", {
  expect_warning(quick_audit(indat, by = "mnoth"), "By was neither \"month\" nor \"year\". Defaulting to overall total.", fixed=TRUE)
})
