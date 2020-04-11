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

@test "success, no type" {

    function blue-ocean-rest-get() {
        debug "blue-ocean-rest-get($@)"
cat << EOF
[{"color": "red"}]
EOF
    }

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run get-pipelines

    [[ ${status} -eq 0 ]]
    output=$(echo ${output} | jq -r '.[] | .color')
    [[ ${output} = "red" ]]
}

@test "invalid type" {

    run get-pipelines no-such-type

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "unknown pipeline type" ]]
    [[ ${output} =~ "no-such-type" ]]
}


