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
./local.sh
```

# How to Run Per-Function Tests

```
bats ./test/bash/info.bats
```

# How to Run All Tests

```
./tests/all-tests.sh
```

`all-tests.sh` executes all component tests (bash.shlib, java.shlib, etc.). All tests must pass.


# TODO

* Convert old style of testing java-tests.sh to BATS
* Bring templates/gradle.shlib and templates/maven.shlib into this repository.