#' Refresh the list of valid public nameservers
#'
#' @export
refresh_publc_nameservers_list <- function() {
  if (!dir.exists(path.expand("~/.zdnsr"))) dir.create(path.expand("~/.zdnsr"))
  xdf <- read.csv("https://public-dns.info/nameservers.csv", stringsAsFactors=FALSE)
  saveRDS(xdf, file.path(path.expand("~/.zdnsr"), "public-nameservers.rds"))
}
