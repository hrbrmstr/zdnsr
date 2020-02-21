#' Raw interface to zdns
#'
#' Pass in command-line arguments via `args`. Not a recommended function
#' unless you _really_ know what you're doing. Run `zdns_help()`
#' to see a list of options.
#'
#' @md
#' @export
zdns_exec <- function(args=c(), stdout="", stdin="") {

  if (!dir.exists(path.expand("~/.zdnsr"))) {
    message("Bootstrapping public nameservers list...")
    refresh_publc_nameservers_list()
  }

  zdns_bin <- Sys.which("zdns")

  if (zdns_bin == "") {
    message("zdns binary not on PATH. Trying to find it at ~/go/bin...")
    zdns_bin <- path.expand("~/go/bin/zdns")
    if (!file.exists(zdns_bin)) {
      stop("zdns binary not found.", call.=FALSE)
    }
  }

  res <- system2(zdns_bin, args=args, stdout=stdout, stdin=stdin)

  invisible(res)

}

#' @rdname zdns_exec
#' @export
zdns_help <- function(x) {
  zdns_exec("--help")
}
