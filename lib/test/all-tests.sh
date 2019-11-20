#!/usr/bin/env bash

for d in $(find . -type d -not -name '.' -and -not -name '*data' -and -not -name '*tmp'); do
    (
        d=${d#./}
        echo "running all tests from directory '${d}' ..."
        cd ${d};
        for i in *.bats; do
            echo "running $(basename ${i}) tests ..."
            bats ${i}
        done
    )
done

