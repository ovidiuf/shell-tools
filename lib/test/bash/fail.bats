load bash-library

#
# fail() tests
#

function teardown() {

    rm -f ${BATS_TEST_DIRNAME}/data/fail/stdout
    rm -f ${BATS_TEST_DIRNAME}/data/fail/stderr
}

@test "exit code" {

    run fail "blah"

    [[ ${status} -eq 255 ]]
    [[ "${output}" = "[failure]: blah" ]]
}

@test "stderr" {

    run $(fail "blah" 1>${BATS_TEST_DIRNAME}/data/fail/stdout 2>${BATS_TEST_DIRNAME}/data/fail/stderr )
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/fail/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/data/fail/stderr) = "[failure]: blah" ]]
}
