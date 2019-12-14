load bash-library

#
# error() tests
#

function teardown() {

    rm -f ${BATS_TEST_DIRNAME}/data/error/stdout
    rm -f ${BATS_TEST_DIRNAME}/data/error/stderr
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

