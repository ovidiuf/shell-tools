#!/usr/bin/env bash

load bash-library

function setup() {

    #
    # resets the global environment to expected state
    #

    unset ARGS
    declare -a ARGS
    export VERBOSE=false
    export HELP=false
}

function test-expected-global-environment-state() {

    #
    # independently insure that the global environment is in expected state
    #
    [[ ${VERBOSE} = "false" ]]
    [[ ${HELP} = "false" ]]
    [[ ${#ARGS[@]} = 0 ]]
}

@test "three normal arguments" {

    test-expected-global-environment-state

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    process-common-arguments a b c || exit 1

    [[ ${VERBOSE} = "false" ]]
    [[ ${HELP} = "false" ]]
    [[ ${#ARGS[@]} -eq 3 ]]
    [[ ${ARGS[0]} = "a" ]]
    [[ ${ARGS[1]} = "b" ]]
    [[ ${ARGS[2]} = "c" ]]
}

@test "-v handling" {

    test-expected-global-environment-state

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    process-common-arguments -v || exit 1

    [[ ${VERBOSE} = "true" ]]
    [[ ${HELP} = "false" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "--verbose handling" {

    test-expected-global-environment-state

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    process-common-arguments --verbose || exit 1

    [[ ${VERBOSE} = "true" ]]
    [[ ${HELP} = "false" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "-v and a normal argument, in this order" {

    test-expected-global-environment-state

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    process-common-arguments -v blah || exit 1

    [[ ${VERBOSE} = "true" ]]
    [[ ${HELP} = "false" ]]
    [[ ${#ARGS[@]} -eq 1 ]]
    [[ ${ARGS[0]} = "blah" ]]
}

@test "a normal argument and -v, in this order" {

    test-expected-global-environment-state

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    process-common-arguments blah -v || exit 1

    [[ ${VERBOSE} = "true" ]]
    [[ ${#ARGS[@]} -eq 1 ]]
    [[ ${ARGS[0]} = "blah" ]]
}

@test "a normal argument and duplicate -v" {

    test-expected-global-environment-state

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    process-common-arguments -v blah -v || exit 1

    [[ ${VERBOSE} = "true" ]]
    [[ ${#ARGS[@]} -eq 1 ]]
    [[ ${ARGS[0]} = "blah" ]]
}

@test "-h handling" {

    test-expected-global-environment-state

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    process-common-arguments -h || exit 1

    [[ ${VERBOSE} = "false" ]]
    [[ ${HELP} = "true" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "help handling" {

    test-expected-global-environment-state

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    process-common-arguments help || exit 1

    [[ ${VERBOSE} = "false" ]]
    [[ ${HELP} = "true" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "--help handling" {

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    test-expected-global-environment-state

    process-common-arguments --help || exit 1

    [[ ${VERBOSE} = "false" ]]
    [[ ${HELP} = "true" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}


@test "-h and a normal argument, in this order" {

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    test-expected-global-environment-state

    process-common-arguments -h blah || exit 1

    [[ ${VERBOSE} = "false" ]]
    [[ ${HELP} = "true" ]]
    [[ ${#ARGS[@]} -eq 1 ]]
    [[ ${ARGS[0]} = "blah" ]]
}

@test "process-common-arguments-() usage" {

    #
    # we don't use "run" because we need to execute the function in the same shell
    #
    test-expected-global-environment-state

    process-common-arguments a "b c" -v d && set -- "${ARGS[@]}" || exit 1

    [[ ${VERBOSE} = "true" ]]
    [[ ${HELP} = "false" ]]

    [[ $1 = "a" ]]
    [[ $2 = "b c" ]]
    [[ $3 = "d" ]]
}


