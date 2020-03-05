load bash-library

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/tmp/*
}

@test "array name not provided" {

    run index-of

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "array name not provided" ]]
}

@test "array is not declared" {

    run index-of NO_SUCH_ARRAY

    [[ ${status} -eq 2 ]]
    [[ -z ${output} ]]
}

@test "value not provided" {

    declare -a VALUES

    run index-of VALUES

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "value not provided" ]]
}

@test "value found on first position" {

    declare -a VALUES
    VALUES=("A" "B" "C")

    run index-of VALUES A

    [[ ${status} -eq 0 ]]
    [[ ${output} = "0" ]]
}

@test "value found on last position" {

    declare -a VALUES
    VALUES=("A" "B" "C")

    run index-of VALUES C

    [[ ${status} -eq 0 ]]
    [[ ${output} = "2" ]]
}

@test "duplicate value, the index of first encountered value returned" {

    declare -a VALUES
    VALUES=("A" "B" "B" "C")

    run index-of VALUES B

    [[ ${status} -eq 0 ]]
    [[ ${output} = "1" ]]
}

@test "value not found" {

    declare -a VALUES
    VALUES=("A" "B" "C")

    run index-of VALUES D

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "empty array" {

    declare -a VALUES

    run index-of VALUES "does not matter"

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}


