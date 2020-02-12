import strutils
import terminal

import ../presenter/presenter

var presentTestResult*: Presenter = proc (output: string) =
  for l in output.splitLines:
    let fullLen = l.len
    let trimed = l.unindent
    let spaceLen = fullLen - trimed.len
    write(stdout, spaces(spaceLen))
    if trimed.startsWith("[OK]"):
      var okStr = trimed.substr(0, 3)
      var others = trimed.substr(4)
      setForegroundColor(stdout, fgGreen)
      write(stdout, okStr)
      resetAttributes(stdout)
      echo others
    elif trimed.startsWith("[FAILED]"):
      var errStr = trimed.substr(0, 7)
      var others = trimed.substr(8)
      setForegroundColor(stdout, fgRed)
      write(stdout, errStr)
      resetAttributes(stdout)
      echo others
    elif trimed.startsWith("[Suite]"):
      var suiteStr = trimed.substr(0, 6)
      var others = trimed.substr(7)
      setForegroundColor(stdout, fgBlue)
      write(stdout, suiteStr)
      resetAttributes(stdout)
      echo others
    else:
      echo trimed


