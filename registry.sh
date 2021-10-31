#!/usr/bin/env bash

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
        digest=$(curl -fsSL "${next}" | jq -r --arg TAG "${tag}" '.results[] | select(.name==$TAG) | .images[0].digest') || return
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
    local matches=()

    next="${registry}/v2/repositories/${repo}/tags/?page=1&page_size=${page_size}"

    while :
    do
        mapfile -t tmparr < <(curl -fsSL "${next}" | jq -r --arg DIGEST "${digest}" '.results[] | select(.images[].digest==$DIGEST) | .name') || return

        if [ "${#tmparr[@]}" -lt 1 ]
        then
            [ ${#matches[@]} -gt 0 ] && [ -n "${quick}" ] && break
        else
            matches=("${matches[@]}" "${tmparr[@]}")
        fi
        
        results="$(curl -fsSL "${next}" | jq '.results | length')"
        [ "${results}" -lt 1 ] && break
        next=$(curl -fsSL "${next}" | jq -r '.next')
        [ "${next}" = "null" ] && break
        sleep 2
    done

    printf '%s\n' "${matches[@]}" | jq -R --slurp 'split("\n")[:-1]'
}

get_semver_from_alias() {
    local repo="${1}"
    local alias="${2}"
    local digest
    local regex

    case "${repo}" in 
        linuxserver/*) regex="^(v)?[0-9]+\.[0-9]+(\.[0-9]+)?.*ls[0-9]+$" ;;
        *) regex="^(v)?[0-9]+\.[0-9]+\.[0-9]+.*$" ;;
    esac

    digest="$(get_tag_digest "${repo}" "${alias}")"

    [ -n "${digest}" ] || return

    get_digest_tags "${repo}" "${digest}" | tee /dev/stderr | \
        jq -r --arg REGEX "${regex}" '.[] | select(. | test($REGEX)) | @sh' | \
        tr -d "'" | sort -V | tail -n1 || true   
}
