# NimSuite

NimSuite is a simple unit test framework, based on Nim's basic unit tests.

As `nimble test`, nimsuite runs the test of `.nim` file which is under `/tests` directory and filename begins `t`.
However, compiler messages are supressed by default and it displays the number of the test cases, the number of the passed cases and the number of the failed cases.

## Usage

```sh
$ nimble install nimsuite
$ nimsuite
```

Nimsuite looks the current directory for `tests` directory, then compile and execute tests.

## Options

### verbose

```sh
$ nimsuite --verbose
```

displays all of compiler message.

### clean

```sh
$ nimsuite --clean
```

removes test binary after execute it.
