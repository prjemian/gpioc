#!/bin/bash

# environment variables

# export BASE_VERSION=7.0.7
export BASE_VERSION=7.0.4.1

# HASH is a release, tag, branch or commit hash (commit hash could be shortened)
export AD_HASH=R3-12-1
export SYNAPPS_HASH=R6-2-1
export MOTOR_HASH=R7-2-2
# export SSCAN_HASH=R2-11-5
export SSCAN_HASH=master
export XXX_HASH=R6-2-1

SHELL_SCRIPT_NAME=${BASH_SOURCE:-${0}}
export SCRIPT_DIR=$(readlink -f $(dirname "${SHELL_SCRIPT_NAME}"))

# # production
# export APP_ROOT=/opt/epics
# # testing
# export APP_ROOT=$(mktemp -d)
# development
export APP_ROOT=/tmp/build_gpioc

mkdir -p "${APP_ROOT}"

# base
export EPICS_BASE_NAME="base-${BASE_VERSION}"
# export EPICS_BASE_DIR_NAME=base-R${BASE_VERSION}

export EPICS_HOST_ARCH=linux-x86_64
export EPICS_ROOT="${APP_ROOT}/${EPICS_BASE_NAME}"
export PATH="${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}:${PATH}"

# synApps
export SYNAPPS="${APP_ROOT}/synApps"
export SUPPORT="${SYNAPPS}/support"
export PATH="${SUPPORT}/utils:${PATH}"
export CAPUTRECORDER_HASH=master

echo "# APP_ROOT=${APP_ROOT}"
echo "# BASE_VERSION=${BASE_VERSION}"
echo "# EPICS_BASE_NAME=${EPICS_BASE_NAME}"
echo "# EPICS_HOST_ARCH=${APP_ROOT}"
echo "# EPICS_ROOT=${APP_ROOT}"
echo "# SCRIPT_DIR=${SCRIPT_DIR}"
echo "# SYNAPPS=${SYNAPPS}"
echo "# SUPPORT=${SUPPORT}"
echo "# AD_HASH=${AD_HASH}"
echo "# CAPUTRECORDER_HASH=${CAPUTRECORDER_HASH}"
echo "# MOTOR_HASH=${MOTOR_HASH}"
echo "# SSCAN_HASH=${SSCAN_HASH}"
echo "# SYNAPPS_HASH=${SYNAPPS_HASH}"
echo "# XXX_HASH=${XXX_HASH}"

function echo_pwd_ls
{
  echo "# pwd=$(pwd)  ls=$(ls -lAFgh)"
}
