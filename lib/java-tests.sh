#!/usr/bin/env bash

[[ -f $(dirname $0)/bash.shlib ]] && . $(dirname $0)/bash.shlib || { echo "$(dirname $0)/bash.shlib does not exist" 1>&2; exit 1; }

[[ -f $(dirname $0)/$(basename $0 -tests.sh).shlib ]] && . $(dirname $0)/$(basename $0 -tests.sh).shlib || { echo "$(dirname $0)/$(basename $0 -tests.sh).shlib does not exist" 1>&2; exit 1; }

#
# Return the JAR path at stdout
#
function build-test-jar() {

    echo "blah"
}

#
# no JAR file name provided
#
function is-executable-jar-test-01() {

    echo -n "${FUNCNAME[0]} ... "

    local stderr
    stderr=$(is-executable-jar 2>&1)

    [[ $? = 255 ]] || fail "is-executable-jar() did not fail with 255"

    echo "ok"
}

#
# JAR file does not exist
#
function is-executable-jar-test-02() {

    echo -n "${FUNCNAME[0]} ... "

    is-executable-jar /there/is/no/such/jar/file 2>/dev/null && fail "is-executable-jar() should have returned non-zero"

    echo "ok"
}

#
# JAR file exists but it does not have a META-INF/MANIFEST.MF
#
function is-executable-jar-test-03() {

    echo -n "${FUNCNAME[0]} ... "

    local tmpdir=$(get-tmp-dir) || exit 1

    # M prevents jar from creating a manifest file
    (cd ${tmpdir}; mkdir root; mkdir root/a; touch root/a/b.txt; echo "something" > root/a/b.txt; cd root; jar cfM ../test.jar *) || exit 1

    local jar_file=${tmpdir}/test.jar

    [[ -f ${jar_file} ]] || fail "JAR file ${jar_file} not found"

    debug "created test JAR file ${jar_file}"

    is-executable-jar ${jar_file} && fail "is-executable-jar() should have returned non-zero because META-INF/MANIFEST.MF is missing"

    #
    # cleanup
    #
    rm -r ${tmpdir}

    echo "ok"
}

#
# META-INF/MANIFEST.MF does not contain Main-Class:
#
function is-executable-jar-test-04() {

    echo -n "${FUNCNAME[0]} ... "

    local tmpdir=$(get-tmp-dir) || exit 1

    # jar will create a MANIFEST.MF by default
    (cd ${tmpdir}; mkdir root; mkdir root/a; touch root/a/b.txt; echo "something" > root/a/b.txt; cd root; jar cf ../test.jar *) || exit 1

    local jar_file=${tmpdir}/test.jar

    [[ -f ${jar_file} ]] || fail "JAR file ${jar_file} not found"

    debug "created test JAR file ${jar_file}"

    is-executable-jar ${jar_file} && fail "is-executable-jar() should have returned non-zero because META-INF/MANIFEST.MF is missing"

    #
    # cleanup
    #
    rm -r ${tmpdir}

    echo "ok"
}

#
# return 0 is the JAR exists, contains a valid MANIFEST.MF with a Main-Class: entry, and the corresponding Main-Class
# exits in the JAR
#
function is-executable-jar-test-05() {

    echo -n "${FUNCNAME[0]} ... "

    local tmpdir=$(get-tmp-dir) || exit 1

    mkdir ${tmpdir}/root
    mkdir ${tmpdir}/root/a
    touch ${tmpdir}/root/a/b.txt
    echo "something" > ${tmpdir}/root/a/b.txt

(cat << EOF
Manifest-Version: 1.0
Start-Class: playground.springboot.SbexampleApplication
Main-Class: org.springframework.boot.loader.JarLauncher
EOF
) > ${tmpdir}/manifest.txt

    (cd ${tmpdir}/root; jar cfm ../test.jar ../manifest.txt *) || exit 1

    local jar_file=${tmpdir}/test.jar

    [[ -f ${jar_file} ]] || fail "JAR file ${jar_file} not found"

    debug "created test JAR file ${jar_file}"

    is-executable-jar ${jar_file} || fail "is-executable-jar() should have returned a zero exit code"

    #
    # cleanup
    #
    rm -r ${tmpdir}

    echo "ok"
}

function main() {

    echo $0:

    is-executable-jar-test-01 || exit 1
    is-executable-jar-test-02 || exit 1
    is-executable-jar-test-03 || exit 1
    is-executable-jar-test-04 || exit 1
    is-executable-jar-test-05 || exit 1
}

#export VERBOSE=true

main "$@"



