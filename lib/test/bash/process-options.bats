#!/usr/bin/env bash

load bash-library

function setup() {

    unset OPTIONS
    unset ARGS
}

@test "no 'OPTIONS' associative array declared" {

    #
    # test whether 'OPTIONS' was already declared as associative array; we fail if it is
    #
    if declare -A | grep -q "declare -A OPTIONS"; then
        exit 1
    fi

    run process-options --something

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "'OPTIONS' associative array not declared" ]]
}

@test "'OPTIONS' associative array declared but contains no values" {

    declare -A OPTIONS

    run process-options --something

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "'OPTIONS' associative array contains no values" ]]
}

@test "no 'ARGS' indexed array declared" {

    #
    # test whether 'ARGS' was already declared as associative array; we fail if it is
    #
    if declare -a | grep -q "declare -a ARGS"; then
        exit 1
    fi

    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    run process-options

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "'ARGS' indexed array not declared" ]]
}

@test "invalid option type" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="no-such-type"

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run process-options --something

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "invalid option type 'no-such-type' for option --something" ]]

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "no-such-type" ]]
}

@test "boolean option: no option value" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "false" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "boolean option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    process-options --something || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "true" ]]
}

@test "boolean option: redundant option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something --something --something || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "true" ]]
}

@test "boolean option: explicit true value" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something true || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "true" ]]
}

@test "boolean option: explicit false" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something false || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "false" ]]
}

@test "string option: missing value" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    run process-options --something

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "missing --something string value" ]]
}

@test "string option: missing value (2)" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    run process-options --something -somethingelse

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "missing --something string value" ]]
}

@test "string option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something blah || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "blah" ]]
}

@test "string option: quoted space-containing string" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something "one two three" || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "one two three" ]]
}

@test "string option: identical string options, last wins" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--color"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --color red --color blue || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--color"]} = "blue" ]]
}

@test "string option: multiple string options, of which some are identical, last wins" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--color"]="string"
    OPTIONS["--shape"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --color red --shape square --color blue || exit 1

    [[ ${#OPTIONS[@]} -eq 2 ]]
    [[ ${OPTIONS["--color"]} = "blue" ]]
    [[ ${OPTIONS["--shape"]} = "square" ]]
}

@test "string option: missing value" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    run process-options --something

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "missing --something string value" ]]
}

@test "string option: missing value (2)" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    run process-options --something -somethingelse

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "missing --something string value" ]]
}

@test "integer option: missing value" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="integer"

    run process-options --something

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "missing --something integer value" ]]
}

@test "integer option: missing value (2)" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="integer"

    run process-options --something -somethingelse

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "missing --something integer value" ]]
}

@test "integer option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="integer"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something 15 || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} -eq 15 ]]
}

@test "integer option: value not an integer" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="integer"

    run process-options --something blah

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "--something requires an integer value but got 'blah'" ]]
}

@test "integer option: quoted value" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="integer"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something "12" || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} -eq 12 ]]
}

@test "integer option: identical integer options, last wins" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--size"]="integer"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --size 10 --size 8 || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--size"]} = 8 ]]
}

