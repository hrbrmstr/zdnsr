.onLoad <- function(libname, pkgname) {

  res <- Sys.which("go")

  if (res == "") {
    packageStartupMessage(
      "Go (golang) binary not found. Please install Go (https://golang.org/dl/) for ",
      "your platform (and ensure $GOPATH/bin is on the system PATH) and try reloading the package again."
    )
  } else {

    res <- Sys.which("zdns")
    if (res == "") {
      packageStartupMessage(
        "zdns binary not found. Please go to https://github.com/zmap/zdns to find ",
        "installation instructions or try running install_zdns() and/or ensure that .",
        "$GOPATH/bin is on the system PATH reachable by R."
      )
    }

  }

}
