#!/usr/bin/env bash

set -euo pipefail

# only supports hub.docker.com for now
registry="${1:-"https://registry.hub.docker.com"}"
# limited to 100 for hub.docker.com
page_size="${2:-100}"

# avoid reading all pages if at least one match is found
quick=1

get_tag_digest() {

    local repo="${1}"
    local tag="${2}"

    local next
    local digest

    next="${registry}/v2/repositories/${repo}/tags/?page=1&page_size=${page_size}"

    while :
    do
        digest=$(curl -fsSL "${next}" | jq -r --arg TAG "${tag}" '.results[] | select(.name==$TAG) | .images[0].digest')
        [ -n "${digest}" ] && break
        
        results="$(curl -fsSL "${next}" | jq '.results | length')"
        [ "${results}" -lt 1 ] && break
        next=$(curl -fsSL "${next}" | jq -r '.next')
        [ "${next}" = "null" ] && break
        sleep 2
    done

    echo "${digest}"
}

get_digest_tags() {
    local repo="${1}"
    local digest="${2}"

    local next
    local results
    local count=0

    next="${registry}/v2/repositories/${repo}/tags/?page=1&page_size=${page_size}"

    while :
    do
        mapfile -t matches < <(curl -fsSL "${next}" | jq -r --arg DIGEST "${digest}" '.results[] | select(.images[].digest==$DIGEST) | .name')

        if [ "${#matches[@]}" -gt 0 ]
        then
            count+=${#matches[@]}
            printf '%s\n' "${matches[@]}"
        else
            [ "${count}" -gt 0 ] && [ -n "${quick}" ] && break
        fi
        
        results="$(curl -fsSL "${next}" | jq '.results | length')"
        [ "${results}" -lt 1 ] && break
        next=$(curl -fsSL "${next}" | jq -r '.next')
        [ "${next}" = "null" ] && break
        sleep 2
    done
}

get_semver_from_alias() {
    local repo="${1}"
    local alias="${2}"
    local digest

    digest="$(get_tag_digest "${repo}" "${alias}")"

    [ -n "${digest}" ] || return

    get_digest_tags "${repo}" "${digest}" | tee /dev/stderr | grep -Eo "^(v)?[0-9]+\.[0-9]+\.[0-9]+.*$" | sort -V | tail -n1
}
