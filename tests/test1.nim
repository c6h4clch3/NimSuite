# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import nimsuitepkg/submodule
test "correct welcome":
  check getWelcomeMessage() == "Hello, World!"

test "failed welcome":
  check not(getWelcomeMessage() == "Hello, World!")
# tests/test.nim
import unittest

import sugar

proc map*[T, U](container: seq[T], functor: (T, int) -> U): seq[U] =
  result = @[]
  for (index, item) in container.pairs():
    result.add functor(item, index)

var nums = @[1, 2, 3]
  # 無名関数も使えるよ
  # echo nums.map((item, _) => $item) # => @["1", "2", "3"]

  # テストはマクロ定義
test "First Simplest Test":
  # check(bool) で判定する。
  check($(nums.map((item, _) => $item)) == "@[\"1\", \"2\", \"3\"]")
