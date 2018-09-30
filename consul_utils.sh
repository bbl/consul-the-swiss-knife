#!/usr/bin/env bash

CONSUL_ADDR="${CONSUL_ADDR:-http://127.0.0.1:8500}"

set -e

function consul_read(){
    consul kv get ${1}
}

function consul_write(){
    consul kv put ${1} ${2}
}

function curl_consul_read(){
    curl -f ${CONSUL_ADDR}/v1/kv/${1}?raw
}

function curl_consul_write(){
    curl -f --request PUT --data ${2} \
        ${CONSUL_ADDR}/v1/kv/${1}
}

function create_session(){
  local session_id=$(curl -s -XPUT "${CONSUL_ADDR}/v1/session/create" \
  -d "{\"Name\": \"backup\"}" | jq -r '.ID' )
  echo ${session_id}
}

function acquire_lock(){
    local session_id=${1}
    echo -n "Trying to acquire a lock for session ${session_id}..."
    res=$(curl -s -f -XPUT "${CONSUL_ADDR}/v1/kv/locks/backup/.lock?acquire=${session_id}")

    if [[ ${res} != "true" ]]; then
        echo "Couldn't acquire lock - exiting now!"
        exit 1
    fi
    echo ${res}
}

function release_lock(){
    echo -n "Releasing lock..."
    local session_id=${1}
    curl -XPUT \
        "${CONSUL_ADDR}/v1/kv/locks/backup/.lock?release=${session_id}"
}