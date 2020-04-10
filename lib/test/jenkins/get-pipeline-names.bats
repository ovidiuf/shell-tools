load all-libraries

@test "jenkins_base_url not provided" {

    run get-pipeline-names

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'jenkins_base_url' not provided" ]]
}

