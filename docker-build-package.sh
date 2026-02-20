#!/bin/bash

set -xe

tmpdir=$(mktemp -d)

function cleanup() {
    rm -rf "$tmpdir"
}

trap cleanup EXIT

package=$1
output_dir=$2

if [[ -z "${package}" ]]; then
    echo "expected $0 <package> <output-dir>"
    exit 1
fi

if [[ -z "${output_dir}" ]]; then
    echo "expected $0 ${package} <output-dir>"
    exit 1
fi

docker buildx build --build-arg PACKAGE_NAME="${package}" --output type=local,dest="${tmpdir}" --progress plain .

cp -p "${tmpdir}"/*.pkg.tar.zst "${output_dir}"/