@test "integer option: multiple integer options, of which some are identical, last wins" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--size"]="integer"
    OPTIONS["--price"]="integer"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --size 3 --price 9 --size 5 || exit 1

    [[ ${#OPTIONS[@]} -eq 2 ]]
    [[ ${OPTIONS["--size"]} = 5 ]]
    [[ ${OPTIONS["--price"]} = 9 ]]
}

@test "boolean, string and integer options" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--color"]="string"
    OPTIONS["--shape"]="string"
    OPTIONS["--size"]="integer"
    OPTIONS["--price"]="integer"
    OPTIONS["--discount"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    process-options --color blue --shape circle --size 3 --price 9 --discount --color red --size 5 || exit 1

    [[ ${#OPTIONS[@]} -eq 5 ]]
    [[ ${OPTIONS["--color"]} = "red" ]]
    [[ ${OPTIONS["--shape"]} = "circle" ]]
    [[ ${OPTIONS["--size"]} = 5 ]]
    [[ ${OPTIONS["--price"]} = 9 ]]
    [[ ${OPTIONS["--discount"]} = true ]]
}

@test "extra arguments" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options a --something b --c d || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "true" ]]
    [[ ${#ARGS[@]} -eq 4 ]]
    [[ ${ARGS[0]} = "a" ]]
    [[ ${ARGS[1]} = "b" ]]
    [[ ${ARGS[2]} = "--c" ]]
    [[ ${ARGS[3]} = "d" ]]
}

@test "extra arguments (2)" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--repository-url"]="string"
    OPTIONS["--chart-version"]="string"
    OPTIONS["--server-version"]="string"
    OPTIONS["--chart-name"]="string"
    OPTIONS["--state-directory"]="string"
    OPTIONS["--output-file"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options a --repository-url http://localhost --b --chart-version 1.0.0 c --server-version 2.0.0 d --output-file ./tmp.txt e || exit 1

    [[ ${#OPTIONS[@]} -eq 4 ]]
    [[ ${OPTIONS["--repository-url"]} = "http://localhost" ]]
    [[ ${OPTIONS["--chart-version"]} = "1.0.0" ]]
    [[ ${OPTIONS["--server-version"]} = "2.0.0" ]]
    [[ ${OPTIONS["--output-file"]} = "./tmp.txt" ]]
    [[ ${#ARGS[@]} -eq 5 ]]
    [[ ${ARGS[0]} = "a" ]]
    [[ ${ARGS[1]} = "--b" ]]
    [[ ${ARGS[2]} = "c" ]]
    [[ ${ARGS[3]} = "d" ]]
    [[ ${ARGS[4]} = "e" ]]
}

@test "string option with aliases" {

    declare -a ARGS
    unset OPTIONS
    declare -A OPTIONS
    OPTIONS["--color"]="string -c --COLOR"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    process-options --color red || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--color"]} = "red" ]]
    [[ ${#ARGS[@]} -eq 0 ]]

    unset OPTIONS
    declare -A OPTIONS
    OPTIONS["--color"]="string -c --COLOR"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options -c blue || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--color"]} = "blue" ]]
    [[ ${#ARGS[@]} -eq 0 ]]

    unset OPTIONS
    declare -A OPTIONS
    OPTIONS["--color"]="string -c --COLOR"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --COLOR green || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--color"]} = "green" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "integer option with equivalent aliases, last wins" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--size"]="integer -s --SIZE"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --size 10 -s 15 --SIZE 21 || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--size"]} = 21 ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

#
# "=" tests
#

@test "no 'OPTIONS' associative array declared, '=' is used with option" {

    #
    # test whether 'OPTIONS' was already declared as associative array; we fail if it is
    #
    if declare -A | grep -q "declare -A OPTIONS"; then
        exit 1
    fi

    run process-options --something=somethingelse

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "'OPTIONS' associative array not declared" ]]
}

@test "'OPTIONS' associative array declared but contains no values, '=' is used with option" {

    declare -A OPTIONS

    run process-options --something=somethingelse

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "'OPTIONS' associative array contains no values" ]]
}

@test "invalid option type, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="no-such-type"

    run process-options --something=something

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "invalid option type 'no-such-type' for option --something" ]]

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "no-such-type" ]]
}

@test "boolean option, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    process-options --something=true || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "true" ]]
}

@test "boolean option: redundant option, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something=true --something=true --something=true || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "true" ]]
}

@test "boolean option: overriding options, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something=true --something=false || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "false" ]]
}

@test "boolean option: overriding options, '=' is used with option for some" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something=true --something=false --something || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "true" ]]
}

@test "boolean option: explicit true value, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something=true || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "true" ]]
}

@test "boolean option: explicit false, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something=false || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "false" ]]
}

@test "string option: missing value, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    run process-options --something=

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "missing --something string value" ]]
}

