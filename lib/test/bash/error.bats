load bash-library

#
# error() tests
#

function teardown() {

    rm -f ${BATS_TEST_DIRNAME}/tmp/stdout
    rm -f ${BATS_TEST_DIRNAME}/tmp/stderr
}

@test "exit code" {

    run error "blah"

    [[ ${status} -eq 0 ]]
    [[ "${output}" = "[error]: blah" ]]
}

@test "stderr" {

    run $(error "blah" 1>${BATS_TEST_DIRNAME}/tmp/stdout 2>${BATS_TEST_DIRNAME}/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/tmp/stderr) = "[error]: blah" ]]
}

