#!/usr/bin/env bash

[[ -f $(dirname $0)/../bash.shlib ]] && source $(dirname $0)/../bash.shlib || { echo "$(dirname $0)/../bash.shlib not found" 1>&2; exit 1; }

VERBOSE=true
#DRY_RUN=true


if s=$(input string "please provide a secret"); then
    #
    # success
    #
    echo "success: ${s}"
else
    #
    # input failure, an error message was already sent to stderr
    #
    echo "failure: ${s}"
fi




