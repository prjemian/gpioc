#!/bin/bash

# file: custom_adsimdet.sh
# Purpose: IOC with custom prefix

source "${SCRIPT_DIR}/env_vars.sh"
export EPICS_BASE=${EPICS_ROOT}

# - - - - - - - - - - - - - - - - - - - - - - - -

export ADCORE=$(readlink -f "${AREA_DETECTOR}/ADCore")
export ADSIMDETECTOR=$(readlink -f "${AREA_DETECTOR}/ADSimDetector")
echo "# ADCORE=${ADCORE}"
echo "# ADSIMDETECTOR=${ADSIMDETECTOR}"

# - - - - - - - - - - - - - - - - - - - - - - - -

cd $(readlink -f "${USER_DIR}/iocSimDetector")/..
tar cf - iocSimDetector | (cd "${SYNAPPS}/iocs" && tar xf -)

cd "${SYNAPPS}/iocs"
mv iocSimDetector simdet_custom

export IOCSIMDET=$(readlink -f ./simdet_custom)
ln -s "${IOCSIMDET}" "${USER_DIR}/"
echo "IOCSIMDET=${IOCSIMDET}"
cd "${IOCSIMDET}"
echo_pwd_ls

# - - - - - - - - - - - - - - - - - - - - - - - -

TARGET="iocSimDetector"
REPLACE="simdet_custom"
sed -i s:"${TARGET}":"${REPLACE}":g ./envPaths

TARGET="epicsEnvSet(\"TOP\","
REPLACE="epicsEnvSet(\"TOP\",\"$(readlink -f .)\")"
REPLACE+="\n# ${TARGET}"
sed -i s:"${TARGET}":"${REPLACE}":g ./envPaths

TARGET="epicsEnvSet(\"ADSIMDETECTOR\","
REPLACE="epicsEnvSet(\"ADSIMDETECTOR\",\"${ADSIMDETECTOR}\")"
REPLACE+="\n# ${TARGET}"
sed -i s:"${TARGET}":"${REPLACE}":g ./envPaths

/bin/rm *.darwin *.vxWorks *.mingw *.windows *.bat *.win32

# - - - - - - - - - - - - - - - - - - - - - - - -

cat > run << EOF
#!/bin/sh
#
$(readlink -f "${IOCADSIMDETECTOR}/../../bin/${EPICS_HOST_ARCH}/simDetectorApp") st.cmd
EOF

# - - - - - - - - - - - - - - - - - - - - - - - -

# FIXME: this approach has problems starting the IOC due to bad paths
# Here's one example:
# filename="../dbStatic/dbLexRoutines.c" line number=271
# No such file or directory dbRead opening file /opt/epics/synApps/iocs/simdet_custom/dbd/simDetectorApp.dbd

# TODO: Instead, compose the script that customizes the existing IOC directory
