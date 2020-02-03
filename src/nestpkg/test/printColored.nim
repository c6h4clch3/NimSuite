import strutils
import terminal

import ../presenter/presenter

var presentTestResult*: Presenter = proc (output: string) =
  for l in output.splitLines:
    if l.startsWith("[OK]"):
      var okStr = l.substr(0, 3)
      var others = l.substr(4)
      setForegroundColor(stdout, fgGreen)
      write(stdout, okStr)
      resetAttributes(stdout)
      echo others
    elif l.startsWith("[FAILED]"):
      var errStr = l.substr(0, 7)
      var others = l.substr(8)
      setForegroundColor(stdout, fgRed)
      write(stdout, errStr)
      resetAttributes(stdout)
      echo others
    else:
      echo l


