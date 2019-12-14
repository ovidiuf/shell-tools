#!/usr/bin/env bash

[[ -f $(dirname $0)/../bash.shlib ]] && source $(dirname $0)/../bash.shlib || { echo "$(dirname $0)/../bash.shlib not found" 1>&2; exit 1; }

VERBOSE=true
DRY_RUN=true
execute $(dirname $0)/bash/data/execute/target-command false --target-command-dry-run


