load bash-library

@test "no URL" {

    run is-http-url

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'url' not provided" ]]
}

@test "HTTP URL" {

    run is-http-url http://example.com

    [[ ${status} -eq 0 ]]
    [[ ${output} = "http://example.com" ]]
}

@test "HTTPS URL" {

    run is-http-url https://example.com

    [[ ${status} -eq 0 ]]
    [[ ${output} = "https://example.com" ]]
}

@test "not a HTTP/HTTPS URL" {

    run is-http-url file:///tmp

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}