#!/bin/bash

set -xe

tmpdir=$(mktemp -d)

function cleanup() {
    rm -rf "$tmpdir"
}

trap cleanup EXIT

package=$1

if [[ -z "${package}" ]]; then
    echo "expected $0 <package>"
    exit 1
fi

docker buildx build --build-arg PACKAGE_NAME="${package}" --output type=local,dest="${tmpdir}" --progress plain .

cp -p "${tmpdir}"/*.pkg.tar.zst dist/
