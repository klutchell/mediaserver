#!/usr/bin/env bash

set -euo pipefail

compose_file="${1:-"docker-compose.yml"}"

yq() {
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}

# shellcheck source=/dev/null
source registry.sh

menu()
{
    select option in "$@"
    do 
        echo $option
        break
    done
}

for image in $(yq eval '.services[].image' "${compose_file}")
do
    service="$(yq eval ".services[].image | select(. == \"${image}\") | path | .[-2]" "${compose_file}")"
    image="${image%%:*}"

    for alias in "latest" "stable" "develop"
    do
        tag=
        echo "Searching for aliases of ${image}:${alias}..."
        mapfile -t aliases < <(get_aliases "${image}" "${alias}" | sort -V) || true

        [ "${#aliases[@]}" -lt 2 ] && continue

        tag="$(menu "${aliases[@]}")"

        [ -n "${tag}" ] && break
    done

    [ -n "${tag}" ] || continue

    echo "Saving as ${image}:${tag}..."
    yq eval -i ".services[\"${service}\"].image = \"${image}:${tag}\"" "${compose_file}"
done

# docker-compose up -d
