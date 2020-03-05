#!/usr/bin/env bash

load bash-library

@test "no 'ARGS' indexed array" {

    unset ARGS

    run fail-on-unknown-arguments

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "no 'ARGS' indexed array, index present as argument" {

    unset ARGS

    run fail-on-unknown-arguments 3

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "one unknown argument" {

    declare -a ARGS
    ARGS[0]="something"

    run fail-on-unknown-arguments

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "unknown argument(s): something" ]]
}

@test "one element in ARGS, 'unknown' index starts from 1" {

    declare -a ARGS
    ARGS[0]="something"

    run fail-on-unknown-arguments 1

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "two elements in ARGS, 'unknown' index starts from 1" {

    declare -a ARGS
    ARGS[0]="red"
    ARGS[1]="blue"

    run fail-on-unknown-arguments 1

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "unknown argument(s): blue" ]]
}

@test "two unknown arguments" {

    declare -a ARGS
    ARGS[0]="something"
    ARGS[1]="something else"

    run fail-on-unknown-arguments

    [[ ${status} -eq 1 ]]
    echo ${output} > ~/tmp/bats.out
    [[ ${output} =~ "unknown argument(s): something, something else" ]]
}

@test "several arguments in ARGS, 'unknown' index starts after the last argument" {

    declare -a ARGS
    ARGS[0]="red"
    ARGS[1]="blue"
    ARGS[2]="green"

    run fail-on-unknown-arguments 3

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "several arguments in ARGS, 'unknown' index starts from a large number" {

    declare -a ARGS
    ARGS[0]="red"
    ARGS[1]="blue"
    ARGS[2]="green"

    run fail-on-unknown-arguments 15

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "index not an integer" {

    declare -a ARGS
    ARGS[0]="red"

    run fail-on-unknown-arguments blah "some error message"

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "invalid array index: blah" ]]
}

@test "no 'ARGS' indexed array, index and custom error message present" {

    unset ARGS

    run fail-on-unknown-arguments 1 "test error message"

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "no 'ARGS' indexed array, index and custom error message present as argument" {

    unset ARGS

    run fail-on-unknown-arguments 3 "test error message"

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "one unknown argument, index not present but custom error message is present" {

    declare -a ARGS
    ARGS[0]="something"

    run fail-on-unknown-arguments "test error message:"

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "test error message: something" ]]
}

@test "one element in ARGS, 'unknown' index starts from 1, custom error message present" {

    declare -a ARGS
    ARGS[0]="something"

    run fail-on-unknown-arguments 1 "test error message:"

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "two elements in ARGS, 'unknown' index starts from 1, custom error message present" {

    declare -a ARGS
    ARGS[0]="red"
    ARGS[1]="blue"

    run fail-on-unknown-arguments 1 "test error message(s):"

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "test error message(s): blue" ]]
}

@test "two unknown arguments, custom error message present" {

    declare -a ARGS
    ARGS[0]="something"
    ARGS[1]="something else"

    run fail-on-unknown-arguments "test error message(s):"

    [[ ${status} -eq 1 ]]
    echo ${output} > ~/tmp/bats.out
    [[ ${output} =~ "test error message(s): something, something else" ]]
}

@test "several arguments in ARGS, 'unknown' index starts after the last argument, custom error message present" {

    declare -a ARGS
    ARGS[0]="red"
    ARGS[1]="blue"
    ARGS[2]="green"

    run fail-on-unknown-arguments 3 "test error message"

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "several arguments in ARGS, 'unknown' index starts from a large number, custom error message present" {

    declare -a ARGS
    ARGS[0]="red"
    ARGS[1]="blue"
    ARGS[2]="green"

    run fail-on-unknown-arguments 15 "test error message"

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}




