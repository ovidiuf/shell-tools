load all-required-libraries

function setup() {
  [[ -d ${BATS_TEST_DIRNAME}/data/tmp ]] || mkdir ${BATS_TEST_DIRNAME}/data/tmp
}

function teardown() {
    rm -rf ${BATS_TEST_DIRNAME}/data/tmp
}

@test "Java version not provided" {

    run select-java-home

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "Java version not provided" ]]
}

@test "Java vendor not provided" {

    run select-java-home 11

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "Java vendor not provided" ]]
}

@test "macOS, invalid MACOS_JAVA_LIBRARY_DIR" {

    function is_macOS() {
      return 0
    }

    MACOS_JAVA_LIBRARY_DIR=/no/such/directory

    run select-java-home 11 Amazon

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "MacOS Java library directory not valid" ]]
    [[ ${output} =~ "/no/such/directory" ]]
}

@test "macOS, non-existent Java vendor, empty java library dir" {

    function is_macOS() {
      return 0
    }

    MACOS_JAVA_LIBRARY_DIR=${BATS_TEST_DIRNAME}/data/tmp

    run select-java-home 11 Adobe

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ 'no Adobe Java found in '${MACOS_JAVA_LIBRARY_DIR} ]]
}

@test "macOS, non-existent Java vendor, non-empty java library dir" {

    function is_macOS() {
      return 0
    }

    MACOS_JAVA_LIBRARY_DIR=${BATS_TEST_DIRNAME}/data/tmp
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_221.jdk || exit 1

    run select-java-home 11 Adobe

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ 'no Adobe Java found in '${MACOS_JAVA_LIBRARY_DIR} ]]
}

@test "macOS, Amazon java, non-empty java library dir" {

    function is_macOS() {
      return 0
    }

    MACOS_JAVA_LIBRARY_DIR=${BATS_TEST_DIRNAME}/data/tmp
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_221.jdk || exit 1

    run select-java-home 11 Amazon

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ 'no Amazon Java found in '${MACOS_JAVA_LIBRARY_DIR} ]]
}

@test "macOS, Amazon java, no such version" {

    function is_macOS() {
      return 0
    }

    MACOS_JAVA_LIBRARY_DIR=${BATS_TEST_DIRNAME}/data/tmp
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_221.jdk || exit 1
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-8.jdk || exit 1

    run select-java-home 11 Amazon

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ 'no Amazon 11 Java found in '${MACOS_JAVA_LIBRARY_DIR} ]]
}

@test "macOS, Amazon java, more than one matching version" {

    function is_macOS() {
      return 0
    }

    MACOS_JAVA_LIBRARY_DIR=${BATS_TEST_DIRNAME}/data/tmp
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_221.jdk || exit 1
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.jdk || exit 1
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.1.jdk || exit 1

    run select-java-home 11 Amazon

    [[ ${status} -eq 1 ]]

    [[ ${output} =~ 'more than one Amazon Java installation matches version 11' ]]
    [[ ${output} =~ ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.jdk/Contents/Home ]]
    [[ ${output} =~ ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.1.jdk/Contents/Home ]]
    [[ ${output} =~ "specify version more precisely" ]]
}

@test "macOS, Amazon java, match found but full path invalid" {

    function is_macOS() {
      return 0
    }

    MACOS_JAVA_LIBRARY_DIR=${BATS_TEST_DIRNAME}/data/tmp
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_221.jdk || exit 1
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-8.jdk || exit 1
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.jdk || exit 1

    run select-java-home 11 Amazon

    [[ ${status} -eq 1 ]]

    [[ ${output} =~ 'selected Amazon 11 Java but JAVA_HOME does not seem to be a valid directory:' ]]
    [[ ${output} =~ ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.jdk/Contents/Home ]]
}

@test "macOS, Amazon java, valid match" {

    function is_macOS() {
      return 0
    }

    MACOS_JAVA_LIBRARY_DIR=${BATS_TEST_DIRNAME}/data/tmp
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_221.jdk || exit 1
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-8.jdk || exit 1
    mkdir -p ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.jdk/Contents/Home || exit 1

    run select-java-home 11 Amazon

    echo ${output}
    [[ ${status} -eq 0 ]]
    [[ ${output} = ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.jdk/Contents/Home ]]
}

@test "macOS, Amazon java, valid match (2)" {

    function is_macOS() {
      return 0
    }

    MACOS_JAVA_LIBRARY_DIR=${BATS_TEST_DIRNAME}/data/tmp
    mkdir ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_221.jdk || exit 1
    mkdir -p ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-8.jdk/Contents/Home || exit 1
    mkdir -p ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.jdk/Contents/Home || exit 1
    mkdir -p ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_271.jdk/Contents/Home || exit 1
    mkdir -p ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_261.jdk/Contents/Home || exit 1
    mkdir -p ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_251.jdk/Contents/Home || exit 1
    mkdir -p ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_241.jdk/Contents/Home || exit 1
    mkdir -p ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_271.jdk/Contents/Home || exit 1
    mkdir -p ${MACOS_JAVA_LIBRARY_DIR}/jdk1.8.0_202.jdk/Contents/Home || exit 1

    run select-java-home 11 Amazon

    echo ${output}
    [[ ${status} -eq 0 ]]
    [[ ${output} = ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.jdk/Contents/Home ]]
}
