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
      res <- path.expand("~/go/bin/zdns")
      if (!file.exists(zdns_bin)) {
        packageStartupMessage(
          "zdns binary was not found automatically but was found in your local go 'bin'",
          "diredctory. {zdnsr} will compensate for this but you should correct the PATH",
          "configuration to avoid problems."
        )
      } else {
        packageStartupMessage(
          "zdns binary not found. Please go to https://github.com/zmap/zdns to find ",
          "installation instructions or try running install_zdns() and/or ensure that .",
          "$GOPATH/bin is on the system PATH reachable by R."
        )
      }
    }

  }

}
