import strutils
import os
import osproc
import distros

import ../presenter/presenter
import ../options/optionsBag

type ExecTestReturnCode = enum
  Ok = 0
  Error = 1

type ExecTestsOption* = enum
  Verbose
  Clean
  Output

proc getCompileCmd(filename: string, isSilent: bool): string =
  var blackhole: string
  if detectOs(Posix):
    blackhole = " > /dev/null"
  elif detectOs(Windows):
    blackhole = " > NUL"
  else:
    blackhole = ""

  if isSilent:
    return "nim c --hints:off " & filename & blackhole
  else:
    return "nim c " & filename

proc execTests*(home: string, targets: seq[tuple[path: string,
    filename: string]], present: Presenter,
        options: OptionBag[ExecTestsOption]): ExecTestReturnCode =
  let absHome = os.absolutePath(home)
  os.setCurrentDir(absHome)
  var cases = 0
  var succs = 0
  var fails = 0
  if targets.len == 0:
    echo "no tests found."
    return Error
  else:
    for (path, filename) in targets.items:
      echo "Compiling " & path & "/" & filename & "..."

      os.setCurrentDir(path)

      try:
        discard osproc.execCmd(getCompileCmd(filename, not options.contains(Verbose)))
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
      if options.contains(Clean):
        os.removeFile filename
      echo ""
      os.setCurrentDir absHome
    echo $cases & " Test cases, " & $succs & " cases OK, " & $fails & " cases Failed."
    return if fails > 0: Error
      else: Ok
