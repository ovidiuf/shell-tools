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

    run get-multi-branch-pipeline-run test-pipeline test-branch test-id

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'JENKINS_BASE_URL' not set in context" ]]
}

@test "pipeline name not provided" {

    run get-multi-branch-pipeline-run

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'pipeline_name' not provided" ]]
}

@test "branch name not provided" {

    run get-multi-branch-pipeline-run test-pipeline

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'branch_name' not provided" ]]
}

@test "run id not provided" {

    run get-multi-branch-pipeline-run test-pipeline test-branch

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'run_id' not provided" ]]
}

@test "success" {

    function blue-ocean-rest-get() {
cat <<EOF
{'relative-url': $1}
EOF
    }

    run get-multi-branch-pipeline-run test-pipeline test-branch test-id

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ test-branch ]]
}

@test "success, branch name contains slashes" {

    function blue-ocean-rest-get() {
cat <<EOF
{'relative-url': $1}
EOF
    }

    run get-multi-branch-pipeline-run test-pipeline task/feature-1/JIRA-123 test-id

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ task%252Ffeature-1%252FJIRA-123 ]]
}

