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

@test "JENKINS_BASE_URL not set in context" {

    unset JENKINS_BASE_URL

    run blue-ocean-rest-get

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'JENKINS_BASE_URL' not set in context" ]]
}

@test "JENKINS_BASE64_AUTH not set in context" {

    unset JENKINS_BASE64_AUTH

    run blue-ocean-rest-get

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'JENKINS_BASE64_AUTH' not set in context" ]]
}

@test "JENKINS_TMP_DIR not set in context" {

    unset JENKINS_TMP_DIR

    run blue-ocean-rest-get

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'JENKINS_TMP_DIR' not set in context" ]]
}

@test "JENKINS_TMP_DIR set in context but does not point to a valid directory" {

    JENKINS_TMP_DIR=/no/such/directory

    run blue-ocean-rest-get

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "JENKINS_TMP_DIR does not exist" ]]
    [[ ${output} =~ "/no/such/directory" ]]
}

@test "relative_url not provided" {

    run blue-ocean-rest-get

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'relative_url' not provided" ]]
}

@test "successful invocation" {

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run blue-ocean-rest-get pipelines/test-pipeline/branches/test-branch/runs/1/nodes/

    [[ ${status} -eq 0 ]]
    [[ $(echo ${output} | jq -r '.[] | select(.id=="1") | .displayName') = "node 1" ]]
}

@test "successful invocation with limits" {

    [[ ! -f ${BATS_TEST_DIRNAME}/data/tmp/curl-args ]]

    run blue-ocean-rest-get pipelines/test-pipeline/branches/test-branch/runs/1/nodes/ 15 231

    [[ ${status} -eq 0 ]]
    [[ $(echo ${output} | jq -r '.[] | select(.id=="1") | .displayName') = "node 1" ]]

    [[ -f ${BATS_TEST_DIRNAME}/data/tmp/curl-args ]]
    IFS=" "
    set - $(cat ${BATS_TEST_DIRNAME}/data/tmp/curl-args)
    [[ $1 = "-s" ]]
    [[ $2 = "-H" ]]
    [[ $3 = "Authorization:" ]]
    [[ $4 = "Basic" ]]
    [[ $5 = "${JENKINS_BASE64_AUTH}" ]]
    [[ $6 = "${JENKINS_BASE_URL}/pipelines/test-pipeline/branches/test-branch/runs/1/nodes/?start=15&limit=231" ]]
}

@test "no such pipeline" {

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run blue-ocean-rest-get pipelines/no-such-pipeline/branches/test-branch/runs/1/nodes/

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "Pipeline no-such-pipeline not found" ]]
}

@test "no such branch" {

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run blue-ocean-rest-get pipelines/test-pipeline/branches/no-such-branch/runs/1/nodes/

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "one of the resources specified in the URL does not exist" ]]
    [[ ${output} =~ "pipelines/test-pipeline/branches/no-such-branch/runs/1/nodes/" ]]
}

@test "no such run ID" {

    run blue-ocean-rest-get pipelines/test-pipeline/branches/test-branch/runs/0/nodes/

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "Run 0 not found in organization jenkins and pipeline test-branch" ]]
}

@test "valid response" {

    run blue-ocean-rest-get pipelines/test-pipeline/branches/test-branch/runs/1/nodes/

    [[ ${status} -eq 0 ]]
    [[ $(echo ${output} | jq -r '.[] | select(.id=="1") | .displayName') = "node 1" ]]
    [[ $(echo ${output} | jq -r '.[] | select(.id=="2") | .displayName') = "node 2" ]]
    [[ $(echo ${output} | jq -r '.[] | select(.id=="3") | .displayName') = "node 3" ]]
}

