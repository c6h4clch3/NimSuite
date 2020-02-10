import strutils
import os

proc getTarget*(targetDir, targetTestSuite: string): seq[tuple[path: string,
    filename: string]] =
  let home = os.getCurrentDir()
  let testsDir = targetDir
  os.setCurrentDir(testsDir)
  result = @[]
  for item in os.walkDirRec("."):
    var (path, filename, ext) = os.splitFile(item)
    if (ext != ".nim"): continue
    if (not filename.startsWith("t")): continue
    result.add (path: path, filename: filename)
  os.setCurrentDir(home)
