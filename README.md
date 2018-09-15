
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

### Example (top prefix enumeration)

``` r
c(
  "www", "mail", "mx", "blog", "ns1", "ns2", "dev", "server", "email", 
  "cloud", "api", "support", "smtp", "app", "webmail", "test", "box", 
  "m", "admin", "forum", "news", "web", "mail2", "ns", "demo", "my", 
  "portal", "shop", "host", "cdn", "git", "vps", "mx1", "mail1", 
  "static", "help", "ns3", "beta", "chat", "secure", "staging", "vpn", 
  "apps", "server1", "ftp", "crm", "new", "wiki",  "home", "info"
) -> top_common_prefixes # via Rapid7 FDNS analysis

tf <- tempfile(fileext = ".json")

zdns_query(
  sprintf("%s.rstudio.com", top_common_prefixes),
  query_type = "A",
  num_nameservers = (length(top_common_prefixes) * 2),
  output_file = tf
)
```

    ## zmap error log will be stored in /var/folders/1w/2d82v7ts3gs98tc6v772h8s40000gp/T//RtmpQLNb6f/zmap-error6f90237c7564.json

``` r
res <- jsonlite::stream_in(file(tf))
```

    ## opening file input connection.

    ## 
     Found 50 records...
     Imported 50 records. Simplifying...

    ## closing file input connection.

``` r
unlink(tf)

found <- which(lengths(res$data$answers) > 0)

do.call(
  rbind.data.frame,
  lapply(found, function(idx) {
    res$data$answers[[idx]]$query_name <- res$name[idx]
    res$data$answers[[idx]]
  })
) -> xdf

xdf <- xdf[,c("query_name", "name", "class", "ttl", "type", "answer")]

knitr::kable(xdf)
```

