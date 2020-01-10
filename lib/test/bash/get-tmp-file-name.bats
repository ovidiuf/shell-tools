load bash-library

@test "prefix is carried by global variable" {

    TMP_FILE_NAME_PREFIX=something

    run get-tmp-file-name

    [[ ${status} -eq 0 ]]

    name=${output}

    [[ ${name:0:10} = "something-" ]]
}

@test "prefix is overridden by argument" {

    TMP_FILE_NAME_PREFIX=something

    run get-tmp-file-name blah

    [[ ${status} -eq 0 ]]

    name=${output}

    [[ ${name:0:5} = "blah-" ]]
}

@test "no prefix global variable and no argument" {

    unset TMP_FILE_NAME_PREFIX

    run get-tmp-file-name

    [[ ${status} -eq 0 ]]

    name=${output}

    [[ ${name:0:5} = ".tmp-" ]]
}

