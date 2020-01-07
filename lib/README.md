# Overview

Collection of generic bash functions. Grouped as follows:

* **bash.shlib**: processing of common arguments such as -v or -d, and often-used functionality `fail()`/`error()`/`warn()`/`info()`/`debug()`.
* **java.shlib**: utilities related to building and running Java.
* **json.shlib**: JSON utilities

# How to Use SHLIB Libraries

````
[ -f $(dirname $0)/lib/bash.shlib ] && source $(dirname $0)/lib/bash.shlib || { echo "[error]: $(dirname $0)/lib/bash.shlib not found" 1>&2; exit 1; }
````

No library recursively includes other libraries. If functions from multiple libraries are required, they all need to be
loaded from the calling script.


# How to Locally Test Functions

```
cd shell-tools/lib
./test/local.sh
```

# How to Run Per-Function Tests

```
cd shell-tools/lib
bats ./test/bash/info.bats
```

# How to Run All Tests

```
cd shell-tools/lib
./test/all-tests.sh
```

`all-tests.sh` executes all component tests (bash.shlib, java.shlib, etc.). All tests must pass.


# TODO

* (.) shell-tools/lib/tests runner to replace all-tests from everywhere – capability to run directories, files and individual tests. Requirements:
** Same tool to run all tests in a directory, an individual file (collections of tests) and an individual test?
** Run in debug mode with --verbose , capability to specify the DEBUG_OUTPUT - need to be able to indentify what failed easier than today. 

* Convert old style of testing java-tests.sh to BATS
* Bring templates/gradle.shlib and templates/maven.shlib into this repository.
* Develop an "all-test.sh" mode in which the first test failure fails the script. Currently all
  tests are run, and failures are reported, but the script does not fail on test failure.