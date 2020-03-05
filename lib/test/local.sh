#!/usr/bin/env bash

[[ -f $(dirname $0)/../bash.shlib ]] && source $(dirname $0)/../bash.shlib || { echo "$(dirname $0)/../bash.shlib not found" 1>&2; exit 1; }

VERBOSE=true
#DRY_RUN=true


declare -a VALUES
VALUES=("A" "B" "C")

index=$(index-of VALUES "B")
echo ${index}


