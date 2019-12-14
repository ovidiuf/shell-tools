load bash-library

#
# fail() tests
#

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/tmp/*
}

@test "exit code" {

    run fail "blah"

    [[ ${status} -eq 255 ]]
    [[ "${output}" = "[error]: blah" ]]
}

@test "configurable header" {

    FAIL_HEADER="Fail:"

    run fail "blah"

    [[ ${status} -eq 255 ]]
    [[ "${output}" = "Fail: blah" ]]
}

@test "stderr" {

    run $(fail "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "[error]: blah" ]]
}

@test "stderr, configurable header" {

    FAIL_HEADER="Fail:"

    run $(fail "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "Fail: blah" ]]
}

@test "DEBUG_OUTPUT" {

    DEBUG_OUTPUT=${BATS_TEST_DIRNAME}/data/tmp/DEBUG_OUTPUT

    run $(fail "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "[error]: blah" ]]
    [[ $(cat ${DEBUG_OUTPUT}) = "[error]: blah" ]]
}

@test "DEBUG_OUTPUT, configurable header" {

    FAIL_HEADER="Fail:"

    DEBUG_OUTPUT=${BATS_TEST_DIRNAME}/data/tmp/DEBUG_OUTPUT

    run $(fail "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "Fail: blah" ]]
    [[ $(cat ${DEBUG_OUTPUT}) = "Fail: blah" ]]
}