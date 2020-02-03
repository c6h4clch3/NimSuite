import strutils
import os
import osproc

proc getTarget*(targetTest: string): seq[tuple[path: string,
    filename: string]] =
  var targetStr = osproc.execProcess "find tests -name t\\*.nim"
  result = @[]
  for target in targetStr.splitLines:
    if target == "":
      continue
    if targetTest != "" and not target.continuesWith(targetTest, 0):
      continue

    var (path, filename, _) = target.splitFile
    result.add (path: path, filename: filename)
