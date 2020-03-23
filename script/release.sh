#!/bin/bash
set -o nounset
set -o errexit

build=${BUILD_DIR:-build}
image=${CR_IMAGE:-quay.io/helmpack/chart-releaser}
ver=${CR_VERSION:-v1.0.0-beta.1}
owner=${CR_OWNER:-the-watchmen}
repo=${CR_GIT_REPO:-helm-charts}

echo "begin"

for dir in charts/* ; do
  echo "packaging ${dir}"
  helm package -d $build $dir
done

echo "building index"
helm repo index $build

cmd="docker run \
  --rm \
  -v $(pwd)/${build}:/${build} \
  -e CR_OWNER=${owner} \
  -e CR_GIT_REPO=${repo} \
  -e CR_PACKAGE_PATH=/${build} \
  -e CR_INDEX_PATH=/${build}/index.yaml \
  -e CR_CHARTS_REPO=https://${owner}.github.io/${repo} \
  -e CR_TOKEN=${CR_TOKEN} \
  ${image}:${ver} \
  cr"

echo "running cr upload"
${cmd} upload

echo "running cr index"
${cmd} index

echo "end"