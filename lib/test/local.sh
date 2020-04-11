#!/usr/bin/env bash

for i in bash.shlib jenkins.shlib; do [ -f $(dirname $0)/../${i} ] && source $(dirname $0)/../${i} || { echo "[error]: $(dirname $0)/../${i} not found" 1>&2; exit 1; } done

VERBOSE=true
BASE_URL=$(cat ~/tmp/base-url)
AUTH=$(cat ~/tmp/auth)
#get-pipeline-names ${BASE_URL} ${AUTH} simple
#get-pipeline-runs ${BASE_URL} ${AUTH} c3server-k8s
get-multi-branch-pipeline-run ${BASE_URL} ${AUTH} c3server-k8s task/cloud/bg/k8sonly/PLAT-20517 1
