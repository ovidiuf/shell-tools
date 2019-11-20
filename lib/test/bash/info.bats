load bash-library

#
# info() tests
#

function teardown() {

    rm -f ${BATS_TEST_DIRNAME}/tmp/stdout
    rm -f ${BATS_TEST_DIRNAME}/tmp/stderr
}

@test "basic" {

    stderr_content=$(info "blah" 2>&1)

    exit_code=$?

    [[ ${exit_code} -eq 0 ]]
    [[ "${stderr_content}" = "blah" ]]
}

@test "stderr redirected to /dev/null" {

    stderr_content=$(info "blah" 2>/dev/null)

    exit_code=$?

    [[ ${exit_code} -eq 0 ]]
    [[ -z ${stdout_content} ]]
}

@test "sdtout and stderr" {

    run $(info "blah" 1>${BATS_TEST_DIRNAME}/tmp/stdout 2>${BATS_TEST_DIRNAME}/tmp/stderr )

    [[ -z $(cat ${BATS_TEST_DIRNAME}/tmp/stdout) ]]
    [[ $(cat ${BATS_TEST_DIRNAME}/tmp/stderr) = "blah" ]]
}

