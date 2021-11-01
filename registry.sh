#!/usr/bin/env bash

# only supports hub.docker.com for now
registry="${1:-"https://registry.hub.docker.com"}"
# limited to 100 for hub.docker.com
page_size="${2:-100}"

# avoid reading all pages if at least one match is found
quick=1

# returns a json array of all the images associated with the provided tag
get_manifest_images() {

    local repo="${1}"
    local tag="${2}"

    local next
    local images

    next="${registry}/v2/repositories/${repo}/tags/?page=1&page_size=${page_size}"

    while :
    do
        images="$(curl -fsSL "${next}" | jq -r --arg TAG "${tag}" '.results[] | select(.name==$TAG) | .images | sort_by(.digest)')" || { printf "" ; return ; }

        [ -n "${images}" ] && break
        
        results="$(curl -fsSL "${next}" | jq -r '.results | length')"
        [ "${results}" -lt 1 ] && break
        next=$(curl -fsSL "${next}" | jq -r '.next')
        [ "${next}" = "null" ] && break
        sleep 1
    done

    echo "${images}"
}

# returns a list of all identical manifests of the given tag
get_aliases() {
    local repo="${1}"
    local tag="${2:-"latest"}"
    local regexp="${3:-".*"}"

    local next
    local results
    local images
    local matches=()

    images="$(get_manifest_images "${repo}" "${tag}")"

    [ -n "${images}" ] || { printf "" ; return ; }

    next="${registry}/v2/repositories/${repo}/tags/?page=1&page_size=${page_size}"

    while :
    do
        mapfile -t tmparr < <(curl -fsSL "${next}" | jq -r --arg REGEXP "${regexp}" --argjson IMAGES "${images}" '.results[] | 
            select(.images | sort_by(.digest)==$IMAGES) | select(.name | test($REGEXP)) | .name') || { printf "" ; return ; }

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
        sleep 1
    done

    printf '%s\n' "${matches[@]}"
}
