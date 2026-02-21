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

echo "$GPG_PRIVATE_KEY" | base64 -d | gpg --batch --import --yes

for pkg in "${new_pkgs_dir}"/*.pkg.tar.zst; do
  gpg --batch --yes --default-key "${GPG_KEY_ID}" --output "${pkg}.sig" --detach-sig "${pkg}"
  cp "${pkg}" "${repo_dir}"/
  cp "${pkg}".sig "${repo_dir}"/
done

repo-add --remove --sign --key "${GPG_KEY_ID}" "${repo_dir}"/archlinux-gaming-ci.db.tar.gz "${repo_dir}"/*.pkg.tar.zst
