load bash-library

@test "file not provided" {

    run yq-path-exists

    [[ ${status} -ne 0 ]]
    [[ -z ${output} ]]
}

@test "path does not exist, yq 2" {

    function yq() {
        echo "null"
        return 0
    }

    run yq-path-exists mock no.such.path

    [[ ${status} -ne 0 ]]
    [[ -z ${output} ]]
}

@test "path does not exist, yq 3" {

    function yq() {
        return 0
    }

    run yq-path-exists mock no.such.path

    [[ ${status} -ne 0 ]]
    [[ -z ${output} ]]
}

@test "path exists but it is empty, yq 2" {

    function yq() {
        echo "null"
        return 0
    }

    run yq-path-exists mock exists.but.empty

    [[ ${status} -ne 0 ]]
    [[ -z ${output} ]]
}

@test "path exists but it is empty, yq 3" {

    function yq() {
        return 0
    }

    run yq-path-exists mock exists.but.empty

    [[ ${status} -ne 0 ]]
    [[ -z ${output} ]]
}

@test "path exists, yq 2" {

    function yq() {
        echo "something"
        return 0
    }

    run yq-path-exists mock exists

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "path exists, yq 3" {

    function yq() {
        echo "something"
        return 0
    }

    run yq-path-exists mock exists

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}


