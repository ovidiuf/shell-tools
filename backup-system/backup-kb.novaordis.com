#!/bin/bash
#
# cron-drivable script that perfroms a full backup of the wiki instance (database content,
# content files, configuration)
#
# TODO
# o Extract dynamically database host, user, password and name from MediaWiki configuration script.
#

backup_dir=/root/backups
database_host=localhost
database_user=novaordis_wiki
database_password=...
database_name=novaordis_wiki
document_root=/var/www/kb.novaordis.com

function timestamp() {
    date +'%y.%m.%d-%H.%M.%S'
}

function backup-database() {

    local backup_timestamp=$1
    local database_host=$2
    local database_user=$3
    local database_password=$4
    local database_name=$5
    local backup_dir=$6

    [ "${backup_timestamp}" = "" ] && { echo "'backup_timestamp' not specified" 1>&2; exit 1; }
    [ "${database_host}" = "" ] && { echo "'database_host' not specified" 1>&2; exit 1; }
    [ "${database_user}" = "" ] && { echo "'database_user' not specified" 1>&2; exit 1; }
    [ "${database_password}" = "" ] && { echo "'database_password' not specified" 1>&2; exit 1; }
    [ "${database_name}" = "" ] && { echo "'database_name' not specified" 1>&2; exit 1; }
    [ "${backup_dir}" = "" ] && { echo "'backup_dir' not specified" 1>&2; exit 1; }
    [ -d ${backup_dir} ] || { echo "invalid backup directory ${backup_dir}" 1>&2; exit 1; }

    local backup_file=${backup_dir}/novaordis_wiki-database-${backup_timestamp}.sql

    #echo -n "backing up the wiki database as ${backup_file} ... "

    if mysqldump -h ${database_host} -u ${database_user} --password=${database_password} --default-character-set=binary ${database_name} > ${backup_file}; then
         ok=true
        #echo "ok"
    else
        echo "failed to back up the database" 1>&2;
        exit 1
    fi
}

function backup-files() {

    local backup_timestamp=$1
    local document_root=$2
    local backup_dir=$3

    [ "${backup_timestamp}" = "" ] && { echo "'backup_timestamp' not specified" 1>&2; exit 1; }
    [ "${document_root}" = "" ] && { echo "'document_root' not specified" 1>&2; exit 1; }
    [ -d ${document_root} ] || { echo "invalid document root ${document_root}" 1>&2; exit 1; }
    [ "${backup_dir}" = "" ] && { echo "'backup_dir' not specified" 1>&2; exit 1; }
    [ -d ${backup_dir} ] || { echo "invalid backup directory ${backup_dir}" 1>&2; exit 1; }

    local backup_file=${backup_dir}/novaordis_wiki-files-${backup_timestamp}.zip

    #echo -n "backing up the wiki files as ${backup_file} ... "

    if zip -r -q ${backup_file} ${document_root}; then
        #echo "ok"
        ok=true
    else
        echo "failed to back up the document root" 1>&2;
        exit 1
    fi
}

function create-top-level-backup-file() {

    local this_backup_dir=$1

    [ "${this_backup_dir}" = "" ] && { echo "'this_backup_dir' not specified" 1>&2; exit 1; }
    [ -d ${this_backup_dir} ] || { echo "invalid top level backup directory ${this_backup_dir}" 1>&2; exit 1; }

    local parent_dir=$(dirname ${this_backup_dir})
    local dir_name=$(basename ${this_backup_dir})
    local file_name=${dir_name}.zip

    #echo -n "creating top level backup file ${parent_dir}/${file_name} ... "

    if (cd ${parent_dir}; zip -r -q ${file_name} ${dir_name}); then
        #echo "ok"
        ok=true
    else
        echo "failed to create top level backup file" 1>&2;
        exit 1
    fi

    # delete the intermediate directory
    rm -r ${this_backup_dir} || { echo "failed to remove the intermediate directory ${this_backup_dir}" 1>&2; exit 1; }
}

function main() {

    local backup_timestamp=$(timestamp)

    local this_backup_dir=${backup_dir}/wiki.novaordis.com-backup-$(timestamp)
    [ -d ${this_backup_dir} ] && { echo "backup directory ${this_backup_dir} already exists, meaning that another backup started just in the last second. Wait a bit and try again ..." 1>&2; exit 1; }
    mkdir ${this_backup_dir} || { echo "failed to create backup directory ${this_backup_dir}" 1>&2; exit 1; }

    backup-database \
        ${backup_timestamp} \
        ${database_host} \
        ${database_user} \
        ${database_password} \
        ${database_name} \
        ${this_backup_dir}

    backup-files \
        ${backup_timestamp} \
        ${document_root} \
        ${this_backup_dir}

    create-top-level-backup-file ${this_backup_dir}

    send-email "$(hostname -s) wiki backup" "$(hostname) wiki backup done at $(date)"
}

function send-email() {

    local subject=$1
    local body=$2

    local destination_address=ovidiu@novaordis.com

    echo "${body}" | mailx -A gmail -s "${subject}" ${destination_address} 1>&2 2>/dev/null
}

main;

