#!/bin/bash

set -ex

TAG="${1}"
BASE=$(echo ${TAG} | cut -d":" -f1)

if [[ -z "${TAG}" ]]; then
  echo "You must specify a container tag. ex: lalanza808/wownero:v0.9.2.0"
  exit 1
fi

docker build -t "${TAG}" .

docker tag "${TAG}" "${BASE}:latest"

docker push "${TAG}"

docker push "${BASE}:latest"
