#!/usr/bin/env bash

load all-libraries

function setup() {

    [[ -d ${BATS_TEST_DIRNAME}/data/tmp ]] || mkdir ${BATS_TEST_DIRNAME}/data/tmp

    JENKINS_BASE_URL=https://test.com/test-instance/blue/rest/organizations/jenkins
    JENKINS_BASE64_AUTH=$(echo -n "testuser:testpasswd" | base64)
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

@test "relative_url not provided" {

    run blue-ocean-rest-get

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'relative_url' not provided" ]]
}

@test "successful invocation" {

    function curl() {
        echo "$@" > ${BATS_TEST_DIRNAME}/data/tmp/curl-args
cat << EOF
{'test': 'test'}
EOF
    }

    [[ ! -f ${BATS_TEST_DIRNAME}/data/tmp/curl-args ]]

    run blue-ocean-rest-get something/

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ "{'test': 'test'}" ]]

    [[ -f ${BATS_TEST_DIRNAME}/data/tmp/curl-args ]]

    IFS=" "
    set - $(cat ${BATS_TEST_DIRNAME}/data/tmp/curl-args)
    [[ $1 = "-s" ]]
    [[ $2 = "-H" ]]
    [[ $3 = "Authorization:" ]]
    [[ $4 = "Basic" ]]
    [[ $5 = "${JENKINS_BASE64_AUTH}" ]]
    [[ $6 = "${JENKINS_BASE_URL}/something/" ]]
}

@test "successful invocation with limits" {

    function curl() {
        echo "$@" > ${BATS_TEST_DIRNAME}/data/tmp/curl-args
cat << EOF
{'test': 'test'}
EOF
    }

    [[ ! -f ${BATS_TEST_DIRNAME}/data/tmp/curl-args ]]

    run blue-ocean-rest-get something/ 15 231

    [[ ${status} -eq 0 ]]
    [[ ${output} =~ "{'test': 'test'}" ]]

    [[ -f ${BATS_TEST_DIRNAME}/data/tmp/curl-args ]]

    IFS=" "
    set - $(cat ${BATS_TEST_DIRNAME}/data/tmp/curl-args)
    [[ $1 = "-s" ]]
    [[ $2 = "-H" ]]
    [[ $3 = "Authorization:" ]]
    [[ $4 = "Basic" ]]
    [[ $5 = "${JENKINS_BASE64_AUTH}" ]]
    [[ $6 = "${JENKINS_BASE_URL}/something/?start=15&limit=231" ]]
}

