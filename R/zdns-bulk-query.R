#' Bulk query using zdns
#'
#' Given an entity list and an output file, `zdns` will be executed and
#' JSON output stored in `output_file` and an optional `log` file
#' (if specified).
#'
#' @md
#' @param entities a character vector of entities to resolve
#' @param input_file if not `NULL`, overrides `entities` and this file
#'        will be used as the entities source. It *must* be a plain text
#'        file with one entity to resovle per-line. `path.expand()` will
#'        be run on this value.
#' @param query_type anything `zdns` supports. Presently, one of `A`, `AAAA`,
#'        `ANY`, `AXFR`, `CAA`, `CNAME`, `DMARC`, `MX`, `NS`, `PTR`, `TXT`,
#'        `SOA`, or `SPF` (can be lower-case). Default is `A`.
#' @param output_file path + file to the JSON output. `path.expand()` will be run
#'        on this value.
#' @param num_nameservers total number of nameservers to use. They will be randomly
#'        selected from the cached list of valid, public nameservers. It is _highly_
#'        recommended that you refresh this list periodicaly (perhaps daily).
#' @param num_retries how many times should `zdns` retry query if timeout or
#'        temporary failure? Defaults to `3`.
#' @param num_threads number of lightweight go threads. Note that the default `500` is
#'        smaller than the built-in default of `1000`.
#' @param log if `TRUE` the JSON error log file will be automatically generated and
#'        the location printed to the console. If a length 1 character vector, this
#'        path + file will be used to save the JSON error log. If `FALSE` no error
#'        log will be captured.
#' @param verbose a value between `1` and `5` indicating the verbosity level. Defaults
#'        to `3`. Set this to `1` if you're working inside RStudio or other
#'        environments that can't handle a great deal of console text since
#'        the messages are placed on `stdout` when `log` equals `FALSE`.
#' @return value from the `system2()` call to `zdns` (invisibly)
#' @note if you specified `TRUE` for `log` then _you_ are responsible for
#'       removing the auto-generated log file.
#' @export
#' @examples \dontrun{
#' # enumerate top prefixes for a domain
#'
#' c(
#'   "www", "mail", "mx", "blog", "ns1", "ns2", "dev", "server", "email",
#'   "cloud", "api", "support", "smtp", "app", "webmail", "test", "box",
#'   "m", "admin", "forum", "news", "web", "mail2", "ns", "demo", "my",
#'   "portal", "shop", "host", "cdn", "git", "vps", "mx1", "mail1",
#'   "static", "help", "ns3", "beta", "chat", "secure", "staging", "vpn",
#'   "apps", "server1", "ftp", "crm", "new", "wiki",  "home", "info"
#' ) -> top_common_prefixes
#'
#' tf <- tempfile(fileext = ".json")
#'
#' zdns_query(
#'   sprintf("%s.rstudio.com", top_common_prefixes),
#'   query_type = "A",
#'   num_nameservers = (length(top_common_prefixes) * 2),
#'   output_file = tf
#' )
#'
#' res <- jsonlite::stream_in(file(tf))
#'
#' found <- which(lengths(res$data$answers) > 0)
#'
#' do.call(
#'   rbind.data.frame,
#'   lapply(found, function(idx) {
#'     res$data$answers[[idx]]$query_name <- res$name[idx]
#'     res$data$answers[[idx]]
#'   })
#' ) -> xdf
#'
#' xdf <- xdf[,c("query_name", "name", "class", "ttl", "type", "answer")]
#'
#' knitr::kable(xdf)
#' }
zdns_query <- function(entities, input_file = NULL, query_type = "A", output_file,
                       num_nameservers = 3000L, num_retries = 3, num_threads = 500,
                       log = TRUE, verbose = 3) {

  # make sure the output file dir exists
  output_file <- path.expand(output_file)
  stopifnot(dir.exists(dirname(output_file)))

  # setup entities to lookup
  if (!is.null(input_file)) {
    input_file <- path.expand(input_file)
    if (!file.exists(input_file)) stop("input file not found", call.=FALSE)
  } else {
    tf <- tempfile(fileext=".txt")
    on.exit(unlink(tf), add=TRUE)
    writeLines(entities, tf)
    input_file <- tf
  }

  # make sure query type is legit
  match.arg(
    toupper(query_type),
    c(
      "A", "AAAA", "ANY", "AXFR", "CAA", "CNAME", "DMARC",
      "MX", "NS", "PTR", "TXT", "SOA", "SPF"
    )
  ) -> query_type

  # prep nameservers list
  ns_df <- readRDS(file.path(path.expand("~/.zdnsr"), "public-nameservers.rds"))
  ns_df <- ns_df[ns_df$reliability>0.75,]
  ns_file <- tempfile(pattern = "resolvers", fileext = ".txt")
  writeLines(sprintf("nameserver %s", ns_df[sample(nrow(ns_df), num_nameservers),]$ip), ns_file)
  on.exit(unlink(ns_file), add=TRUE)

  # setup logging (if any)
  logging <- FALSE
  if (inherits(log, "character")) {
    log_file <- log
    logging <- TRUE
  } else {
    if (inherits(log, "logical")) {
      if (log) {
        log_file <- tempfile("zmap-error", fileext=".json")
        logging <- TRUE
        message("zmap error log will be stored in ", log_file)
      } else {
        message("Not logging errors.")
      }
    } else {
      message("Not logging errors.")
    }
  }

  # prep args for call to zdns
  zdns_args <- c(
    query_type,
    "-input-file", input_file,
    "-conf-file", ns_file,
    "-output-file", output_file,
    "-retries", num_retries,
    "-threads", num_threads,
    "-verbosity", verbose
  )

  if (logging) zdns_args <- c(zdns_args, "-log-file", log_file)

  invisible(zdns_exec(zdns_args))

}
