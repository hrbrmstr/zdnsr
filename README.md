
# zdnsr

Perform Bulk ‘DNS’ Queries Using ‘zdns’

## Description

Provides wrapper/helper methods for executing ‘zdns’
(<https://github.com/zmap/zdns>) bulk queries along with utility methods
to retrieve and cache ‘Public DNS’ (<http://public-dns.info/>)
nameserver lists.

  - `zdns`: <https://github.com/zmap/zdns>
  - `Public DNS Lists`: <http://public-dns.info/>

## What’s Inside The Tin

The following functions are implemented:

  - `install_zdns`: Helper to try to get `zdns` installed
  - `refresh_publc_nameservers_list`: Refresh the list of valid public
    nameservers
  - `zdns_exec`: Raw interface to `zdns`
  - `zdns_help`: Raw interface to `zdns`
  - `zdns_query`: Bulk query using `zdns`

## Installation

``` r
devtools::install_github("hrbrmstr/zdnsr")
```

## Usage

``` r
library(zdnsr)

# current verison
packageVersion("zdnsr")
```

    ## [1] '0.1.0'
