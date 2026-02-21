#!/bin/bash

set -e

if [[ -z "${GPG_KEY_ID}" ]]; then
  echo "missing GPG_KEY_ID env"
  exit 1
fi

if [[ -z "${GPG_PRIVATE_KEY}" ]]; then
  echo "missing GPG_PRIVATE_KEY env"
  exit 1
fi

new_pkgs_dir=$1
repo_dir=$2

if [[ -z "${new_pkgs_dir}" ]]; then
  echo "expected $0 <new_pkgs_dir> <repo_dir>"
  exit 1
fi

if [[ -z "${repo_dir}" ]]; then
  echo "expected $0 $new_pkgs_dir <repo_dir>"
  exit 1
fi

new_pkgs_dir=$(realpath "${new_pkgs_dir}")
repo_dir=$(realpath "${repo_dir}")

buildreposh=$(realpath ./ci-script-build-repo.sh)

docker run --rm \
  --env GPG_KEY_ID="${GPG_KEY_ID}" --env GPG_PRIVATE_KEY="${GPG_PRIVATE_KEY}" \
  --volume "${buildreposh}":/ci-script-build-repo.sh:ro \
  --volume "${new_pkgs_dir}":/new_pkgs --volume "${repo_dir}":/repo \
  archlinux:base-devel /ci-script-build-repo.sh /new_pkgs /repo
