load bash-library

#
# get-tmp-dir() tests
#

@test "basic" {

    run get-tmp-dir

    [[ ${status} -eq 0 ]]
    [[ -n ${output} ]]

    tmp_dir=${output}
    [[ -d ${tmp_dir} ]]

    rm -r ${tmp_dir}
}

