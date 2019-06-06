# How to Use SHLIB Functions

````
[[ -z "${SHLIB_DIR}" ]] && { echo "[error]: SHLIB_DIR not defined" 1>&2; exit 1; }
[[ -f ${SHLIB_DIR}/std.shlib ]] && . ${SHLIB_DIR}/std.shlib || { echo "[error]: ${SHLIB_DIR}/std.shlib not found" 1>&2; exit 1; }
[[ -f ${SHLIB_DIR}/ssh.shlib ]] && . ${SHLIB_DIR}/ssh.shlib || { echo "[error]: ${SHLIB_DIR}/ssh.shlib not found" 1>&2; exit 1; }

````

# Overview

Collection of generic bash functions. Grouped as follows:

* **bash.sh**: processing of common arguments such as -v or -d, and the customary fail()/error()/warn()/info()/debug().
* **java.sh**: utilities related to building and running Java.

# How to Locally Test Functions

```
./local.sh
```

# How to Run Tests

```
./tests.sh
```

tests.sh executes all component tests (bash.shlib, java.shlib, etc.) All tests must pass.

# TODO

Bring templates/gradle.shlib and templates/maven.shlib into this repository.