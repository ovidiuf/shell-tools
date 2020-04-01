#!/usr/bin/env bash

[[ -f $(dirname $0)/../bash.shlib ]] && source $(dirname $0)/../bash.shlib || { echo "$(dirname $0)/../bash.shlib not found" 1>&2; exit 1; }


is-yq-2 && echo "is 2" || echo "is NOT 2"