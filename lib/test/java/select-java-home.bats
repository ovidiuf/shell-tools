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

    [[ ${status} -eq 0 ]]
    [[ ${output} = ${MACOS_JAVA_LIBRARY_DIR}/amazon-corretto-11.jdk/Contents/Home ]]
}

@test "linux, faulty alternatives" {

    function is_macOS() {
      return 1
    }

    function alternatives() {
       exit 1
    }

    run select-java-home 11 Amazon

    [[ ${status} -eq 2 ]]
    [[ ${output} =~ "alternatives utility failed or it is not available on the system" ]]
}

@test "linux, no javas returned by alternatives" {

    function is_macOS() {
      return 1
    }

    function alternatives() {
cat <<EOF
something
somethingelse
EOF
    }

    run select-java-home 11 Amazon

    [[ ${status} -eq 2 ]]
    [[ ${output} =~ "no Java installations returned by alternatives" ]]
}

function alternatives-oracle-and-corretto-11() {
cat <<EOF
/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java - priority 17000
 slave jjs: (null)
 slave keytool: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/keytool
 slave orbd: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/orbd
 slave pack200: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/pack200
 slave rmid: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/rmid
 slave rmiregistry: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/rmiregistry
 slave servertool: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/servertool
 slave tnameserv: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/tnameserv
 slave unpack200: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/unpack200
 slave jre_exports: /usr/lib/jvm-exports/jre-1.7.0-openjdk.x86_64
 slave jre: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64
 slave java.1: (null)
 slave java.1.gz: /usr/share/man/man1/java-java-1.7.0-openjdk.1.gz
 slave jjs.1: (null)
 slave keytool.1: (null)
 slave keytool.1.gz: /usr/share/man/man1/keytool-java-1.7.0-openjdk.1.gz
 slave orbd.1.gz: /usr/share/man/man1/orbd-java-1.7.0-openjdk.1.gz
 slave pack200.1: (null)
 slave pack200.1.gz: /usr/share/man/man1/pack200-java-1.7.0-openjdk.1.gz
 slave rmid.1: (null)
 slave rmid.1.gz: /usr/share/man/man1/rmid-java-1.7.0-openjdk.1.gz
 slave rmiregistry.1: (null)
 slave rmiregistry.1.gz: /usr/share/man/man1/rmiregistry-java-1.7.0-openjdk.1.gz
 slave servertool.1.gz: /usr/share/man/man1/servertool-java-1.7.0-openjdk.1.gz
 slave tnameserv.1.gz: /usr/share/man/man1/tnameserv-java-1.7.0-openjdk.1.gz
 slave unpack200.1: (null)
 slave unpack200.1.gz: /usr/share/man/man1/unpack200-java-1.7.0-openjdk.1.gz
${BATS_TEST_DIRNAME}/data/tmp/usr/lib/jvm/java-11-amazon-corretto/bin/java - priority 11100010
 slave jjs: /usr/lib/jvm/java-11-amazon-corretto/bin/jjs
 slave keytool: /usr/lib/jvm/java-11-amazon-corretto/bin/keytool
 slave orbd: (null)
 slave pack200: /usr/lib/jvm/java-11-amazon-corretto/bin/pack200
 slave rmid: /usr/lib/jvm/java-11-amazon-corretto/bin/rmid
 slave rmiregistry: /usr/lib/jvm/java-11-amazon-corretto/bin/rmiregistry
 slave servertool: (null)
 slave tnameserv: (null)
 slave unpack200: /usr/lib/jvm/java-11-amazon-corretto/bin/unpack200
 slave jre_exports: (null)
 slave jre: /usr/lib/jvm/java-11-amazon-corretto
 slave java.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/java.1
 slave java.1.gz: (null)
 slave jjs.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/jjs.1
 slave keytool.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/keytool.1
 slave keytool.1.gz: (null)
 slave orbd.1.gz: (null)
 slave pack200.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/pack200.1
 slave pack200.1.gz: (null)
 slave rmid.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/rmid.1
 slave rmid.1.gz: (null)
 slave rmiregistry.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/rmiregistry.1
 slave rmiregistry.1.gz: (null)
 slave servertool.1.gz: (null)
 slave tnameserv.1.gz: (null)
 slave unpack200.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/unpack200.1
 slave unpack200.1.gz: (null)
Current \`best' version is /usr/lib/jvm/java-11-amazon-corretto/bin/java.
EOF
    }

@test "linux, oracle and corretto 11, corretto 11 selected" {

    function is_macOS() {
      return 1
    }

    function alternatives() {
       alternatives-oracle-and-corretto-11
    }

    mkdir -p ${BATS_TEST_DIRNAME}/data/tmp/usr/lib/jvm/java-11-amazon-corretto

    run select-java-home 11 Amazon

    [[ ${status} -eq 0 ]]
    [[ ${output} = ${BATS_TEST_DIRNAME}/data/tmp/usr/lib/jvm/java-11-amazon-corretto ]]
}

@test "linux, oracle and corretto 11, corretto 15 selected" {

    function is_macOS() {
      return 1
    }

    function alternatives() {
       alternatives-oracle-and-corretto-11
    }

    run select-java-home 15 Amazon

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "no Amazon 15 Java found by running the alternatives utility" ]]
}

function alternatives-oracle-corretto-8-and-11() {
cat <<EOF
java - status is manual.
 link currently points to /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/java
/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java - priority 17000
 slave jjs: (null)
 slave keytool: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/keytool
 slave orbd: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/orbd
 slave pack200: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/pack200
 slave policytool: (null)
 slave rmid: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/rmid
 slave rmiregistry: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/rmiregistry
 slave servertool: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/servertool
 slave tnameserv: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/tnameserv
 slave unpack200: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/unpack200
 slave jre_exports: /usr/lib/jvm-exports/jre-1.7.0-openjdk.x86_64
 slave jre: /usr/lib/jvm/jre-1.7.0-openjdk.x86_64
 slave java.1: (null)
 slave java.1.gz: /usr/share/man/man1/java-java-1.7.0-openjdk.1.gz
 slave jjs.1: (null)
 slave keytool.1: (null)
 slave keytool.1.gz: /usr/share/man/man1/keytool-java-1.7.0-openjdk.1.gz
 slave orbd.1: (null)
 slave orbd.1.gz: /usr/share/man/man1/orbd-java-1.7.0-openjdk.1.gz
 slave pack200.1: (null)
 slave pack200.1.gz: /usr/share/man/man1/pack200-java-1.7.0-openjdk.1.gz
 slave policytool.1: (null)
 slave rmid.1: (null)
 slave rmid.1.gz: /usr/share/man/man1/rmid-java-1.7.0-openjdk.1.gz
 slave rmiregistry.1: (null)
 slave rmiregistry.1.gz: /usr/share/man/man1/rmiregistry-java-1.7.0-openjdk.1.gz
 slave servertool.1: (null)
 slave servertool.1.gz: /usr/share/man/man1/servertool-java-1.7.0-openjdk.1.gz
 slave tnameserv.1: (null)
 slave tnameserv.1.gz: /usr/share/man/man1/tnameserv-java-1.7.0-openjdk.1.gz
 slave unpack200.1: (null)
 slave unpack200.1.gz: /usr/share/man/man1/unpack200-java-1.7.0-openjdk.1.gz
${BATS_TEST_DIRNAME}/data/tmp/usr/lib/jvm/java-11-amazon-corretto/bin/java - priority 11100010
 slave jjs: /usr/lib/jvm/java-11-amazon-corretto/bin/jjs
 slave keytool: /usr/lib/jvm/java-11-amazon-corretto/bin/keytool
 slave orbd: (null)
 slave pack200: /usr/lib/jvm/java-11-amazon-corretto/bin/pack200
 slave policytool: (null)
 slave rmid: /usr/lib/jvm/java-11-amazon-corretto/bin/rmid
 slave rmiregistry: /usr/lib/jvm/java-11-amazon-corretto/bin/rmiregistry
 slave servertool: (null)
 slave tnameserv: (null)
 slave unpack200: /usr/lib/jvm/java-11-amazon-corretto/bin/unpack200
 slave jre_exports: (null)
 slave jre: /usr/lib/jvm/java-11-amazon-corretto
 slave java.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/java.1
 slave java.1.gz: (null)
 slave jjs.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/jjs.1
 slave keytool.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/keytool.1
 slave keytool.1.gz: (null)
 slave orbd.1: (null)
 slave orbd.1.gz: (null)
 slave pack200.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/pack200.1
 slave pack200.1.gz: (null)
 slave policytool.1: (null)
 slave rmid.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/rmid.1
 slave rmid.1.gz: (null)
 slave rmiregistry.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/rmiregistry.1
 slave rmiregistry.1.gz: (null)
 slave servertool.1: (null)
 slave servertool.1.gz: (null)
 slave tnameserv.1: (null)
 slave tnameserv.1.gz: (null)
 slave unpack200.1: /usr/lib/jvm/java-11-amazon-corretto/man/man1/unpack200.1
 slave unpack200.1.gz: (null)
${BATS_TEST_DIRNAME}/data/tmp/usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/java - priority 10800282
 slave jjs: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/jjs
 slave keytool: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/keytool
 slave orbd: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/orbd
 slave pack200: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/pack200
 slave policytool: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/policytool
 slave rmid: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/rmid
 slave rmiregistry: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/rmiregistry
 slave servertool: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/servertool
 slave tnameserv: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/tnameserv
 slave unpack200: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/bin/unpack200
 slave jre_exports: (null)
 slave jre: /usr/lib/jvm/java-1.8.0-amazon-corretto/jre
 slave java.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/java.1
 slave java.1.gz: (null)
 slave jjs.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/jjs.1
 slave keytool.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/keytool.1
 slave keytool.1.gz: (null)
 slave orbd.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/orbd.1
 slave orbd.1.gz: (null)
 slave pack200.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/pack200.1
 slave pack200.1.gz: (null)
 slave policytool.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/policytool.1
 slave rmid.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/rmid.1
 slave rmid.1.gz: (null)
 slave rmiregistry.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/rmiregistry.1
 slave rmiregistry.1.gz: (null)
 slave servertool.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/servertool.1
 slave servertool.1.gz: (null)
 slave tnameserv.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/tnameserv.1
 slave tnameserv.1.gz: (null)
 slave unpack200.1: /usr/lib/jvm/java-1.8.0-amazon-corretto/man/man1/unpack200.1
 slave unpack200.1.gz: (null)
Current \`best' version is /usr/lib/jvm/java-11-amazon-corretto/bin/java.
EOF
}

@test "linux, oracle, corretto 8 and corretto 11, corretto 8 selected" {

    function is_macOS() {
      return 1
    }

    function alternatives() {
       alternatives-oracle-corretto-8-and-11
    }

    mkdir -p ${BATS_TEST_DIRNAME}/data/tmp/usr/lib/jvm/java-1.8.0-amazon-corretto/jre

    run select-java-home 1.8 Amazon

    [[ ${status} -eq 0 ]]
    [[ ${output} = ${BATS_TEST_DIRNAME}/data/tmp/usr/lib/jvm/java-1.8.0-amazon-corretto/jre ]]
}

@test "linux, oracle, corretto 8 and corretto 11, corretto 11 selected" {

    function is_macOS() {
      return 1
    }

    function alternatives() {
       alternatives-oracle-corretto-8-and-11
    }

    mkdir -p ${BATS_TEST_DIRNAME}/data/tmp/usr/lib/jvm/java-11-amazon-corretto

    run select-java-home 11 Amazon

    [[ ${status} -eq 0 ]]
    [[ ${output} = ${BATS_TEST_DIRNAME}/data/tmp/usr/lib/jvm/java-11-amazon-corretto ]]
}

@test "linux, oracle, corretto 8 and corretto 11, corretto 15 selected" {

    function is_macOS() {
      return 1
    }

    function alternatives() {
       alternatives-oracle-corretto-8-and-11
    }

    run select-java-home 15 Amazon

    [[ ${status} -eq 1 ]]
    [[ ${output} =~ "no Amazon 15 Java found by running the alternatives utility" ]]
}
