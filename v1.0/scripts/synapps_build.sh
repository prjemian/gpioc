#!/bin/bash

# Download and Build EPICS synApps

source "${SCRIPT_DIR}/env_vars.sh"

LOGFILE="${SUPPORT}/build.log"

cd ${APP_ROOT}
echo_pwd_ls

# ---------------------------------------------
# --------------------------------------------- build
# ---------------------------------------------
cd "${SUPPORT}"
echo_pwd_ls

# asyn needs -I/usr/include/tirpc for the rpc/rpc.h headers
echo "TIRPC=YES" > "${SUPPORT}/asyn-R4-42/configure/CONFIG_SITE.local"

echo "# --- synApps modules ---" 2>&1 | tee "${LOGFILE}"
# do NOT use -j option: odd out-of-sequence errors occur
make release 2>&1 | tee -a "${LOGFILE}"
make clean 2>&1 | tee -a "${LOGFILE}"
make 2>&1 | tee -a "${LOGFILE}"
echo_pwd_ls

echo "# --- Building XXX IOC ---" 2>&1 | tee -a "${LOGFILE}"
make -C ${IOCXXX}/ 2>&1 | tee -a "${LOGFILE}"

# ---------------------------------------------
# --------------------------------------------- screens
# ---------------------------------------------
# copy all the MEDM/CSSBOY/caQtDM/... screens to ${APP_ROOT}/screens
cd ${APP_ROOT}
mkdir -p "${APP_ROOT}/screens"
bash \
    "${SCRIPT_DIR}/copy_screens.sh" \
    ${SUPPORT} \
    ${APP_ROOT}/screens \
    | tee "${LOG_DIR}/copy_screens.log"

# use this script in all IOCs
bash \
    "${SCRIPT_DIR}/modify_adl_in_ui_files.sh" \
    ${APP_ROOT}/screens/ui/ \
    | tee -a "${LOG_DIR}/copy_screens.log"
