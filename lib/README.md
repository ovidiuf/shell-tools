# How to Use SHLIB Functions

````
[[ -z "${SHLIB_DIR}" ]] && { echo "[error]: SHLIB_DIR not defined" 1>&2; exit 1; }
[[ -f ${SHLIB_DIR}/std.shlib ]] && . ${SHLIB_DIR}/std.shlib || { echo "[error]: ${SHLIB_DIR}/std.shlib not found" 1>&2; exit 1; }
[[ -f ${SHLIB_DIR}/ssh.shlib ]] && . ${SHLIB_DIR}/ssh.shlib || { echo "[error]: ${SHLIB_DIR}/ssh.shlib not found" 1>&2; exit 1; }

````