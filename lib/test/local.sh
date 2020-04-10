#!/usr/bin/env bash

for i in bash.shlib jenkins.shlib; do [ -f $(dirname $0)/../${i} ] && source $(dirname $0)/../${i} || { echo "[error]: $(dirname $0)/../${i} not found" 1>&2; exit 1; } done

VERBOSE=true
get-pipelines $(cat ~/tmp/base-url) $(cat ~/tmp/auth)