load required-libraries

@test "no arguments" {

    run to-json-list

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[]" ]]
}

@test "empty string" {

    run to-json-list ""

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[]" ]]
}

@test "one element list" {

    run to-json-list something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[\"something\"]" ]]
}

@test "one element list, quoted" {

    run to-json-list "something something-else"

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[\"something something-else\"]" ]]
}


@test "two element list" {

    run to-json-list something something-else

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[\"something\", \"something-else\"]" ]]
}

@test "two element list, of which one is quoted" {

    run to-json-list something "something-else yet-another-else"

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[\"something\", \"something-else yet-another-else\"]" ]]
}

@test "three element list" {

    run to-json-list "red" blue green

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[\"red\", \"blue\", \"green\"]" ]]
}
