load required-libraries

@test "no arguments" {

    run space-separated-list-to-json-list

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[]" ]]
}

@test "empty string" {

    run space-separated-list-to-json-list ""

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[]" ]]
}

@test "one element list" {

    run space-separated-list-to-json-list something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[\"something\"]" ]]
}

@test "two element list" {

    run space-separated-list-to-json-list "something something-else"

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[\"something\", \"something-else\"]" ]]
}

@test "three element list" {

    run space-separated-list-to-json-list "red blue green"

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[\"red\", \"blue\", \"green\"]" ]]
}
