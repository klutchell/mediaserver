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

    case "${image}" in 
        linuxserver/*) regexp="^(v)?[0-9]+\.[0-9]+(\.[0-9]+)?.*ls[0-9]+$" ;;
        *) regexp="^(v)?[0-9]+\.[0-9]+\.[0-9]+.*$" ;;
    esac

    for alias in "latest" "stable"
    do
        echo "Searching for aliases of ${image}:${alias}..."
        semver="$(get_aliases "${image}" "${alias}" "${regexp}" | sort -V | tail -n1)" || true

        [ -n "${semver}" ] && break

        echo "No aliases match filter: ${regexp}"
        get_aliases "${image}" "${alias}"
    done

    [ -n "${semver}" ] || continue

    echo "Saving as ${image}:${semver}..."
    yq eval -i ".services[\"${service}\"].image = \"${image}:${semver}\"" "${compose_file}"
done

docker-compose up -d
