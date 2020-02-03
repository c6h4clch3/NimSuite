import strutils
import os
import osproc

import ../presenter/presenter

type ExecTestsOptions* = enum
  Verbose

proc execTests*(targets: seq[tuple[path: string, filename: string]],
    present: Presenter, options: set[ExecTestsOptions] = {}) =
  var home = os.getCurrentDir()
  var cases = 0
  var succs = 0
  var fails = 0
  var compileCmd = if options.contains(Verbose):
    "nim c "
  else:
    "nim c --hints:off "
  if targets.len == 0:
    echo "no tests found."
  else:
    for (path, filename) in targets.items:
      echo "Compiling " & path & "/" & filename & "..."

      os.setCurrentDir(path)

      try:
        discard osproc.execCmd(compileCmd & filename)
      except OSError:
        echo "test for " & filename & ".nim failed"

      echo "Compile Finished.\n"
      echo "test for " & filename & ".nim:"

      try:
        var output = osproc.execProcess("./" & filename)
        var okCount = count(output, "OK")
        var failCount = count(output, "FAILED")
        cases += okCount + failCount
        succs += okCount
        fails += failCount

        present(output)
      except OSError:
        echo "test for " & filename & ".nim failed"
      os.removeFile filename
      echo ""
      os.setCurrentDir home
    echo $cases & " Test cases, " & $succs & " cases OK, " & $fails & " cases Failed."
