# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import nestpkg/runner/runner
import nestpkg/locator/getTarget
import nestpkg/executer/executeTests
import nestpkg/test/printColored

when isMainModule:
  var r = newRunner()
  var optBag = makeOptionsBag()

  r.addOption("verbose", proc (_: string) =
    optBag.add(ExecTestsOption.Verbose)
  )
  r.addOption("clean", proc (_: string) =
    optBag.add(ExecTestsOption.Clean)
  )
  r.addCommand("help", proc (_: seq[string]) {.closure.} =
    const helpTxt = staticRead("./nestpkg/assets/text/help.txt")
    echo helpTxt.substr(0, len(helpTxt) - 2)
  )
  r.addCommand("[*]", proc (args: seq[string]) {.closure.} =
    var targets = getTarget("tests", args[0])
    execTests("tests", targets, presentTestResult, optBag)
  )

  r.run()
