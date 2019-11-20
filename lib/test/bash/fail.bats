load bash-library

#
# fail() tests
#

function teardown() {

    rm -f ${BATS_TEST_DIRNAME}/tmp/stdout
    rm -f ${BATS_TEST_DIRNAME}/tmp/stderr
}

@test "exit code" {

    run fail "blah"

    [[ ${status} -eq 255 ]]
    [[ "${output}" = "[failure]: blah" ]]
}

@test "stderr" {

    run $(fail "blah" 1>${BATS_TEST_DIRNAME}/tmp/stdout 2>${BATS_TEST_DIRNAME}/tmp/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/tmp/stderr) = "[failure]: blah" ]]
}
