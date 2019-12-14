load bash-library

#
# error() tests
#

function teardown() {

    rm -f ${BATS_TEST_DIRNAME}/data/tmp/*
}

@test "exit code" {

    run error "blah"

    [[ ${status} -eq 0 ]]
    [[ "${output}" = "[error]: blah" ]]
}

@test "configurable header" {

    ERROR_HEADER="Error:"

    run error "blah"

    [[ ${status} -eq 0 ]]
    [[ "${output}" = "Error: blah" ]]
}


@test "stderr" {

    run $(error "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "[error]: blah" ]]
}

@test "stderr, configurable header" {

    ERROR_HEADER="Error:"

    run $(error "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "Error: blah" ]]
}

@test "DEBUG_OUTPUT" {

    DEBUG_OUTPUT=${BATS_TEST_DIRNAME}/data/tmp/DEBUG_OUTPUT

    run $(error "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "[error]: blah" ]]
    [[ $(cat ${DEBUG_OUTPUT}) = "[error]: blah" ]]
}

@test "DEBUG_OUTPUT, configurable header" {

    ERROR_HEADER="Error:"

    DEBUG_OUTPUT=${BATS_TEST_DIRNAME}/data/tmp/DEBUG_OUTPUT

    run $(error "blah" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) = "Error: blah" ]]
    [[ $(cat ${DEBUG_OUTPUT}) = "Error: blah" ]]
}

