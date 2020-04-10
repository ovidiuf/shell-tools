load all-libraries

@test "pipeline-type not provided" {

    run pipeline-type-to-class

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'type' not provided" ]]
}

@test "unknown" {

    run pipeline-type-to-class no-such-type

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "simple" {

    run pipeline-type-to-class simple

    [[ ${status} -eq 0 ]]
    [[ ${output} = "io.jenkins.blueocean.rest.impl.pipeline.PipelineImpl" ]]
}

@test "folder" {

    run pipeline-type-to-class folder

    [[ ${status} -eq 0 ]]
    [[ ${output} = "io.jenkins.blueocean.service.embedded.rest.PipelineFolderImpl" ]]
}

@test "multi-branch" {

    run pipeline-type-to-class multi-branch

    [[ ${status} -eq 0 ]]
    [[ ${output} = "io.jenkins.blueocean.rest.impl.pipeline.MultiBranchPipelineImpl" ]]
}
