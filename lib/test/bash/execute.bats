load bash-library

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/tmp/*
}

@test "command not provided" {

    run execute

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'command' not provided" ]]
}

@test "non-dry-run mode" {

    command="${BATS_TEST_DIRNAME}/data/execute/target-command"

    DRY_RUN=false

    run execute "${command}"

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ "${BATS_TEST_DIRNAME}/data/execute/target-command" ]]
    [[ ${output} =~ "target-command executed in active mode" ]]

    #
    # check that the command actually fired
    #
    [[ -f ${BATS_TEST_DIRNAME}/data/tmp/TARGET-COMMAND-EXECUTED ]]
}

@test "dry-run mode" {

    command="${BATS_TEST_DIRNAME}/data/execute/target-command"

    DRY_RUN=true

    run execute "${command}"

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ "[dry-run]: ${command}" ]]

    #
    # check that the command did not fire
    #
    [[ ! -f ${BATS_TEST_DIRNAME}/data/tmp/TARGET-COMMAND-EXECUTED ]]
}

@test "target command has a native dry-run option - non-dry-run mode - no extra argument" {

    command="${BATS_TEST_DIRNAME}/data/execute/target-command"

    DRY_RUN=false

    run execute "${command}" false --target-command-dry-run

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ "${BATS_TEST_DIRNAME}/data/execute/target-command" ]]
    [[ ${output} =~ "target-command executed in active mode" ]]

    #
    # check that the command actually fired
    #
    [[ -f ${BATS_TEST_DIRNAME}/data/tmp/TARGET-COMMAND-EXECUTED ]]
}

@test "target command has a native dry-run option - non-dry-run mode - extra argument" {

    command="${BATS_TEST_DIRNAME}/data/execute/target-command --extra-argument"

    DRY_RUN=false

    run execute "${command}" false --target-command-dry-run

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ "${BATS_TEST_DIRNAME}/data/execute/target-command --extra-argument" ]]
    [[ ${output} =~ "target-command executed in active mode" ]]

    #
    # check that the command actually fired
    #
    [[ -f ${BATS_TEST_DIRNAME}/data/tmp/TARGET-COMMAND-EXECUTED ]]
}

@test "target command has a native dry-run option - dry-run mode - no extra argument" {

    command="${BATS_TEST_DIRNAME}/data/execute/target-command"

    DRY_RUN=true

    run execute "${command}" false --target-command-dry-run

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ "${BATS_TEST_DIRNAME}/data/execute/target-command --target-command-dry-run" ]]
    [[ ${output} =~ "target-command executed in dry-run mode" ]]
}

@test "target command has a native dry-run option - dry-run mode - extra argument" {

    command="${BATS_TEST_DIRNAME}/data/execute/target-command --extra-argument"

    DRY_RUN=true

    run execute "${command}" false --target-command-dry-run

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ "${BATS_TEST_DIRNAME}/data/execute/target-command --target-command-dry-run --extra-argument" ]]
    [[ ${output} =~ "target-command executed in dry-run mode" ]]
}


