#!/usr/bin/env bash

set -e

source '../consul_utils.sh'

function perform_backup(){
    echo -n "Copying some stuff on S3.."
    echo "Done!"
}

session_id=$(create_session)
trap "release_lock ${session_id}" EXIT
acquire_lock ${session_id}

perform_backup