@test "string option: missing value, '=' is used with option (2)" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    run process-options --something= -somethingelse

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "missing --something string value" ]]
}

@test "string option, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something=blah || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "blah" ]]
}

@test "string option: quoted space-containing string, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something="one two three" || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "one two three" ]]
}

@test "string option: identical string options, last wins, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--color"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --color=red --color=blue || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--color"]} = "blue" ]]
}

@test "string option: identical string options, last wins, '=' is used with option for some" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--color"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --color=red --color green --color=blue || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--color"]} = "blue" ]]
}

@test "string option: multiple string options, of which some are identical, last wins, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--color"]="string"
    OPTIONS["--shape"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --color=red --shape=square --color=blue || exit 1

    [[ ${#OPTIONS[@]} -eq 2 ]]
    [[ ${OPTIONS["--color"]} = "blue" ]]
    [[ ${OPTIONS["--shape"]} = "square" ]]
}

@test "string option: multiple string options, of which some are identical, last wins, '=' is used with option for some" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--color"]="string"
    OPTIONS["--shape"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --color fuchsia --shape triangle --color=red --color yellow --color=green --shape=circle --shape rectangle --shape=square --color=blue || exit 1

    [[ ${#OPTIONS[@]} -eq 2 ]]
    [[ ${OPTIONS["--color"]} = "blue" ]]
    [[ ${OPTIONS["--shape"]} = "square" ]]
}

@test "integer option: missing value, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="integer"

    run process-options --something=

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "missing --something integer value" ]]
}

@test "integer option: missing value, '=' is used with option (2)" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="integer"

    run process-options --something= -somethingelse

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "missing --something integer value" ]]
}

@test "integer option, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="integer"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something=15 || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} -eq 15 ]]
}

@test "integer option: value not an integer, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="integer"

    run process-options --something=blah

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "--something requires an integer value but got 'blah'" ]]
}

@test "integer option: quoted value, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="integer"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --something="12" || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} -eq 12 ]]
}

@test "integer option: identical integer options, last wins, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--size"]="integer"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --size=10 --size=8 || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--size"]} = 8 ]]
}

@test "integer option: identical integer options, last wins, '=' is used with option for some" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--size"]="integer"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --size 11 --size=10 --size 9 --size=8 || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--size"]} = 8 ]]
}

