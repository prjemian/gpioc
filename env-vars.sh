#!/bin/bash

# environment variables

export BASE_VERSION=7.0.7

SHELL_SCRIPT_NAME=${BASH_SOURCE:-${0}}
export SCRIPT_DIR=$(readlink -f $(dirname "${SHELL_SCRIPT_NAME}"))

# # production
# export APP_ROOT=/opt/epics
# # testing
# export APP_ROOT=$(mktemp -d)
# development
export APP_ROOT=/tmp/build_gpioc

mkdir -p "${APP_ROOT}"

export EPICS_BASE_NAME="base-${BASE_VERSION}"
# export EPICS_BASE_DIR_NAME=base-R${BASE_VERSION}

export EPICS_HOST_ARCH=linux-x86_64
export EPICS_ROOT="${APP_ROOT}/${EPICS_BASE_NAME}"
export PATH="${PATH}:${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}"

echo "# APP_ROOT=${APP_ROOT}"
echo "# BASE_VERSION=${BASE_VERSION}"
echo "# EPICS_BASE_NAME=${EPICS_BASE_NAME}"
echo "# EPICS_HOST_ARCH=${APP_ROOT}"
echo "# EPICS_ROOT=${APP_ROOT}"
echo "# SCRIPT_DIR=${SCRIPT_DIR}"

function echo_pwd_ls
{
  echo "# pwd=$(pwd)  ls=$(ls -lAFgh)"
}
