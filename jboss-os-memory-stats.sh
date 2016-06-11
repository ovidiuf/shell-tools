#!/bin/bash
#
# This is a script that detects the pid of a JBoss instance running on the host, reads the OS-level memory statistics for the
# corresponding process from /proc/<pid>/status and writes then , on a new line into the os-metrics.csv into the JBoss instance log directory, in this order:
#
# timestamp, pid, VmPeak (in kb), VmSize (in kb), VmLck (in kb), VmHWM (in kb), VmRSS (in kb), VmData (in kb), VmStk (in kb), VmExe (in kb), VmLib (in kb), VmPTE (in kb), VmSwap (in kb), thread count
#
#* VmPeak: Peak virtual memory size.
#* VmSize: Virtual memory size.
#* VmLck: Locked memory size.
#* VmHWM: Peak resident set size ("high water mark").
#* VmRSS: Resident set size.
#* VmData, VmStk, VmExe: Size of data, stack, and text segments.
#* VmLib: Shared library code size.
#* VmPTE: Page table entries size (since Linux 2.6.10).
#* VmSwap:
#* Threads: Number of threads in process containing this thread.
#

function get_jboss_profile_name()
{
    jboss_profile=`uname -n`
    jboss_profile=${jboss_profile%%.*}
    echo "${jboss_profile}"
}

function get_jboss_pid()
{
    jboss_profile=`get_jboss_profile_name` || exit 1
    ps -ef | grep java | grep "\-c ${jboss_profile} " | grep -v grep | awk '{print $2}'
}

function sample()
{
    output_file0=$1
    pid0=$2

    timestamp=`date +'%m/%d/%y %H:%M:%S'`

    fields="VmPeak VmSize VmLck VmHWM VmRSS VmData VmStk VmExe VmLib VmPTE VmSwap Threads"
    declare -A fieldValues

    if [ "${pid0}" != "" ]; then

        status_file=/proc/${pid0}/status

        if [ ! -f ${status_file} ]; then
            echo "no ${status_file} status file found for PID ${pid0}" 1>&2
            exit 1
        fi

        declare -a lines

        readarray < ${status_file} -t lines

        i=0
        while [ ${i} -lt ${#lines[*]} ]; do

            line=${lines[${i}]}
            ((i++))

            for f in ${fields}; do

                s=`echo "${line}" | grep "^${f}:" | sed -e 's/^.*:[ \t]*\([0-9]*\).*/\1/'`

                [ "${s}" != "" ] && fieldValues[${f}]=${s}

            done

        done

        unset lines
    fi

    csv_line="${timestamp},${pid0}"

    for f in ${fields}; do
        csv_line="${csv_line},${fieldValues[${f}]}"
    done

    echo "${csv_line}"  >> ${output_file0}

    unset fieldValues
}

function main()
{
    profile=`get_jboss_profile_name` || exit 10
    pid=`get_jboss_pid` || exit 20
    output_dir="/opt/jboss/jboss-soa-p-5/jboss-as/server/${profile}/log"
    if [ ! -d ${output_dir} ]; then
        echo "output directory ${output_dir} does not exist" 1>&2;
        exit 30
    fi
    output_file="${output_dir}/os-metrics.csv"
    sample "${output_file}" "${pid}"
}



main



