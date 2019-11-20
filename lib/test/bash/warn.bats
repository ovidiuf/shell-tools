load bash-library

#
# warn() tests
#

function teardown() {

    rm -f ${BATS_TEST_DIRNAME}/tmp/stdout
    rm -f ${BATS_TEST_DIRNAME}/tmp/stderr
}

@test "exit code" {

    run warn "blah"

    [[ ${status} -eq 0 ]]
    [[ "${output}" = "[warning]: blah" ]]
}

@test "stderr" {

    run $(warn "blah" 1>${BATS_TEST_DIRNAME}/tmp/stdout 2>${BATS_TEST_DIRNAME}/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/tmp/stderr) = "[warning]: blah" ]]
}
