# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import nimsuitepkg/runner/runner
import nimsuitepkg/locator/getTarget
import nimsuitepkg/executer/executeTests
import nimsuitepkg/options/optionsBag
import nimsuitepkg/test/printColored

when isMainModule:
  var r = newRunner()
  var optBag = optionsBag.makeOptionBag[ExecTestsOption]()

  r.addOption("verbose", proc (_: string) =
    optBag.add(ExecTestsOption.Verbose)
  )
  r.addOption("clean", proc (_: string) =
    optBag.add(ExecTestsOption.Clean)
  )
  r.addCommand("help", proc (_: seq[string]): int =
    const helpTxt = staticRead("./nimsuitepkg/assets/text/help.txt")
    echo helpTxt.substr(0, len(helpTxt) - 2)
    return 0
  )
  r.addCommand("[*]", proc (args: seq[string]): int =
    var targets = getTarget("tests", args[0])
    return int execTests("tests", targets, presentTestResult, optBag)
  )

  system.programResult = r.run()
