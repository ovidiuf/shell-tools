load bash-library

@test "'parent_dir' not provided" {

    run get-the-only-subdir

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'parent_dir' not provided" ]]
}

@test "parent dir does not exist" {

    run get-the-only-subdir /no/such/dir

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "parent dir exists but contains no subdirectory" {

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run get-the-only-subdir ${BATS_TEST_DIRNAME}/data/get-the-only-subdir/dir1

    [[ ${status} -eq 2 ]]
    [[ -z ${output} ]]
}

@test "one subdirectory" {

    run get-the-only-subdir ${BATS_TEST_DIRNAME}/data/get-the-only-subdir/dir2

    [[ ${status} -eq 0 ]]
    [[ ${output} = "subdir1" ]]
}

@test "one subdirectory, deep structure" {

    run get-the-only-subdir ${BATS_TEST_DIRNAME}/data/get-the-only-subdir/dir4

    [[ ${status} -eq 0 ]]
    [[ ${output} = "subdir1" ]]
}

@test "two subdirectories" {

    export VERBOSE=true; export TRACE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run get-the-only-subdir ${BATS_TEST_DIRNAME}/data/get-the-only-subdir/dir3

    [[ ${status} -eq 3 ]]
    [[ -z ${output} ]]
}

