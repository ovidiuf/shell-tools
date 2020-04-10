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

@test "absolute path (2)" {

    run to-absolute-path /something/somethingelse

    [[ ${status} -eq 0 ]]
    [[ ${output} = /something/somethingelse ]]
}

@test "relative path, no leading dot" {

    run to-absolute-path something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "$(pwd -P)/something" ]]
}

@test "relative path, leading dot" {

    run to-absolute-path ./something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "$(pwd -P)/something" ]]
}

@test "relative path, two leading dots" {

    run to-absolute-path ../something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "$(pwd -P)/../something" ]]
}

@test "current directory" {

    run to-absolute-path .

    [[ ${status} -eq 0 ]]
    [[ ${output} = $(pwd -P) ]]
}

@test "intermediary dot " {

    run to-absolute-path a/./b

    [[ ${status} -eq 0 ]]
    [[ ${output} = $(pwd -P)/a/b ]]
}


