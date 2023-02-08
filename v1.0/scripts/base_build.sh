#!/bin/bash

# Download and Build EPICS base

source "${SCRIPT_DIR}/env_vars.sh"

LOGFILE="${LOG_DIR}/epics_base_build.log"
MAKE_OPTIONS=
MAKE_OPTIONS+=all
MAKE_OPTIONS+=" -j4"
# MAKE_OPTIONS+=" -j"
MAKE_OPTIONS+=" CFLAGS=\"-fPIC\""
MAKE_OPTIONS+=" CXXFLAGS=\"-fPIC\""

cd ${APP_ROOT}
ln -s "${APP_ROOT}" "${USER_DIR}/epics"
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
# aberrant naming of some versions
ln -s "./base-R${BASE_VERSION}" "./${EPICS_BASE_NAME}"

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

echo_pwd_ls
echo "# date: $(date --iso-8601=seconds)" | tee -a "${LOGFILE}"
echo "# completed build of '${EPICS_BASE_NAME}'" | tee -a "${LOGFILE}"
