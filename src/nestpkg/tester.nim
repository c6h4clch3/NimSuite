import strutils
import os

proc getTarget*(targetTest: string): seq[tuple[path: string,
    filename: string]] =
  var (targetStr, exc) = gorgeEx "find tests -name t\\*.nim"
  if exc != 0:
    raise newException(Exception, "an error caused in target finding.")
  result = @[]
  for target in targetStr.splitLines:
    if target == "":
      continue
    if targetTest != "" and not target.continuesWith(targetTest, 0):
      continue

    var (path, filename, _) = target.splitFile
    result.add (path: path, filename: filename)
