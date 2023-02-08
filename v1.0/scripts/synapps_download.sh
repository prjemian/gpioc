#!/bin/bash

# Download and Build EPICS synApps

source "${SCRIPT_DIR}/env_vars.sh"

echo "# APP_ROOT=${APP_ROOT}"
echo "# BASE_VERSION=${BASE_VERSION}"
echo "# CAPUTRECORDER_HASH=${CAPUTRECORDER_HASH}"
echo "# EPICS_BASE_NAME=${EPICS_BASE_NAME}"
echo "# EPICS_HOST_ARCH=${APP_ROOT}"
echo "# EPICS_ROOT=${APP_ROOT}"
echo "# IOCXXX=${IOCXXX}"
echo "# LOG_DIR=${LOG_DIR}"
echo "# SCRIPT_DIR=${SCRIPT_DIR}"
echo "# SUPPORT=${SUPPORT}"
echo "# SYNAPPS_VERSION=${SYNAPPS_VERSION}"
echo "# SYNAPPS=${SYNAPPS}"
echo "# XXX_HASH=${XXX_HASH}"
echo "# XXX=${XXX}"

# ---------------------------------------------
# --------------------------------------------- download & install
# ---------------------------------------------
cd ${APP_ROOT}
echo_pwd_ls

/bin/rm -rf *assemble* synApps ioc* screens support

# download the installer
wget https://raw.githubusercontent.com/EPICS-synApps/support/${SYNAPPS_VERSION}/assemble_synApps.sh
echo_pwd_ls

# edit the installer for EPICS_BASE and module selection
bash "${SCRIPT_DIR}/edit_assemble_synapps.sh" 2>&1 | tee "${LOG_DIR}/edit_assemble_synapps.log"

# run the installer
bash ./assemble_synApps.sh 2>&1 | tee "${LOG_DIR}/assemble_synApps.log"
echo_pwd_ls

# further modify area detector
bash "${SCRIPT_DIR}/recommended_ad_edits.sh" 2>&1 | tee "${LOG_DIR}/recommended_ad_edits.log"
echo_pwd_ls

# repair a missing link
echo "SNCSEQ=\$(SUPPORT)/seq-2-2-9" > ${SUPPORT}/StreamDevice-2-8-16/configure/RELEASE.local

# ---------------------------------------------
# --------------------------------------------- verify
# ---------------------------------------------
# if [ ! -d "${MOTOR}" ]; then echo "did not find expected: ${MOTOR}"; fi
if [ ! -d "${XXX}" ]; then echo "did not find expected directory: XXX='${XXX}'"; fi
if [ ! -d "${IOCXXX}" ]; then echo "did not find expected directory: IOCXXX='${IOCXXX}'"; fi

# ---------------------------------------------
# --------------------------------------------- IOC links
# ---------------------------------------------
ln -s "${IOCXXX}/" "${SUPPORT}/iocxxx"
ln -s "${IOCXXX}/" "${APP_ROOT}/iocxxx"
ln -s "${IOCXXX}/" "${SCRIPT_DIR}"
ln -s "${SUPPORT}" "${SCRIPT_DIR}"
