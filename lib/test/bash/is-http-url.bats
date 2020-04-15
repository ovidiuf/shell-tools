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

@test "not a HTTP/HTTPS URL (2)" {

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run is-http-url "[2018-04-14T09:05:46.376Z]"

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}