#!/usr/bin/env bash

load all-libraries

function setup() {

    [[ -d ${BATS_TEST_DIRNAME}/data/tmp ]] || mkdir ${BATS_TEST_DIRNAME}/data/tmp

    JENKINS_BASE_URL=https://test.com/test-instance/blue/rest/organizations/jenkins
    JENKINS_BASE64_AUTH=$(echo -n "testuser:testpasswd" | base64)

    mkdir ${BATS_TEST_DIRNAME}/data/tmp/jenkins-tmp-dir
    JENKINS_TMP_DIR=${BATS_TEST_DIRNAME}/data/tmp/jenkins-tmp-dir

    #
    # curl function that produces controlled test data
    #
    source ${BATS_TEST_DIRNAME}/mock-curl-function.shlib
}

function teardown() {

    rm -rf ${BATS_TEST_DIRNAME}/data/tmp/*
}

@test "'pipeline_name' not provided" {

    run get-nodes

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'pipeline_name' not provided" ]]
}

@test "'branch' not provided" {

    run get-nodes test-pipeline

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'branch' not provided" ]]
}

@test "'run_id' not provided" {

    run get-nodes test-pipeline test-branch

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'run_id' not provided" ]]
}

@test "no such pipeline" {

    run get-nodes no-such-pipeline test-branch 0

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "Pipeline no-such-pipeline not found" ]]
}

@test "unknown branch" {

    run get-nodes test-pipeline no-such-branch 0

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "one of the resources specified in the URL does not exist" ]]
    [[ ${output} =~ "no-such-branch" ]]
}

@test "unknown run ID" {

    run get-nodes test-pipeline test-branch 0

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "Run 0 not found in organization jenkins and pipeline test-branch" ]]
}

@test "valid response" {

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run get-nodes test-pipeline test-branch 1

    [[ ${status} -eq 0 ]]
    [[ $(echo ${output} | jq -r 'select(.id=="1") | .displayName') = "node 1" ]]
    [[ $(echo ${output} | jq -r 'select(.id=="2") | .displayName') = "node 2" ]]
    [[ $(echo ${output} | jq -r 'select(.id=="3") | .displayName') = "node 3" ]]
}