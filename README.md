# ozdata

[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Travis Build Status](https://img.shields.io/travis/AU-BURGr/ozdata/master.svg?label=Mac%20OSX%20%26%20Linux)](https://travis-ci.org/AU-BURGr/ozdata)
[![AppVeyor Build Status](https://img.shields.io/appveyor/ci/AU-BURGr/ozdata/master.svg?label=Windows)](https://ci.appveyor.com/project/AU-BURGr/ozdata)
[![Coverage Status](https://codecov.io/github/AU-BURGr/ozdata/coverage.svg?branch=master)](https://codecov.io/github/AU-BURGr/ozdata?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/ozdata)](https://CRAN.R-project.org/package=ozdata)

## Overview

There are many high quality data sets that are freely available for Australia. Unfortunately they can be difficult to obtain and analyse.  Here we provide tools to programmatically import and explore Australian data sets. Data can be obtained from the official Australian government portal, which contains over 40,000 data sets (https://data.gov.au). Additionally, economic data sets can be obtained from the Australian Macro Database (http://ozmacrodata.org). This project was created during the 2017 BURGr R UnConference https://github.com/AU-BURGr/UnConf2017.

## Installation
This package uses the [_sf_ package](https://github.com/edzer/sfr) and the [units package](https://github.com/edzer/units). Please see the packages' websites for instructions on installing them.

To install the developmental version of _ozdata_, use the following R code:

```r
if (!require(devtools))
  install.packages(devtools)
devtools::install_github("AU-burgr/ozdata")
```

## Example usage


## Contributors
- [Jonathan Carroll](https://github.com/jonocarroll)
- [Maria Dmitrijeva](https://github.com/marianess)
- [Jeffrey O. Hanson](https://github.com/jeffreyhanson)
- [Rob J. Hyndman](https://github.com/robjhyndman)
- [Simon Lyons](https://github.com/SimonLyons)
- [Cameron Roach](https://github.com/camroach87)
- [Adam H. Sparks](https://github.com/adamhsparks)
- [Matt Sutton](https://github.com/matt-sutton)

## Meta

*  Please [report any issues or bugs](https://github.com/AU-BURGr/ozdata/issues).  
    
* License: GPL(>=3) + file LICENSE
    
* Get citation information for _ozdata_ in R typing `citation(package = "ozdata")`  

* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

