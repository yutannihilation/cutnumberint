
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cutnumberint

<!-- badges: start -->

[![R-CMD-check](https://github.com/yutannihilation/cutnumberint/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yutannihilation/cutnumberint/actions/workflows/R-CMD-check.yaml)
[![cutnumberint status
badge](https://yutannihilation.r-universe.dev/badges/cutnumberint)](https://yutannihilation.r-universe.dev/cutnumberint)
<!-- badges: end -->

A simple R package to provide only one function `cut_number_int()`, a
nicer version of `ggplot2::cut_number()`.

## Installation

``` r
install.packages("cutnumberint", repos = c("https://yutannihilation.r-universe.dev", "https://cloud.r-project.org"))
```

## Example

`ggplot2::cut_number()` is one of the hidden gems in ggplot2. It’s
really neat, but I have two complaints about it. First, it cannot handle
0-inflated data.

``` r
library(ggplot2)

set.seed(403)
x <- c(rep(0, 100), rpois(100, 2))

cut_number(x, n = 3)
#> Error in `cut_number()`:
#> ! Insufficient data values to produce 3 bins.
```

Second one is a general complaint about `cut()`. For integer(-ish) data,
I want intuitive labels like `6~10` instead of `(5.5,10]`.

``` r
cut_number(1:10, 2)
#>  [1] [1,5.5]  [1,5.5]  [1,5.5]  [1,5.5]  [1,5.5]  (5.5,10] (5.5,10] (5.5,10]
#>  [9] (5.5,10] (5.5,10]
#> Levels: [1,5.5] (5.5,10]
```

`cut_number_int()` can handle these nicely.

``` r
library(cutnumberint)

cut_number_int(x, n = 3)
#> Retrying calculation...
#>   [1] 0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0  
#>  [19] 0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0  
#>  [37] 0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0  
#>  [55] 0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0  
#>  [73] 0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0  
#>  [91] 0   0   0   0   0   0   0   0   0   0   1~2 1~2 1~2 3~  1~2 1~2 3~  1~2
#> [109] 0   1~2 3~  1~2 1~2 1~2 1~2 1~2 3~  1~2 1~2 1~2 1~2 1~2 3~  1~2 1~2 0  
#> [127] 1~2 1~2 1~2 1~2 0   1~2 3~  1~2 1~2 3~  3~  1~2 1~2 1~2 1~2 0   1~2 3~ 
#> [145] 0   1~2 1~2 1~2 1~2 1~2 1~2 0   3~  3~  1~2 1~2 3~  3~  1~2 0   1~2 3~ 
#> [163] 3~  0   0   1~2 1~2 3~  0   3~  3~  1~2 1~2 1~2 3~  1~2 3~  1~2 1~2 3~ 
#> [181] 3~  1~2 1~2 3~  1~2 1~2 3~  3~  1~2 1~2 1~2 3~  0   1~2 3~  1~2 3~  3~ 
#> [199] 1~2 3~ 
#> Levels: 0 1~2 3~
```

``` r
d <- data.frame(x = cut_number_int(x, n = 3))
#> Retrying calculation...
ggplot(d) +
  geom_bar(aes(x))
```

<img src="man/figures/README-no_error_plot-1.png" width="100%" />

``` r
table(cut_number_int(1:1000, 3))
#> 
#>   1~334 335~667    668~ 
#>     334     333     333
```

### Caveats

For simplicity, this package handles only the cases where the inflated
values are located on the lowest bound. If it appears on the middle of
the data range, `cut_number_int()`.

``` r
cut_number_int(c(0, rep(1, 100), 2:9), 5)
#> Error in `cut_number_int()`:
#> ! For simplicity, this function only takes care the cases when the inflated values are on the lowest bounds
```

If you need more powerful functions, probably you can find nicer binning
packages on CRAN.

- <https://www.r-pkg.org/search.html?q=binning>
