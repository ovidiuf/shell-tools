load bash-library

function setup() {

    #
    # resets the global environment to expected state
    #

    unset ARGS
    declare -a ARGS
    export VERBOSE=false
    export HELP=false
}

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/tmp/*
}

function test-expected-global-environment-state() {

    #
    # independently insure that the global environment is in expected state
    #
    [[ ${VERBOSE} = "false" ]]
    [[ ${HELP} = "false" ]]
    [[ ${#ARGS[@]} = 0 ]]
}

@test "exit code" {

    test-expected-global-environment-state

    run debug "blah"

    [[ ${status} -eq 0 ]]
    [[ -z "${output}" ]]

    export VERBOSE=true

    run debug "blah"

    [[ ${status} -eq 0 ]]
    [[ "${output}" = "blah" ]]
}

@test "stderr" {

    test-expected-global-environment-state

    run $(debug "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) ]]

    export VERBOSE=true

    run $(debug "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "blah" ]]
}

@test "DEBUG_OUTPUT " {

    test-expected-global-environment-state

    run $(debug "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) ]]

    export VERBOSE=true
    export DEBUG_OUTPUT=${BATS_TEST_DIRNAME}/data/tmp/DEBUG_OUTPUT

    run $(debug "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/DEBUG_OUTPUT) = "blah" ]]
}