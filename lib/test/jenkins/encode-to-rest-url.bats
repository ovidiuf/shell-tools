load all-libraries

@test "no arg" {

    run encode-to-rest-url

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "does not need encoding" {

    run encode-to-rest-url something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "something" ]]
}

@test "slash" {

    run encode-to-rest-url a/b

    [[ ${status} -eq 0 ]]
    [[ ${output} = "a%252Fb" ]]
}

