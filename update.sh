#!/usr/bin/env bash

set -euo pipefail

compose_file="docker-compose.yml"
override_file="docker-compose.override.yml"

yq() {
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}

skopeo() {
    docker run --rm alexeiled/skopeo:latest sh -c "skopeo $*"
}

echo "---" > "${override_file}"

for image in $(yq eval '.services[].image' "${compose_file}")
do
    service="$(yq eval ".services[].image | select(. == \"${image}\") | path | .[-2]" "${compose_file}")"

    echo "inspecting $image..."
    digest=$(skopeo "inspect docker://docker.io/$image" | jq '.Digest' | tr -d '"' )

    pinned_image="${image%%:*}@${digest}"

    echo "recording ${pinned_image}..."
    yq eval -i ".services.${service}.image=\"${pinned_image}\"" ${override_file}
done

docker-compose up -d
