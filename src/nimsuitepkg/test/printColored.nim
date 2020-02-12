import strutils
import terminal

import ../presenter/presenter

type PaintRule = object
  keyword: string
  color: ForegroundColor
  bgColor: BackgroundColor
  styles: set[Style]

proc paint(p: PaintRule, line: string) =
  var target = line.substr(0, p.keyword.len - 1)
  var others = line.substr(p.keyword.len)
  if not(cast[int](p.color) == 0):
    setForegroundColor(stdout, p.color)
  if not(cast[int](p.bgColor) == 0):
    setBackgroundColor(stdout, p.bgColor)
  setStyle(stdout, p.styles)
  write(stdout, target)
  resetAttributes(stdout)
  echo others

type Painter = object
  rules: seq[PaintRule]

proc addRule(p: var Painter, r: PaintRule) =
  p.rules.add r

proc run(p: Painter, str: string) =
  for l in str.splitLines:
    let fullLen = l.len
    let trimed = l.unindent
    let spaceLen = fullLen - trimed.len
    write(stdout, spaces(spaceLen))

    var hit = false
    for r in p.rules:
      if trimed.startsWith(r.keyword):
        hit = true
        r.paint(trimed)
    if not hit:
      echo trimed

var presentTestResult*: Presenter = proc (output: string) =
  var painter = Painter(rules: @[])
  painter.addRule(PaintRule(
    keyword: "[OK]",
    color: fgGreen,
    styles: {styleBright}
  ))
  painter.addRule(PaintRule(
    keyword: "[FAILED]",
    color: fgRed,
    styles: {styleBright}
  ))
  painter.addRule(PaintRule(
    keyword: "[Suite]",
    color: fgBlue,
    styles: {styleBright}
  ))

  painter.run(output)
