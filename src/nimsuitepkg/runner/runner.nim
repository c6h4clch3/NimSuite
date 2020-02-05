import os
import sugar
import strutils

type Command = object
  name: string
  task: (seq[string]) -> int
type Option = object
  name: string
  short: string
  task: (string) -> void
type Runner = object
  commands: seq[Command]
  options: seq[Option]

proc newRunner*(): Runner =
  return Runner(commands: @[], options: @[])

proc addCommand*(runner: var Runner, name: string, task: (seq[string]) -> int) =
  runner.commands.add Command(
    name: name,
    task: task
  )

proc addOption*(runner: var Runner, name: string, task: (string) -> void,
    short: string = "") =
  runner.options.add Option(
    name: name,
    short: short,
    task: task
  )

proc runOption(runner: Runner, option: string) =
  var commands = option.split(":")
  if (commands.len == 1):
    commands.add ""
  var (optionName, args) = (commands[0], commands[1])
  var optionType = "long"
  if (optionName.startsWith "--"):
    optionName = optionName.substr 2
  else:
    optionName = optionName.substr 1
    optionType = "short"
  for o in runner.options.items:
    var hits = case optionType
      of "long": (o.name == optionName)
      of "short": (o.short == optionName)
      else: false
    if hits:
      o.task(args)
      return

proc runCommand(runner: Runner, name: string, args: seq[string]): int =
  for c in runner.commands.items:
    var hits = c.name == name
    if hits:
      return c.task(args)
  for c in runner.commands.items:
    if c.name == "[*]":
      var vars = @[name]
      vars.add args
      return c.task(vars)

proc run*(runner: Runner): int =
  var args = commandLineParams()
  if (args.len == 0):
    args.add ""
  while true:
    if (args.len == 0):
      return runner.runCommand("", @[])
    var nextArg = args[0]
    args.delete(0)
    if (nextArg.startsWith "-"):
      runner.runOption(nextArg)
    else:
      return runner.runCommand(nextArg, args)
