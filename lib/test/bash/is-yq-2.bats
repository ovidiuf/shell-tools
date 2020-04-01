load bash-library

@test "version 2" {

    function yq() {
        echo "yq version 2.4.1"
    }

    run is-yq-2

    [[ ${status} -eq 0 ]]
    [[ -z ${output} ]]
}

@test "version 3" {

    function yq() {
        echo "yq version 3.2.1"
    }

    run is-yq-2

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

