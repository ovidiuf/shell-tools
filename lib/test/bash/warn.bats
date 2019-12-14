load bash-library

#
# warn() tests
#

function teardown() {

    rm -f ${BATS_TEST_DIRNAME}/data/warn/stdout
    rm -f ${BATS_TEST_DIRNAME}/data/warn/stderr
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
