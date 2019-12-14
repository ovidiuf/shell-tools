#!/usr/bin/env bash

. ./$(dirname $0)/bash.shlib
#. ./$(dirname $0)/java.shlib

export VERBOSE=true
#check-bash-version

declare -A OPTIONS
OPTIONS["--size"]="integer -s --SIZE"
process-options "$@"

echo "options: ${OPTIONS[@]}"