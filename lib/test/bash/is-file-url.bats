load bash-library

@test "no URL" {

    run is-file-url

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'url' not provided" ]]
}

@test "relative path" {

    run is-file-url ./tmp

    [[ ${status} -eq 0 ]]
    [[ ${output} = "./tmp" ]]
}

@test "absolute path" {

    run is-file-url /tmp

    [[ ${status} -eq 0 ]]
    [[ ${output} = "/tmp" ]]
}

@test "relative file:// path" {

    run is-file-url file://tmp

    [[ ${status} -eq 0 ]]
    [[ ${output} = "tmp" ]]
}

@test "absolute file:// path" {

    run is-file-url file:///tmp

    [[ ${status} -eq 0 ]]
    [[ ${output} = "/tmp" ]]
}

@test "not a file URL" {

    run is-file-url http://tmp

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}
