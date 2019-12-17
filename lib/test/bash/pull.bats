load bash-library

function setup() {

    #
    # this function simulates and "overrides" curl. If you want to test with the real curl and a real http://localhost
    # just comment this out
    #
    function curl() {

        #echo "$@" > ~/tmp/curl.out
        local url=$2
        local filename=${url##*/}
        cp ${BATS_TEST_DIRNAME}/data/pull/${filename} . || exit 1
    }
}

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/tmp/*
}



@test "no URL" {

    run pull

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'url' not provided" ]]
}

@test "no target" {

    run pull http://localhost/index.html

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'target' not provided" ]]
}

@test "for the time being, we dont' support anything except http/https" {

    run pull file:///tmp/something ./target

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "NOT YET IMPLEMENTED" ]]
}

@test "target is a directory" {

    target=${BATS_TEST_DIRNAME}/data/tmp
    run pull http://localhost/index.html ${target}

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]

    diff ${target}/index.html ~/runtime/httpd-root/index.html || exit 1
}

@test "target is a file, no directory needs to be created" {

    target=${BATS_TEST_DIRNAME}/data/tmp/test.html

    #VERBOSE=true; DEBUG_OUTPUT=~/tmp/bats.out
    run pull http://localhost/index.html ${target}

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]

    diff ${target} ~/runtime/httpd-root/index.html || exit 1
}

@test "target is a file, directories need to be created" {

    target=${BATS_TEST_DIRNAME}/data/tmp/dir1/dir2/dir3/test.html

    #VERBOSE=true; DEBUG_OUTPUT=~/tmp/bats.out
    run pull http://localhost/index.html ${target}

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]

    diff ${target} ~/runtime/httpd-root/index.html || exit 1
}

