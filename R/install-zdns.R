#' Helper to try to get zdns installed
#' @export
install_zdns <- function() {

  res <- Sys.which("go")
  if (res == "") {
    packageStartupMessage(
      "Go (golang) not found. Please install Go (https://golang.org/dl/) for ",
      "your platform and try reloading the package again."
    )
  } else {
    message(
      "Attempting to install Go (golang). Please monitor the output for any ",
      "errors that might occur during installation.")
    res <- system2("go", c("get", "github.com/zmap/zdns/zdns"), stdout="")
  }

}