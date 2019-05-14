#!/usr/bin/env bash

[[ -f $(dirname $0)/$(basename $0 -tests.sh).shlib ]] && . $(dirname $0)/$(basename $0 -tests.sh).shlib || { echo "$(dirname $0)/$(basename $0 -tests.sh).shlib does not exist" 1>&2; exit 1; }

function reset-global-variables() {

    unset ARGS
    declare -a ARGS
    export VERBOSE=false
    export HELP=false
}

function test-preconditions() {

    reset-global-variables

    ${VERBOSE} && fail "VERBOSE should be false"
    ${HELP} && fail "HELP should be false"
    [[ ${#ARGS[@]} = 0 ]] || fail "ARGS should be empty"
}

#
# three normal arguments
#
function process-common-arguments-test-01() {

    echo -n "${FUNCNAME[0]} ... "

    test-preconditions

    process-common-arguments a b c || fail "process-common-arguments returned a non-zero code"

    ${VERBOSE} && fail "VERBOSE should be false"
    [[ ${#ARGS[@]} = 3 ]] || fail "ARGS should have 3 elements"
    [[ ${ARGS[0]} = "a" ]] || fail "ARGS[0] not a"
    [[ ${ARGS[1]} = "b" ]] || fail "ARGS[1] not b"
    [[ ${ARGS[2]} = "c" ]] || fail "ARGS[2] not c"

    echo "ok"
}

#
# -v
#
function process-common-arguments-test-02() {

    echo -n "${FUNCNAME[0]} ... "

    test-preconditions

    process-common-arguments -v || fail "process-common-arguments returned a non-zero code"

    ${VERBOSE} || fail "VERBOSE should be true"
    [[ ${#ARGS[@]} = 0 ]] || fail "ARGS should be empty"

    echo "ok"
}

#
# --verbose
#
function process-common-arguments-test-03() {

    echo -n "${FUNCNAME[0]} ... "

    test-preconditions

    process-common-arguments --verbose || fail "process-common-arguments returned a non-zero code"

    ${VERBOSE} || fail "VERBOSE should be true"
    [[ ${#ARGS[@]} = 0 ]] || fail "ARGS should be empty"

    echo "ok"
}

#
# -v and a normal argument, in this order
#
function process-common-arguments-test-04() {

    echo -n "${FUNCNAME[0]} ... "

    test-preconditions

    process-common-arguments -v blah || fail "process-common-arguments returned a non-zero code"

    ${VERBOSE} || fail "VERBOSE should be true"
    [[ ${#ARGS[@]} = 1 ]] || fail "ARGS should have 1 element"
    [[ ${ARGS[0]} = "blah" ]] || fail "ARGS[0] not blah"

    echo "ok"
}

#
# a normal argument and -v, in this order
#
function process-common-arguments-test-05() {

    echo -n "${FUNCNAME[0]} ... "

    test-preconditions

    process-common-arguments blah -v || fail "process-common-arguments returned a non-zero code"

    ${VERBOSE} || fail "VERBOSE should be true"
    [[ ${#ARGS[@]} = 1 ]] || fail "ARGS should have 1 element"
    [[ ${ARGS[0]} = "blah" ]] || fail "ARGS[0] not blah"

    echo "ok"
}

#
# a normal argument and duplicate -v
#
function process-common-arguments-test-06() {

    echo -n "${FUNCNAME[0]} ... "

    test-preconditions

    process-common-arguments -v blah -v || fail "process-common-arguments returned a non-zero code"

    ${VERBOSE} || fail "VERBOSE should be true"
    [[ ${#ARGS[@]} = 1 ]] || fail "ARGS should have 1 element"
    [[ ${ARGS[0]} = "blah" ]] || fail "ARGS[0] not blah"

    echo "ok"
}

#
# -h
#
function process-common-arguments-test-07() {

    echo -n "${FUNCNAME[0]} ... "

    test-preconditions

    process-common-arguments -h || fail "process-common-arguments returned a non-zero code"

    ${VERBOSE} && fail "VERBOSE should be false"
    ${HELP} || fail "HELP should be true"
    [[ ${#ARGS[@]} = 0 ]] || fail "ARGS should be empty"

    echo "ok"
}

#
# --help
#
function process-common-arguments-test-08() {

    echo -n "${FUNCNAME[0]} ... "

    test-preconditions

    process-common-arguments --help || fail "process-common-arguments returned a non-zero code"

    ${VERBOSE} && fail "VERBOSE should be false"
    ${HELP} || fail "HELP should be true"
    [[ ${#ARGS[@]} = 0 ]] || fail "ARGS should be empty"

    echo "ok"
}

#
# -h and a normal argument, in this order
#
function process-common-arguments-test-09() {

    echo -n "${FUNCNAME[0]} ... "

    test-preconditions

    process-common-arguments -h blah || fail "process-common-arguments returned a non-zero code"

    ${VERBOSE} && fail "VERBOSE should be false"
    ${HELP} || fail "HELP should be true"
    [[ ${#ARGS[@]} = 1 ]] || fail "ARGS should have 1 element"
    [[ ${ARGS[0]} = "blah" ]] || fail "ARGS[0] not blah"

    echo "ok"
}

function process-common-arguments-usage-test-01() {

    echo -n "${FUNCNAME[0]} ... "

    test-preconditions

    process-common-arguments a "b c" -v d && set -- "${ARGS[@]}" || { echo "failed to process common elements" 1>&2; exit 1; }

    ${VERBOSE} || fail "VERBOSE was not set to true"
    ${HELP} && fail "HELP was inadvertently set to true"

    [[ $1 = "a" ]] || fail "\$1 is not a but $1"
    [[ $2 = "b c" ]] || fail "\$2 is not \"b c\" but $2"
    [[ $3 = "d" ]] || fail "\$3 is not d but $3"

    reset-global-variables

    echo "ok"
}

#
# test that the expected content is sent to stderr
#
function fail-test-01() {

    echo -n "${FUNCNAME[0]} ... "

    local stderr_content

    stderr_content=$(fail "blah" 2>&1)

    local exit_code=$?

    [[ ${exit_code} = 255 ]] || fail "exit code not 255"

    local expected_stderr_content="[failure]: blah"

    [[ "${stderr_content}" = "${expected_stderr_content}" ]] || fail "unexpected stderr content: \"${stderr_content}\", it should have been \"${expected_stderr_content}\""

    echo "ok"
}

#
# test that no content is sent to stdout
#
function fail-test-02() {

    echo -n "${FUNCNAME[0]} ... "

    local stdout_content

    stdout_content=$(fail "blah" 2>/dev/null)

    local exit_code=$?

    [[ ${exit_code} = 255 ]] || fail "exit code not 255"

    [[ -z ${stdout_content} ]] || fail "content was sent to stdout ${stdout_content}"

    echo "ok"
}

#
# test that the expected content is sent to stderr
#
function error-test-01() {

    echo -n "${FUNCNAME[0]} ... "

    local stderr_content

    stderr_content=$(error "blah" 2>&1)

    local exit_code=$?

    [[ ${exit_code} = 0 ]] || fail "exit code not 0"

    local expected_stderr_content="[error]: blah"

    [[ "${stderr_content}" = "${expected_stderr_content}" ]] || fail "unexpected stderr content: \"${stderr_content}\", it should have been \"${expected_stderr_content}\""

    echo "ok"
}

#
# test that no content is sent to stdout
#
function error-test-02() {

    echo -n "${FUNCNAME[0]} ... "

    local stdout_content

    stdout_content=$(error "blah" 2>/dev/null)

    local exit_code=$?

    [[ ${exit_code} = 0 ]] || fail "exit code not 0"

    [[ -z ${stdout_content} ]] || fail "content was sent to stdout ${stdout_content}"

    echo "ok"
}

#
# test that the expected content is sent to stderr
#
function warn-test-01() {

    echo -n "${FUNCNAME[0]} ... "

    local stderr_content

    stderr_content=$(warn "blah" 2>&1)

    local exit_code=$?

    [[ ${exit_code} = 0 ]] || fail "exit code not 0"

    local expected_stderr_content="[warning]: blah"

    [[ "${stderr_content}" = "${expected_stderr_content}" ]] || fail "unexpected stderr content: \"${stderr_content}\", it should have been \"${expected_stderr_content}\""

    echo "ok"
}

#
# test that no content is sent to stdout
#
function warn-test-02() {

    echo -n "${FUNCNAME[0]} ... "

    local stdout_content

    stdout_content=$(warn "blah" 2>/dev/null)

    local exit_code=$?

    [[ ${exit_code} = 0 ]] || fail "exit code not 0"

    [[ -z ${stdout_content} ]] || fail "content was sent to stdout ${stdout_content}"

    echo "ok"
}

#
# test that the expected content is sent to stderr
#
function info-test-01() {

    echo -n "${FUNCNAME[0]} ... "

    local stderr_content

    stderr_content=$(info "blah" 2>&1)

    local exit_code=$?

    [[ ${exit_code} = 0 ]] || fail "exit code not 0"

    local expected_stderr_content="blah"

    [[ "${stderr_content}" = "${expected_stderr_content}" ]] || fail "unexpected stderr content: \"${stderr_content}\", it should have been \"${expected_stderr_content}\""

    echo "ok"
}

#
# test that no content is sent to stdout
#
function info-test-02() {

    echo -n "${FUNCNAME[0]} ... "

    local stdout_content

    stdout_content=$(info "blah" 2>/dev/null)

    local exit_code=$?

    [[ ${exit_code} = 0 ]] || fail "exit code not 0"

    [[ -z ${stdout_content} ]] || fail "content was sent to stdout ${stdout_content}"

    echo "ok"
}

#
# test that no content is sent to stderr when VERBOSE=false and expected content is sent to stderr when VERBOSE=true
#
function debug-test-01() {

    echo -n "${FUNCNAME[0]} ... "

    reset-global-variables

    ${VERBOSE} && fail "VERBOSE is not supposed to be true"

    local stderr_content

    stderr_content=$(debug "blah" 2>&1)

    local exit_code=$?

    [[ ${exit_code} = 0 ]] || fail "exit code not 0"

    [[ -z ${stderr_content} ]] || fail "content was sent to stderr ${stderr_content}"

    VERBOSE=true

    stderr_content=$(info "blah" 2>&1)

    local expected_stderr_content="blah"

    [[ "${stderr_content}" = "${expected_stderr_content}" ]] || fail "unexpected stderr content: \"${stderr_content}\", it should have been \"${expected_stderr_content}\""

    reset-global-variables

    echo "ok"
}

#
# test that no content is sent to stdout
#
function debug-test-02() {

    echo -n "${FUNCNAME[0]} ... "

    reset-global-variables

    ${VERBOSE} && fail "VERBOSE is not supposed to be true"

    local stdout_content

    stdout_content=$(debug "blah" 2>/dev/null)

    local exit_code=$?

    [[ ${exit_code} = 0 ]] || fail "exit code not 0"

    [[ -z ${stdout_content} ]] || fail "content was sent to stdout ${stdout_content}"

    VERBOSE=true

    stdout_content=$(debug "blah" 2>/dev/null)

    local exit_code=$?

    [[ ${exit_code} = 0 ]] || fail "exit code not 0"

    [[ -z ${stdout_content} ]] || fail "content was sent to stdout ${stdout_content}"

    reset-global-variables

    echo "ok"
}

function main() {

    echo $0:

    process-common-arguments-test-01 || exit 1
    process-common-arguments-test-02 || exit 1
    process-common-arguments-test-03 || exit 1
    process-common-arguments-test-04 || exit 1
    process-common-arguments-test-05 || exit 1
    process-common-arguments-test-06 || exit 1
    process-common-arguments-test-07 || exit 1
    process-common-arguments-test-08 || exit 1
    process-common-arguments-test-09 || exit 1

    process-common-arguments-usage-test-01 || exit 1

    fail-test-01 || exit 1
    fail-test-02 || exit 1

    error-test-01 || exit 1
    error-test-02 || exit 1

    warn-test-01 || exit 1
    warn-test-02 || exit 1

    info-test-01 || exit 1
    info-test-02 || exit 1

    debug-test-01 || exit 1
    debug-test-02 || exit 1
}

main "$@"

