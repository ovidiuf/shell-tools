#!/usr/bin/env bash

load all-libraries

function setup() {

    [[ -d ${BATS_TEST_DIRNAME}/data/tmp ]] || mkdir ${BATS_TEST_DIRNAME}/data/tmp

    function blue-ocean-rest-get() {

        local url=$1
        local start=$2
        local limit=$3

        local s=${url#pipelines/}
        local pipeline_name=${s%%/*}
        s=${s#${pipeline_name}/branches/}
        local branch_name=${s%%/*}
        s=${s#${branch_name}/runs/}
        local run_id=${s%%/*}
        s=${s#${run_id}}

        if [[ ${pipeline_name} != "test-pipeline" ]]; then
cat << EOF
{
  "message" : "Pipeline ${pipeline_name} not found",
  "code" : 404,
  "errors" : [ ]
}
EOF
            return 0
        fi

        if [[ ${branch_name} != "test-branch" ]]; then
cat << EOF
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
<title>Error 404 Not Found</title>
</head>
<body><h2>HTTP ERROR 404</h2>
<p>Problem accessing /cloud/blue/rest/organizations/jenkins/pipelines/${pipeline_name}/branches/${branch_name}/runs/${run_id}${s}. Reason:
<pre>    Not Found</pre></p><hr><a href="http://eclipse.org/jetty">Powered by Jetty:// 9.4.z-SNAPSHOT</a><hr/>

</body>
</html>
EOF
            return 0
        fi

        if [[ ${run_id} != "1" ]]; then
cat << EOF
{
  "message" : "Run ${run_id} not found in organization jenkins and pipeline ${branch_name}",
  "code" : 404,
  "errors" : [ ]
}
EOF
            return 0
        fi

        #
        # pipeline name, branch name and run ID valid
        #
cat << EOF
[
  {
    "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl",
    "displayName": "node 1",
    "id": "1",
    "result": "SUCCESS",
    "startTime": "2020-04-09T22:25:23.640-0700",
    "state": "FINISHED",
    "type": "STAGE"
  },
  {
    "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl",
    "displayName": "node 2",
    "id": "2",
    "result": "SUCCESS",
    "startTime": "2020-04-09T22:38:30.583-0700",
    "state": "FINISHED",
    "type": "STAGE"
  },
  {
    "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl",
    "displayName": "node 3",
    "id": "3",
    "result": "SUCCESS",
    "startTime": "2020-04-09T22:38:30.601-0700",
    "state": "FINISHED",
    "type": "STAGE"
  }
]
EOF
    }
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
    [[ ${output} =~ "unknown branch" ]]
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