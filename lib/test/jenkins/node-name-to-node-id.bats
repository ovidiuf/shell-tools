load all-libraries

function setup() {

    function  blue-ocean-rest-get {

        debug "${FUNCNAME[0]}($@)"

        local url=$1
        url=${url##*nodes/}

        if [[ -z ${url} ]]; then

        debug "blue-ocean-rest-get() returning a list of nodes"
cat << EOF
[
  {
    "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl",
    "displayName": "Node A",
    "id": "10"
  },
  {
    "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl",
    "displayName": "Node B",
    "id": "20"
  },
  {
    "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl",
    "displayName": "Node C",
    "id": "30"
  },
  {
    "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl",
    "displayName": "some-node",
    "id": "40"
  },
  {
    "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl",
    "displayName": "Node D",
    "id": "40-alpha-numeric"
  },
  {
    "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl",
    "displayName": "Node E",
    "id": "50"
  }
]
EOF
        else
        #
        # individual node
        #
        local node_id="${url}"
        debug "blue-ocean-rest-get() node_id: ${node_id}"

        if [[ ${node_id: -1} != "/" ]]; then
            #
            # We simulate Blue Ocean behavior that requires a slash at the end of the URL to return anything
            #
            return 0
        fi

        node_id=${node_id%/}

        if [[ ${node_id} = "101" || ${node_id} = "101-something" ]]; then
cat << EOF
{
    "_class": "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl",
    "displayName": "Individual Node",
    "id": "${node_id}"
}
EOF

        else
            #
            # Blue Ocean sends a 404 in this case
            #
            echo "this would be a 404"
            return 0
        fi
    fi
  }
}

@test "'node_name_or_id' not provided" {

    run node-name-to-node-id

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'node_name_or_id' not provided" ]]
}

@test "'pipeline_name' not provided" {

    run node-name-to-node-id test

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'pipeline_name' not provided" ]]
}

@test "'branch' not provided" {

    run node-name-to-node-id test pipeline-A

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'branch' not provided" ]]
}

@test "'run_id' not provided" {

    run node-name-to-node-id test pipeline-A /some/branch

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'run_id' not provided" ]]
}

@test "rest call fails" {

    function  blue-ocean-rest-get {
        debug "${FUNCNAME[0]}($@)"
        fail "mock rest call failed"
    }

    run node-name-to-node-id 30 pipeline-A /some/branch 1

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "mock rest call failed" ]]
}

@test "valid node ID, numeric" {

    run node-name-to-node-id 101 test-pipeline test-branch 1

    [[ ${status} -eq 0 ]]
    [[ ${output} = "101" ]]
}

@test "valid node ID, alpha-numeric" {

    run node-name-to-node-id 101-something test-pipeline test-branch 1

    [[ ${status} -eq 0 ]]
    [[ ${output} = "101-something" ]]
}

@test "node name does not exist, does not contain spaces" {

    run node-name-to-node-id "No_Such_Node" test-pipeline test-branch 1

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "node name does not exist, does contain spaces" {

    run node-name-to-node-id "No Such Node" test-pipeline test-branch 1

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "node name does exist, does not contain spaces" {

    run node-name-to-node-id some-node test-pipeline test-branch 1

    [[ ${status} -eq 0 ]]
    [[ ${output} = "40" ]]
}

@test "node name does exist, does contain spaces" {

    run node-name-to-node-id "Node A" test-pipeline test-branch 1

    [[ ${status} -eq 0 ]]
    [[ ${output} = "10" ]]
}


