load bash-library

#
# warn() tests
#

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/warn/*
}

@test "exit code" {

    run warn "blah"

    [[ ${status} -eq 0 ]]
    [[ "${output}" = "[warning]: blah" ]]
}

@test "stderr" {

    run $(warn "blah" 1>${BATS_TEST_DIRNAME}/data/warn/stdout 2>${BATS_TEST_DIRNAME}/data/warn/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/warn/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/warn/stderr) = "[warning]: blah" ]]
}

@test "DEBUG_OUTPUT" {

    DEBUG_OUTPUT=${BATS_TEST_DIRNAME}/data/warn/DEBUG_OUTPUT

    run $(warn "blah" 1>${BATS_TEST_DIRNAME}/data/warn/stdout 2>${BATS_TEST_DIRNAME}/data/warn/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/warn/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/warn/stderr) = "[warning]: blah" ]]
    [[ $(cat ${DEBUG_OUTPUT}) = "[warning]: blah" ]]
}
