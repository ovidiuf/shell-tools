load bash-library

#
# to-absolute-path() tests
#

@test "argument not provided" {

    run to-canonical-path

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "already canonical" {

    run to-canonical-path /a/b/c

    [[ ${status} -eq 0 ]]
    [[ ${output} = "/a/b/c" ]]
}

@test "remove trailing ." {

    run to-canonical-path /a/b/c/.

    [[ ${status} -eq 0 ]]
    [[ ${output} = "/a/b/c" ]]
}

@test "remove intermediary ." {

    run to-canonical-path /a/./b/./c

    [[ ${status} -eq 0 ]]
    [[ ${output} = "/a/b/c" ]]
}

@test "collapse .." {

    run to-canonical-path /a/b/d/../c

    [[ ${status} -eq 0 ]]
    [[ ${output} = "/a/b/c" ]]
}

@test "collapse multiple .." {

    run to-canonical-path /a/b/d/../e/../c

    [[ ${status} -eq 0 ]]
    [[ ${output} = "/a/b/c" ]]
}

@test "collapse multiple .. (2)" {

    run to-canonical-path /a/b/d/../e/../f/../c

    [[ ${status} -eq 0 ]]
    [[ ${output} = "/a/b/c" ]]
}


