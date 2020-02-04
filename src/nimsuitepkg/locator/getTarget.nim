import strutils
import os
import osproc

proc getTarget*(targetDir, targetTestSuite: string): seq[tuple[path: string,
    filename: string]] =
  let home = os.getCurrentDir()
  let testsDir = "tests"
  os.setCurrentDir(testsDir)
  var targetStr = osproc.execProcess "find . -name t\\*.nim"
  result = @[]
  for target in targetStr.splitLines:
    if target == "":
      continue
    if targetTestSuite != "" and not target.continuesWith(targetTestSuite, 0):
      continue

    var (path, filename, _) = target.splitFile
    result.add (path: path, filename: filename)
  os.setCurrentDir(home)
