.onLoad <- function(libname, pkgname) {

  if (!dir.exists(path.expand("~/.zdnsr"))) {
    message("Bootstrapping public nameservers list...")
    refresh_publc_nameservers_list()
  }

  res <- Sys.which("go")
  if (res == "") {
    packageStartupMessage(
      "Go (golang) not found. Please install Go (https://golang.org/dl/) for ",
      "your platform and try reloading the package again."
    )
  } else {

    res <- Sys.which("zdns")
    if (res == "") {
      packageStartupMessage(
        "zdns not found. Please go to https://github.com/zmap/zdns to find ",
        "installation instructions or try running install_zdns()."
      )
    }

  }

}
