load bash-library

#
# warn() tests
#

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/tmp/*
}

@test "exit code" {

    run warn "blah"

    [[ ${status} -eq 0 ]]
    [[ "${output}" = "[warning]: blah" ]]
}

@test "configurable header" {

    WARNING_HEADER="Warning:"

    run warn "blah"

    [[ ${status} -eq 0 ]]
    [[ "${output}" = "Warning: blah" ]]
}

@test "stderr" {

    run $(warn "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "[warning]: blah" ]]
}

@test "stderr, configurable header" {

    WARNING_HEADER="Warning:"

    run $(warn "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "Warning: blah" ]]
}

@test "DEBUG_OUTPUT" {

    DEBUG_OUTPUT=${BATS_TEST_DIRNAME}/data/tmp/DEBUG_OUTPUT

    run $(warn "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "[warning]: blah" ]]
    [[ $(cat ${DEBUG_OUTPUT}) = "[warning]: blah" ]]
}

@test "DEBUG_OUTPUT, configurable header" {

    WARNING_HEADER="Warning:"

    DEBUG_OUTPUT=${BATS_TEST_DIRNAME}/data/tmp/DEBUG_OUTPUT

    run $(warn "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "Warning: blah" ]]
    [[ $(cat ${DEBUG_OUTPUT}) = "Warning: blah" ]]
}