| query\_name         | name                       | class |  ttl | type  | answer                      |
| :------------------ | :------------------------- | :---- | ---: | :---- | :-------------------------- |
| wiki.rstudio.com    | wiki.rstudio.com           | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| wiki.rstudio.com    | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| cloud.rstudio.com   | cloud.rstudio.com          | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| cloud.rstudio.com   | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| support.rstudio.com | support.rstudio.com        | IN    | 2978 | CNAME | rstudioide.ssl.zendesk.com. |
| support.rstudio.com | rstudioide.ssl.zendesk.com | IN    |  278 | CNAME | rstudioide.zendesk.com.     |
| support.rstudio.com | rstudioide.zendesk.com     | IN    |  563 | A     | 35.174.158.178              |
| support.rstudio.com | rstudioide.zendesk.com     | IN    |  563 | A     | 54.208.38.43                |
| support.rstudio.com | rstudioide.zendesk.com     | IN    |  563 | A     | 35.174.160.246              |
| test.rstudio.com    | test.rstudio.com           | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| test.rstudio.com    | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| vpn.rstudio.com     | vpn.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| vpn.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| ns.rstudio.com      | ns.rstudio.com             | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| ns.rstudio.com      | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| admin.rstudio.com   | admin.rstudio.com          | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| admin.rstudio.com   | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| mail2.rstudio.com   | mail2.rstudio.com          | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| mail2.rstudio.com   | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| static.rstudio.com  | static.rstudio.com         | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| static.rstudio.com  | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| mx1.rstudio.com     | mx1.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| mx1.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| ns3.rstudio.com     | ns3.rstudio.com            | IN    |   59 | CNAME | rstudio.wpengine.com.       |
| ns3.rstudio.com     | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| dev.rstudio.com     | dev.rstudio.com            | IN    |   59 | CNAME | rstudio.wpengine.com.       |
| dev.rstudio.com     | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| ns1.rstudio.com     | ns1.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| ns1.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| www.rstudio.com     | www.rstudio.com            | IN    | 3600 | CNAME | rstudio.wpengine.com.       |
| www.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| staging.rstudio.com | staging.rstudio.com        | IN    |  299 | CNAME | www.rstudio.com.            |
| staging.rstudio.com | www.rstudio.com            | IN    | 3599 | CNAME | rstudio.wpengine.com.       |
| staging.rstudio.com | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| news.rstudio.com    | news.rstudio.com           | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| news.rstudio.com    | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| ns2.rstudio.com     | ns2.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| ns2.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| email.rstudio.com   | email.rstudio.com          | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| email.rstudio.com   | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| server.rstudio.com  | server.rstudio.com         | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| server.rstudio.com  | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| shop.rstudio.com    | shop.rstudio.com           | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| shop.rstudio.com    | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| crm.rstudio.com     | crm.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| crm.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| host.rstudio.com    | host.rstudio.com           | IN    |   59 | CNAME | rstudio.wpengine.com.       |
| host.rstudio.com    | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| info.rstudio.com    | info.rstudio.com           | IN    | 3600 | CNAME | mkto-ab020217.com.          |
| info.rstudio.com    | mkto-ab020217.com          | IN    |  300 | A     | 199.15.213.48               |
| web.rstudio.com     | web.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| web.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| portal.rstudio.com  | portal.rstudio.com         | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| portal.rstudio.com  | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| mx.rstudio.com      | mx.rstudio.com             | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| mx.rstudio.com      | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| mail1.rstudio.com   | mail1.rstudio.com          | IN    |   59 | CNAME | rstudio.wpengine.com.       |
| mail1.rstudio.com   | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| webmail.rstudio.com | webmail.rstudio.com        | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| webmail.rstudio.com | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| api.rstudio.com     | api.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| api.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| help.rstudio.com    | help.rstudio.com           | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| help.rstudio.com    | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| secure.rstudio.com  | secure.rstudio.com         | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| secure.rstudio.com  | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| new.rstudio.com     | new.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| new.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| my.rstudio.com      | my.rstudio.com             | IN    |   59 | CNAME | rstudio.wpengine.com.       |
| my.rstudio.com      | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| vps.rstudio.com     | vps.rstudio.com            | IN    |   59 | CNAME | rstudio.wpengine.com.       |
| vps.rstudio.com     | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| smtp.rstudio.com    | smtp.rstudio.com           | IN    |   59 | CNAME | rstudio.wpengine.com.       |
| smtp.rstudio.com    | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| demo.rstudio.com    | demo.rstudio.com           | IN    |   59 | CNAME | rstudio.wpengine.com.       |
| demo.rstudio.com    | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| git.rstudio.com     | git.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| git.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| cdn.rstudio.com     | cdn.rstudio.com            | IN    |   59 | CNAME | rstudio.wpengine.com.       |
| cdn.rstudio.com     | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| m.rstudio.com       | m.rstudio.com              | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| m.rstudio.com       | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| mail.rstudio.com    | mail.rstudio.com           | IN    | 3600 | CNAME | ghs.googlehosted.com.       |
| mail.rstudio.com    | ghs.googlehosted.com       | IN    |   69 | A     | 172.217.6.243               |
| forum.rstudio.com   | forum.rstudio.com          | IN    |   59 | CNAME | rstudio.wpengine.com.       |
| forum.rstudio.com   | rstudio.wpengine.com       | IN    |  119 | A     | 104.196.200.5               |
| box.rstudio.com     | box.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| box.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| home.rstudio.com    | home.rstudio.com           | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| home.rstudio.com    | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| chat.rstudio.com    | chat.rstudio.com           | IN    |   30 | CNAME | rstudio.wpengine.com.       |
| chat.rstudio.com    | rstudio.wpengine.com       | IN    |   30 | A     | 104.196.200.5               |
| beta.rstudio.com    | beta.rstudio.com           | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| beta.rstudio.com    | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| ftp.rstudio.com     | ftp.rstudio.com            | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| ftp.rstudio.com     | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
| blog.rstudio.com    | blog.rstudio.com           | IN    |  300 | CNAME | rstudio-blog.netlify.com.   |
| blog.rstudio.com    | rstudio-blog.netlify.com   | IN    |   20 | A     | 35.198.30.40                |
| server1.rstudio.com | server1.rstudio.com        | IN    |   60 | CNAME | rstudio.wpengine.com.       |
| server1.rstudio.com | rstudio.wpengine.com       | IN    |  120 | A     | 104.196.200.5               |
