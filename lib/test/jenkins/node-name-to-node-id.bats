load all-libraries

@test "'node_name_or_id' not provided" {

    run node-name-to-node-id

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'node_name_or_id' not provided" ]]
}

@test "already node ID" {

    run node-name-to-node-id 75

    [[ ${status} -eq 0 ]]
    [[ ${output} = "75" ]]
}

@test "not node ID, 'pipeline_name' not provided" {

    run node-name-to-node-id test

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'pipeline_name' not provided" ]]
}

@test "not node ID, 'branch' not provided" {

    run node-name-to-node-id test pipeline-A

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'branch' not provided" ]]
}

@test "not node ID, 'run_id' not provided" {

    run node-name-to-node-id test pipeline-A /some/branch

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'run_id' not provided" ]]
}

@test "node name does not exist" {

    function  blue-ocean-rest-get {

        debug "${FUNCNAME[0]}($@)"

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
  }
]
EOF
    }

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run node-name-to-node-id "No Such Node" pipeline-A /some/branch 1

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "node name exists, does not contain spaces" {

    function  blue-ocean-rest-get {
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
  }
]
EOF
    }

    #export VERBOSE=true; export DEBUG_OUTPUT=~/tmp/bats.out
    run node-name-to-node-id some-node pipeline-A /some/branch 1

    [[ ${status} -eq 0 ]]
    [[ ${output} = "40" ]]
}

@test "node name exists, contains spaces" {

    function  blue-ocean-rest-get {
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
  }
]
EOF
    }

    run node-name-to-node-id "Node B" pipeline-A /some/branch 1

    [[ ${status} -eq 0 ]]
    [[ ${output} = "20" ]]
}
