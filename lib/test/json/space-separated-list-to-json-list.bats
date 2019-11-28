load required-libraries

@test "no arguments" {

    run space-separated-list-to-json-list

    [[ ${status} -eq 0 ]]
    [[ ${output} = "[]" ]]
}
