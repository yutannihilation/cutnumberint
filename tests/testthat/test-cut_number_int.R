test_that("cut_number_int() works", {
  # simple case

  expect_equal(
    cut_number_int(1:9, 3),
    factor(c("1~3", "1~3", "1~3", "4~6", "4~6", "4~6", "7~", "7~", "7~"))
  )

  expect_equal(
    cut_number_int(1:9, 3, show_highest_value = TRUE),
    factor(c("1~3", "1~3", "1~3", "4~6", "4~6", "4~6", "7~9", "7~9", "7~9"))
  )

  # 0-inflated data

  expect_message(
    expect_equal(
      cut_number_int(c(rep(0, 100), 1:9), 4),
      factor(c(rep("0", 100), "1~3", "1~3", "1~3", "4~6", "4~6", "4~6", "7~", "7~", "7~"))
    ),
    "Retrying calculation..."
  )

  expect_message(
    expect_equal(
      cut_number_int(c(rep(-1, 100), rep(0, 100), 1:9), 5),
      factor(c(rep("-1", 100), rep("0", 100), "1~3", "1~3", "1~3", "4~6", "4~6", "4~6", "7~", "7~", "7~"))
    ),
    "Retrying calculation..."
  )

  # out of scope
  expect_error(cut_number_int(c(0, rep(1, 100), 2:9), 5))

  # too many retries
  expect_error(cut_number_int(c(rep(0, 100), 1:9), 4, retry = 0))
})
