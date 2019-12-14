load bash-library

#
# error() tests
#

function teardown() {

    rm -f ${BATS_TEST_DIRNAME}/data/error/*
}

@test "exit code" {

    run error "blah"

    [[ ${status} -eq 0 ]]
    [[ "${output}" = "[error]: blah" ]]
}

@test "stderr" {

    run $(error "blah" 1>${BATS_TEST_DIRNAME}/data/error/stdout 2>${BATS_TEST_DIRNAME}/data/error/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/error/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/error/stderr) = "[error]: blah" ]]
}

@test "DEBUG_OUTPUT" {

    DEBUG_OUTPUT=${BATS_TEST_DIRNAME}/data/error/DEBUG_OUTPUT

    run $(error "blah" 1>${BATS_TEST_DIRNAME}/data/error/stdout 2>${BATS_TEST_DIRNAME}/data/error/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/error/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/error/stderr) = "[error]: blah" ]]
    [[ $(cat ${DEBUG_OUTPUT}) = "[error]: blah" ]]
}

