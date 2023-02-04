#!/bin/bash

# Download and Build EPICS synApps

source ./env-vars.sh

# ---------------------------------------------
# --------------------------------------------- download & install
# ---------------------------------------------
cd ${APP_ROOT}
echo_pwd_ls

/bin/rm -rf *assemble* synApps ioc* screens support

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
# --------------------------------------------- IOC links
# ---------------------------------------------
ln -s "${IOCXXX}/" "${SUPPORT}/iocxxx"
ln -s "${IOCXXX}/" "${APP_ROOT}/iocxxx"
ln -s "${IOCXXX}/" /home
ln -s "${SUPPORT}" /home
