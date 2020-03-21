load bash-library

@test "no URL" {

    run is-s3-url

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'url' not provided" ]]
}

@test "not a S3 URL" {

    run is-s3-url file:///tmp

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "not a S3 URL (2)" {

    run is-s3-url /tmp

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "not a S3 URL (3)" {

    run is-s3-url nfs://a/b

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "not a S3 URL (4)" {

    run is-s3-url ./a.zip

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "S3 URL" {

    #export VERBOSE=true; DEBUG_OUTPUT=~/tmp/bats.out
    run is-s3-url s3://test-bucket

    [[ ${status} -eq 0 ]]
    [[ ${output} = "test-bucket /" ]]
}

@test "S3 URL (2)" {

    run is-s3-url s3://test-bucket/

    [[ ${status} -eq 0 ]]
    [[ ${output} = "test-bucket /" ]]
}

@test "S3 URL (3)" {

    run is-s3-url s3://test-bucket/something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "test-bucket /something" ]]
}

@test "S3 URL (4)" {

    run is-s3-url s3://test-bucket/some/test/path

    [[ ${status} -eq 0 ]]
    [[ ${output} = "test-bucket /some/test/path" ]]
}

