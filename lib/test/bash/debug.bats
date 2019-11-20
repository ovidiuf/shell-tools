load bash-library

#
# debug() tests
#

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

    rm -f ${BATS_TEST_DIRNAME}/tmp/stdout
    rm -f ${BATS_TEST_DIRNAME}/tmp/stderr
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

    run $(debug "blah" 1>${BATS_TEST_DIRNAME}/tmp/stdout 2>${BATS_TEST_DIRNAME}/tmp/stderr)

    [[ -z $(cat ${BATS_TEST_DIRNAME}/tmp/stdout) ]]
    [[ -z $(cat ${BATS_TEST_DIRNAME}/tmp/stderr) ]]

    export VERBOSE=true

    run $(debug "blah" 1>${BATS_TEST_DIRNAME}/tmp/stdout 2>${BATS_TEST_DIRNAME}/tmp/stderr)

    [[ -z $(cat ${BATS_TEST_DIRNAME}/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/tmp/stderr) = "blah" ]]
}