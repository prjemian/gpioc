#!/bin/bash

# Download and Build EPICS base

source ./env-vars.sh

LOGFILE="${EPICS_BASE_NAME}/build.log"
MAKE_OPTIONS=
MAKE_OPTIONS+=all
MAKE_OPTIONS+=" -j4"
# MAKE_OPTIONS+=" -j"
MAKE_OPTIONS+=" CFLAGS=\"-fPIC\""
MAKE_OPTIONS+=" CXXFLAGS=\"-fPIC\""

cd ${APP_ROOT}
echo_pwd_ls

echo "# clear directory '${APP_ROOT}'"
/bin/rm -rf *.tar.gz base* db
echo_pwd_ls

### create LOGFILE
echo "# ------------ download and build EPICS base ------------" | tee "${LOGFILE}"
### then, only _append_ to LOGFILE

echo "# APP_ROOT=${APP_ROOT}" | tee -a "${LOGFILE}"
echo "# BASE_VERSION=${BASE_VERSION}" | tee -a "${LOGFILE}"
echo "# EPICS_BASE_NAME=${EPICS_BASE_NAME}" | tee -a "${LOGFILE}"
echo "# EPICS_HOST_ARCH=${APP_ROOT}" | tee -a "${LOGFILE}"
echo "# EPICS_ROOT=${APP_ROOT}" | tee -a "${LOGFILE}"
echo "# LOGFILE=${LOGFILE}" | tee -a "${LOGFILE}"
echo "# SCRIPT_DIR=${SCRIPT_DIR}" | tee -a "${LOGFILE}"

echo "# download '${EPICS_BASE_NAME}'" | tee -a "${LOGFILE}"
wget "https://epics.anl.gov/download/base/${EPICS_BASE_NAME}.tar.gz"
tar xzf "${EPICS_BASE_NAME}.tar.gz"
/bin/rm "${EPICS_BASE_NAME}.tar.gz"
ln -s "./${EPICS_BASE_NAME}" ./base

echo_pwd_ls
echo "# date: $(date --iso-8601=seconds)" | tee -a "${LOGFILE}"

cd "${EPICS_ROOT}"
echo "# pwd=$(pwd)" | tee -a "${LOGFILE}"

echo "# build '${EPICS_BASE_NAME}' in '${EPICS_ROOT}'" | tee -a "${LOGFILE}"
echo "# MAKE_OPTIONS=${MAKE_OPTIONS}" | tee -a "${LOGFILE}"
make ${MAKE_OPTIONS}  2>&1 | tee -a "${LOGFILE}"
echo "# --- make clean ---" 2>&1 | tee -a "${LOGFILE}"
make clean  2>&1 | tee -a "${LOGFILE}"

# PVA and QSRV are already built
# see https://docs.epics-controls.org/projects/pva2pva/en/latest/doxygen/

cd "${APP_ROOT}"
echo "# pwd=$(pwd)"
mkdir -p "${APP_ROOT}/db"
echo "# SCRIPT_DIR=${SCRIPT_DIR}"
cp "${SCRIPT_DIR}/db"/demo.db "${APP_ROOT}/db/"

echo_pwd_ls
echo "# date: $(date --iso-8601=seconds)" | tee -a "${LOGFILE}"
echo "# completed build of '${EPICS_BASE_NAME}'" | tee -a "${LOGFILE}"