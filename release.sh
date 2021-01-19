#!/bin/bash

set -ex

TAG="${1}"
BASE=$(echo ${TAG} | cut -d":" -f1)

if [[ -z "${TAG}" ]]; then
  echo "You must specify a container tag! Eg: sohamb03/xolentum:v0.3.0.0"
  exit 1
fi

docker build -t "${TAG}" .

docker tag "${TAG}" "${BASE}:latest"

docker push "${TAG}"

docker push "${BASE}:latest"
