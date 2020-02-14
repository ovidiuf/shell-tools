load bash-library

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/tmp/*
}

@test "type required" {

    run input

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "a type (string, secret, integer, boolean) is required" ]]
}

@test "unsupported type" {

    run input something

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "invalid type something" ]]
    [[ ${output} =~ "Only string, secret, integer and boolean are supported." ]]
}

@test "string" {

    run $(echo "test text data" | input string "test prompt" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ ${status} -eq 0 ]]

    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) = "test text data" ]]
    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) ]]
}

#@test "secret" {
#
#    run $(echo "secret test text data" | input secret "secret test prompt" 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)
#
#    [[ ${status} -eq 0 ]]
#
#    [[ $(cat ${BATS_TEST_DIRNAME}/data/tmp/stdout) = "secret test text data" ]]
#    [[ -z $(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr) ]]
#}

