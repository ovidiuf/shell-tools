#!/usr/bin/env bash

load all-libraries

function setup() {

    [[ -d ${BATS_TEST_DIRNAME}/data/tmp ]] || mkdir ${BATS_TEST_DIRNAME}/data/tmp

    export JENKINS_BASE_URL=https://test.com/test-instance/blue/rest/organizations/jenkins
    export JENKINS_BASE64_AUTH=$(echo -n "testuser:testpasswd" | base64)
}

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/tmp/*
}

@test "'JENKINS_BASE_URL' not set in context" {

    unset JENKINS_BASE_URL

    #export VERBOSE=true; export TRACE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run get-pipeline-names

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "'JENKINS_BASE_URL' not set in context" ]]
}

@test "invalid pipeline type" {

    run get-pipeline-names no-such-type

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "unknown pipeline type" ]]
    [[ ${output} =~ "no-such-type" ]]
}

@test "all pipeline types" {

    function get-pipelines() {
    cat << EOF
[
    {
        "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineImpl",
        "name": "simple-pipeline-A"
    },
    {
        "_class": "io.jenkins.blueocean.service.embedded.rest.PipelineFolderImpl",
        "name": "folder-pipeline-B"
    },
    {
        "_class": "io.jenkins.blueocean.rest.impl.pipeline.MultiBranchPipelineImpl",
        "name": "multi-branch-pipeline-C"
    }
]
EOF
    }

    run get-pipeline-names

    [[ ${status} -eq 0 ]]
    [[ ${output} = "simple-pipeline-A folder-pipeline-B multi-branch-pipeline-C" ]]
}

@test "only simple pipelines" {

    function get-pipelines() {
    cat << EOF
[
    {
        "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineImpl",
        "name": "simple-pipeline-A"
    },
    {
        "_class": "io.jenkins.blueocean.service.embedded.rest.PipelineFolderImpl",
        "name": "folder-pipeline-B"
    },
    {
        "_class": "io.jenkins.blueocean.rest.impl.pipeline.MultiBranchPipelineImpl",
        "name": "multi-branch-pipeline-C"
    }
]
EOF
    }

    run get-pipeline-names simple

    [[ ${status} -eq 0 ]]
    [[ ${output} = "simple-pipeline-A" ]]
}

@test "only folder pipelines" {

    function get-pipelines() {
    cat << EOF
[
    {
        "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineImpl",
        "name": "simple-pipeline-A"
    },
    {
        "_class": "io.jenkins.blueocean.service.embedded.rest.PipelineFolderImpl",
        "name": "folder-pipeline-B"
    },
    {
        "_class": "io.jenkins.blueocean.rest.impl.pipeline.MultiBranchPipelineImpl",
        "name": "multi-branch-pipeline-C"
    }
]
EOF
    }

    run get-pipeline-names folder

    [[ ${status} -eq 0 ]]
    [[ ${output} = "folder-pipeline-B" ]]
}

@test "only multi-branch pipelines" {

    function get-pipelines() {
    cat << EOF
[
    {
        "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineImpl",
        "name": "simple-pipeline-A"
    },
    {
        "_class": "io.jenkins.blueocean.service.embedded.rest.PipelineFolderImpl",
        "name": "folder-pipeline-B"
    },
    {
        "_class": "io.jenkins.blueocean.rest.impl.pipeline.MultiBranchPipelineImpl",
        "name": "multi-branch-pipeline-C"
    }
]
EOF
    }

    run get-pipeline-names multi-branch

    [[ ${status} -eq 0 ]]
    [[ ${output} = "multi-branch-pipeline-C" ]]
}
