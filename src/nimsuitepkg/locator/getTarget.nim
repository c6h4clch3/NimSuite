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
    if (not (targetTestSuite == "")):
      let absTarget = absolutePath targetTestSuite
      let absPath = absolutePath(path & "/" & filename)
      if absPath == absTarget:
        result.add (path: path, filename: filename)
    else:
      result.add (path: path, filename: filename)
  os.setCurrentDir(home)
