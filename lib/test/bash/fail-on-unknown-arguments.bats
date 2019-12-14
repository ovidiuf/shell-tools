#!/usr/bin/env bash

load bash-library

@test "no 'ARGS' indexed array" {

    unset ARGS

    run fail-on-unknown-arguments

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "one unknown argument'" {

    declare -a ARGS
    ARGS[0]="something"

    run fail-on-unknown-arguments

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "unknown argument(s): something" ]]
}

@test "two unknown arguments'" {

    declare -a ARGS
    ARGS[0]="something"
    ARGS[1]="something else"

    run fail-on-unknown-arguments

    [[ ${status} -eq 1 ]]
    echo ${output} > ~/tmp/bats.out
    [[ ${output} =~ "unknown argument(s): something, something else" ]]
}