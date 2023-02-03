#!/bin/bash

# Download and Build EPICS synApps

source ./env-vars.sh

export AD=${SUPPORT}/areaDetector-${AD_HASH}
export MOTOR=${SUPPORT}/motor-${MOTOR_HASH}
export SSCAN=${SUPPORT}/sscan-master
export XXX=${SUPPORT}/xxx-${XXX_HASH}
export IOCXXX=${XXX}/iocBoot/iocxxx

LOGFILE="${SUPPORT}/build.log"

# ---------------------------------------------
# --------------------------------------------- download & install
# ---------------------------------------------
cd ${APP_ROOT}
echo_pwd_ls

/bin/rm -rf *assemble* synApps ioc* screens

# download the installer
wget https://raw.githubusercontent.com/EPICS-synApps/support/${SYNAPPS_HASH}/assemble_synApps.sh
echo_pwd_ls

# edit the installer for EPICS_BASE and module selection
bash "${SCRIPT_DIR}/scripts/edit_assemble_synApps.sh" 2>&1 | tee edit_assemble_synApps.log
echo_pwd_ls

# run the installer
bash ./assemble_synApps.sh 2>&1 | tee ./assemble_synApps.log
echo_pwd_ls

# ---------------------------------------------
# --------------------------------------------- verify
# ---------------------------------------------
if [ ! -d "${MOTOR}" ]; then echo "did not find expected: ${MOTOR}"; fi
if [ ! -d "${XXX}" ]; then echo "did not find expected: ${XXX}"; fi
if [ ! -d "${IOCXXX}" ]; then echo "did not find expected: ${IOCXXX}"; fi

# ---------------------------------------------
# --------------------------------------------- build
# ---------------------------------------------
cd "${SUPPORT}"
echo_pwd_ls

echo "# --- synApps modules ---" 2>&1 | tee "${LOGFILE}"
make release rebuild 2>&1 | tee -a "${LOGFILE}"
echo_pwd_ls

echo "# --- Building XXX IOC ---" 2>&1 | tee -a "${LOGFILE}"
make -C ${IOCXXX}/ 2>&1 | tee -a "${LOGFILE}"

# ---------------------------------------------
# --------------------------------------------- IOC links
# ---------------------------------------------

ln -s ${IOCXXX}/ "${SUPPORT}/iocxxx"
ln -s ${IOCXXX}/ "${APP_ROOT}/iocxxx"

# ---------------------------------------------
# --------------------------------------------- screens
# ---------------------------------------------

# copy all the MEDM/CSSBOY/caQtDM/... screens to ${APP_ROOT}/screens
cd ${APP_ROOT}
mkdir -p "${APP_ROOT}/screens"
bash "${SCRIPT_DIR}/scripts/copy_screens.sh" ${SUPPORT} ${APP_ROOT}/screens | tee ./copy_screens.log

# use this script in all IOCs
bash \
    "${SCRIPT_DIR}/scripts/modify_adl_in_ui_files.sh" \
    ${APP_ROOT}/screens/ui/ \
    | tee -a ./copy_screens.log
