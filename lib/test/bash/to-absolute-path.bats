load bash-library

#
# to-absolute-path() tests
#

@test "argument not provided" {

    run to-absolute-path

    [[ ${status} -eq 255 ]]
    [[ ${output} = "[error]: to-absolute-path() 'path' not provided" ]]
}

@test "absolute path" {

    run to-absolute-path /something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "/something" ]]
}

@test "relative path, no leading dot" {

    run to-absolute-path something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "$(pwd)/something" ]]
}

@test "relative path, leading dot" {

    run to-absolute-path ./something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "$(pwd)/something" ]]
}

@test "relative path, two leading dots" {

    run to-absolute-path ../something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "$(pwd)/../something" ]]
}