@test "integer option: multiple integer options, of which some are identical, last wins, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--size"]="integer"
    OPTIONS["--price"]="integer"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --size=3 --price=9 --size=5 || exit 1

    [[ ${#OPTIONS[@]} -eq 2 ]]
    [[ ${OPTIONS["--size"]} = 5 ]]
    [[ ${OPTIONS["--price"]} = 9 ]]
}

@test "integer option: multiple integer options, of which some are identical, last wins, '=' is used with option for some" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--size"]="integer"
    OPTIONS["--price"]="integer"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --size=3 --size 4 --price 6 --price=7 --price=9 --size=5 || exit 1

    [[ ${#OPTIONS[@]} -eq 2 ]]
    [[ ${OPTIONS["--size"]} = 5 ]]
    [[ ${OPTIONS["--price"]} = 9 ]]
}

@test "boolean, string and integer options, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--color"]="string"
    OPTIONS["--shape"]="string"
    OPTIONS["--size"]="integer"
    OPTIONS["--price"]="integer"
    OPTIONS["--discount"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    process-options --color=blue --shape=circle --size=3 --price=9 --discount=true --color=red --size=5 || exit 1

    [[ ${#OPTIONS[@]} -eq 5 ]]
    [[ ${OPTIONS["--color"]} = "red" ]]
    [[ ${OPTIONS["--shape"]} = "circle" ]]
    [[ ${OPTIONS["--size"]} = 5 ]]
    [[ ${OPTIONS["--price"]} = 9 ]]
    [[ ${OPTIONS["--discount"]} = true ]]
}

@test "extra arguments, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="boolean"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options a --something=true b= --c d || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--something"]} = "true" ]]
    [[ ${#ARGS[@]} -eq 4 ]]
    [[ ${ARGS[0]} = "a" ]]
    [[ ${ARGS[1]} = "b=" ]]
    [[ ${ARGS[2]} = "--c" ]]
    [[ ${ARGS[3]} = "d" ]]
}

@test "extra arguments (2), '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--repository-url"]="string"
    OPTIONS["--chart-version"]="string"
    OPTIONS["--server-version"]="string"
    OPTIONS["--chart-name"]="string"
    OPTIONS["--state-directory"]="string"
    OPTIONS["--output-file"]="string"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options a= --repository-url=http://localhost --b --chart-version=1.0.0 =c= --server-version=2.0.0 d --output-file=./tmp.txt =e || exit 1

    [[ ${#OPTIONS[@]} -eq 4 ]]
    [[ ${OPTIONS["--repository-url"]} = "http://localhost" ]]
    [[ ${OPTIONS["--chart-version"]} = "1.0.0" ]]
    [[ ${OPTIONS["--server-version"]} = "2.0.0" ]]
    [[ ${OPTIONS["--output-file"]} = "./tmp.txt" ]]
    [[ ${#ARGS[@]} -eq 5 ]]
    [[ ${ARGS[0]} = "a=" ]]
    [[ ${ARGS[1]} = "--b" ]]
    [[ ${ARGS[2]} = "=c=" ]]
    [[ ${ARGS[3]} = "d" ]]
    [[ ${ARGS[4]} = "=e" ]]
}

@test "string option with aliases, '=' is used with option" {

    declare -a ARGS
    unset OPTIONS
    declare -A OPTIONS
    OPTIONS["--color"]="string -c --COLOR"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --color=red || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--color"]} = "red" ]]
    [[ ${#ARGS[@]} -eq 0 ]]

    unset OPTIONS
    declare -A OPTIONS
    OPTIONS["--color"]="string -c --COLOR"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options -c=blue || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--color"]} = "blue" ]]
    [[ ${#ARGS[@]} -eq 0 ]]

    unset OPTIONS
    declare -A OPTIONS
    OPTIONS["--color"]="string -c --COLOR"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --COLOR=green || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--color"]} = "green" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "integer option with equivalent aliases, last wins, '=' is used with option" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--size"]="integer -s --SIZE"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    process-options --size=10 --size 11 -s=15 --SIZE=21 || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--size"]} = 21 ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "string option, error message heuristics" {

    declare -a ARGS
    declare -A OPTIONS
    OPTIONS["--something"]="string"

    run process-options --somethingblah

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "--somethingblah: invalid syntax, use --something=<string> or --something <string>" ]]
}

@test "an option alias is completely contained in another alias, the long alias is reference, long alias is argument" {

    declare -a ARGS
    declare -A OPTIONS

    OPTIONS["--AB"]="string --A"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    process-options --AB something || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--AB"]} = "something" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "an option alias is completely contained in another alias, the long alias is reference, short alias is argument" {

    declare -a ARGS
    declare -A OPTIONS

    OPTIONS["--AB"]="string --A"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    process-options --A something || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--AB"]} = "something" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "an option alias is completely contained in another alias, the short alias is reference, long alias is argument" {

    declare -a ARGS
    declare -A OPTIONS

    OPTIONS["--A"]="string --AB"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    process-options --AB something || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--A"]} = "something" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}

@test "an option alias is completely contained in another alias, the short alias is reference, short alias is argument" {

    declare -a ARGS
    declare -A OPTIONS

    OPTIONS["--A"]="string --AB"

    #
    # we don't use "run" because we need to execute the function in the same shell, so we share the associative array
    #
    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    process-options --A something || exit 1

    [[ ${#OPTIONS[@]} -eq 1 ]]
    [[ ${OPTIONS["--A"]} = "something" ]]
    [[ ${#ARGS[@]} -eq 0 ]]
}



