#!/usr/bin/env bash

. ./$(dirname $0)/bash.shlib
. ./$(dirname $0)/java.shlib

export VERBOSE=true

is-executable-jar $1
