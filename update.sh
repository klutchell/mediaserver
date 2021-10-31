#!/usr/bin/env bash

set -euo pipefail

compose_file="${1:-"docker-compose.yml"}"

yq() {
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}

# shellcheck source=/dev/null
source registry.sh

for image in $(yq eval '.services[].image' "${compose_file}")
do
    service="$(yq eval ".services[].image | select(. == \"${image}\") | path | .[-2]" "${compose_file}")"
    image="${image%%:*}"

    for alias in "latest" "stable"
    do
        echo "Searching for ${image}:${alias}..."
        tag="$(get_semver_from_alias "${image}" "${alias}")" || true
        [ -n "${tag}" ] && break
        echo "Failed to find semver for ${image}:${alias}!"
    done

    if [ -z "${tag}" ]
    then
        continue
    fi

    echo "Saving as ${image}:${tag}..."
    yq eval -i ".services[\"${service}\"].image = \"${image}:${tag}\"" "${compose_file}"
done

docker-compose up -d
