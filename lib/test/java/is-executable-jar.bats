load all-required-libraries

function setup() {
  [[ -d ${BATS_TEST_DIRNAME}/data/tmp ]] || mkdir ${BATS_TEST_DIRNAME}/data/tmp
}

function teardown() {
    rm -rf ${BATS_TEST_DIRNAME}/data/tmp
}

@test "no arguments" {

    run is-executable-jar

    [[ ${status} -eq 255 ]]
}

@test "JAR file does not exist" {

    run is-executable-jar /there/is/no/such/jar/file

    [[ ${status} -eq 1 ]]
}

@test "JAR file exists but it does not have a META-INF/MANIFEST.MF" {

    (cd ${BATS_TEST_DIRNAME}/data/tmp; mkdir root; mkdir root/a; touch root/a/b.txt; echo "something" > root/a/b.txt; cd root; jar cfM ../test.jar *) || exit 1

    local jar_file=${BATS_TEST_DIRNAME}/data/tmp/test.jar

    [[ -f ${jar_file} ]]

    run is-executable-jar ${jar_file}

    [[ ${status} -eq 1 ]]
}

@test "JAR file exists but META-INF/MANIFEST.MF does not contain Main-Class" {

    (cd ${BATS_TEST_DIRNAME}/data/tmp; mkdir root; mkdir root/a; touch root/a/b.txt; echo "something" > root/a/b.txt; cd root; jar cf ../test.jar *) || exit 1

    local jar_file=${BATS_TEST_DIRNAME}/data/tmp/test.jar

    [[ -f ${jar_file} ]]

    run is-executable-jar ${jar_file}

    [[ ${status} -eq 1 ]]
}

@test "JAR exists, contains a valid MANIFEST.MF with a Main-Class entry, and the corresponding Main-Class" {

    local tmpdir=${BATS_TEST_DIRNAME}/data/tmp
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

    local jar_file=${BATS_TEST_DIRNAME}/data/tmp/test.jar

    [[ -f ${jar_file} ]]

    run is-executable-jar ${jar_file}

    [[ ${status} -eq 0 ]]
}
