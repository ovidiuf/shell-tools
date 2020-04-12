#!/usr/bin/env bash

for i in bash.shlib jenkins.shlib; do [ -f $(dirname $0)/../${i} ] && source $(dirname $0)/../${i} || { echo "[error]: $(dirname $0)/../${i} not found" 1>&2; exit 1; } done

#VERBOSE=true
set-global-variables ${JENKINS_HOST_URL} ${JENKINS_USERNAME} ${JENKINS_PASSWORD} ${JENKINS_INSTANCE_NAME}
get-nodes c3server-k8s epic/cloud/team/k8sonly/develop 33
