import strutils
import os
import osproc

import ../presenter/presenter

type ExecTestReturnCode = enum
  Ok = 0
  Error = 1

type ExecTestsOption* = enum
  Verbose
  Clean
  Output

type ExecTestOptionValue = tuple
  option: ExecTestsOption
  value: string

type ExecTestsOptionsBag = seq[ExecTestOptionValue]

proc makeOptionsBag*(): ExecTestsOptionsBag =
  return @[]

proc add*(b: var ExecTestsOptionsBag, o: ExecTestsOption, v: string = "") =
  b.add (o, v)

proc contains(b: ExecTestsOptionsBag, o: ExecTestsOption): bool =
  for ov in b.items:
    if ov.option == o:
      return true
  return false

proc find(b: ExecTestsOptionsBag, o: ExecTestsOption): ExecTestOptionValue =
  for ov in b.items:
    if ov.option == o:
      return ov
  return

proc getCompileCmd(filename: string, isSilent: bool): string =
  if isSilent:
    return "nim c --hints:off " & filename & " > /dev/null"
  else:
    return "nim c " & filename

proc execTests*(home: string, targets: seq[tuple[path: string,
    filename: string]], present: Presenter,
        options: ExecTestsOptionsBag): ExecTestReturnCode =
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
