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

    run get-pipeline-runs test-pipeline

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'JENKINS_BASE_URL' not set in context" ]]
}

@test "name not provided" {

    run get-pipeline-runs

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'name' not provided" ]]
}

@test "get-pipeline" {

    function blue-ocean-rest-get() {
cat <<EOF
{'test':'test'}
EOF
    }

    run get-pipeline-runs test-pipeline

    [[ ${status} -eq 0 ]]
    [[ ${output} = "{'test':'test'}" ]]
}
