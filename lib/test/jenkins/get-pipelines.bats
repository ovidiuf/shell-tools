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

@test "success" {

    function curl() {
cat << EOF
{'some': 'pipelines'}
EOF
    }

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run get-pipelines

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ "{'some': 'pipelines'}" ]]
}

