#!/bin/bash

# environment variables

SHELL_SCRIPT_NAME=${BASH_SOURCE:-${0}}
export SCRIPT_DIR=$(readlink -f $(dirname "${SHELL_SCRIPT_NAME}"))

# defined in Dockerfile
# export BASE_VERSION=7.0.4.1
# export SYNAPPS_VERSION=R6-2-1

# HASH is a release, tag, branch or commit hash (commit hash could be shortened)
export XXX_HASH="${XXX_HASH:-${SYNAPPS_VERSION}}"


# production
export APP_ROOT="${APP_ROOT:-/opt/epics}"
# # testing
# export APP_ROOT=$(mktemp -d)
# # development
# export APP_ROOT=/tmp/build_gpioc

mkdir -p "${APP_ROOT}"

# base
export EPICS_BASE_NAME=${EPICS_BASE_NAME:-"base-${BASE_VERSION}"}
# export EPICS_BASE_DIR_NAME=base-R${BASE_VERSION}

export EPICS_HOST_ARCH=${EPICS_HOST_ARCH:-linux-x86_64}
export EPICS_ROOT="${APP_ROOT}/${EPICS_BASE_NAME}"
export PATH="${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}:${PATH}"

# synApps
export SYNAPPS=${SYNAPPS:-"${APP_ROOT}/synApps"}
export SUPPORT=${SUPPORT:-"${SYNAPPS}/support"}
export XXX=${XXX:-"${SUPPORT}/xxx-${XXX_HASH}"}
export IOCXXX=${IOCXXX:-"${XXX}/iocBoot/iocxxx"}

export PATH="${SUPPORT}/utils:${PATH}"

echo "# APP_ROOT=${APP_ROOT}"
echo "# BASE_VERSION=${BASE_VERSION}"
echo "# EPICS_BASE_NAME=${EPICS_BASE_NAME}"
echo "# EPICS_HOST_ARCH=${APP_ROOT}"
echo "# EPICS_ROOT=${APP_ROOT}"
echo "# IOCXXX=${IOCXXX}"
echo "# SCRIPT_DIR=${SCRIPT_DIR}"
echo "# SUPPORT=${SUPPORT}"
echo "# SYNAPPS_VERSION=${SYNAPPS_VERSION}"
echo "# SYNAPPS=${SYNAPPS}"
echo "# XXX_HASH=${XXX_HASH}"
echo "# XXX=${XXX}"

function echo_pwd_ls
{
  echo "# pwd=$(pwd)  ls=$(ls -lAFgh)"
}
