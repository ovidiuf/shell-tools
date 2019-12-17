load bash-library

@test "no URL" {

    run is-nfs-url

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "'url' not provided" ]]
}

@test "not a NFS URL" {

    run is-nfs-url file:///tmp

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "not a NFS URL (2)" {

    run is-nfs-url /tmp

    [[ ${status} -eq 1 ]]
    [[ -z ${output} ]]
}

@test "invalid NFS URL" {

    run is-nfs-url nfs://something

    [[ ${status} -eq 255 ]]
    [[ ${output} =~ "invalid NFS URL, not in host/path format" ]]
    [[ ${output} =~ "nfs://something" ]]
}

@test "NFS URL" {

    run is-nfs-url nfs://1.2.3.4/something

    [[ ${status} -eq 0 ]]
    [[ ${output} = "1.2.3.4 /something" ]]
}

@test "NFS URL (2)" {

    run is-nfs-url nfs://1.2.3.4/something/somethingelse

    [[ ${status} -eq 0 ]]
    [[ ${output} = "1.2.3.4 /something/somethingelse" ]]
}
