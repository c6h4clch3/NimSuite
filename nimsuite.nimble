# Package

version       = "0.1.0"
author        = "c6h4clch3"
description   = "a simple test framework for nim."
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["nimsuite"]



# Dependencies

requires "nim >= 1.0.4"

task start, "an alias for `nimble run nest`.":
  exec("nimble run nimsuite")
