load bash-library

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/tmp/*
}

@test "VERBOSE false" {

    f=${BATS_TEST_DIRNAME}/data/tmp/test.txt
    echo "test" > ${f}
    [[ -s ${f} ]]

    VERBOSE=false

    run $(debug-file ${f} 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ ${status} -eq 0 ]]
    [[ -z "${output}" ]]

    [[ $(wc -c ${BATS_TEST_DIRNAME}/data/tmp/stdout | awk '{print $1}') = "0" ]]
    [[ $(wc -c ${BATS_TEST_DIRNAME}/data/tmp/stderr | awk '{print $1}') = "0" ]]
}

@test "VERBOSE true, file argument not provided" {

    VERBOSE=true

    run $(debug-file 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ ${status} -eq 0 ]]
    [[ -z "${output}" ]]

    [[ $(wc -c ${BATS_TEST_DIRNAME}/data/tmp/stdout | awk '{print $1}') = "0" ]]

    stderr=$(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr)
    [[ ${stderr} =~ "no file provided" ]]
}

@test "VERBOSE true, no such file" {

    VERBOSE=true

    run $(debug-file /no/such/file 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ ${status} -eq 0 ]]
    [[ -z "${output}" ]]

    [[ $(wc -c ${BATS_TEST_DIRNAME}/data/tmp/stdout | awk '{print $1}') = "0" ]]

    stderr=$(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr)
    [[ ${stderr} =~ "no such file: /no/such/file" ]]
}

@test "VERBOSE true, unreadable file" {

    VERBOSE=true

    f=${BATS_TEST_DIRNAME}/data/tmp/unreadable-file
    echo "test" > ${f}
    chmod -r ${f}
    [[ -s ${f} ]]
    [[ ! -r ${f} ]]

    run $(debug-file ${f} 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ ${status} -eq 0 ]]
    [[ -z "${output}" ]]

    [[ $(wc -c ${BATS_TEST_DIRNAME}/data/tmp/stdout | awk '{print $1}') = "0" ]]

    stderr=$(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr)
    [[ ${stderr} =~ "file is not readable: ${f}" ]]

    rm ${f} || exit 1
}

@test "VERBOSE true" {

    VERBOSE=true

    f=${BATS_TEST_DIRNAME}/data/tmp/test.txt
    echo "test" > ${f}
    [[ -s ${f} ]]

    run $(debug-file ${f} 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ ${status} -eq 0 ]]
    [[ -z "${output}" ]]

    [[ $(wc -c ${BATS_TEST_DIRNAME}/data/tmp/stdout | awk '{print $1}') = "0" ]]

    stderr=$(cat ${BATS_TEST_DIRNAME}/data/tmp/stderr)
    [[ ${stderr} = "test" ]]
}

@test "VERBOSE true, DEBUG_OUTPUT set" {

    VERBOSE=true
    DEBUG_OUTPUT=${BATS_TEST_DIRNAME}/data/tmp/DEBUG_OUTPUT

    f=${BATS_TEST_DIRNAME}/data/tmp/test.txt
    echo "test" > ${f}
    [[ -s ${f} ]]

    run $(debug-file ${f} 1>${BATS_TEST_DIRNAME}/data/tmp/stdout 2>${BATS_TEST_DIRNAME}/data/tmp/stderr)

    [[ ${status} -eq 0 ]]
    [[ -z "${output}" ]]

    [[ $(wc -c ${BATS_TEST_DIRNAME}/data/tmp/stdout | awk '{print $1}') = "0" ]]
    [[ $(wc -c ${BATS_TEST_DIRNAME}/data/tmp/stderr | awk '{print $1}') = "0" ]]

    s=$(cat ${BATS_TEST_DIRNAME}/data/tmp/DEBUG_OUTPUT)
    [[ ${s} = "test" ]]
}

