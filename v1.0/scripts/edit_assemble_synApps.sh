#!/bin/bash

# edit the assemble_synApps.sh script
# to download and prepare for building synApps

TARGET="$(readlink -f $(pwd))/assemble_synApps.sh"
echo "TARGET=${TARGET}"

if [ ! -f "${TARGET}" ]; then
    echo "File not found: ${TARGET}"
    exit
fi

# EPICS base
eval "sed -i s:'^EPICS_BASE=':'EPICS_BASE=${EPICS_ROOT}\n# EPICS_BASE=':g ${TARGET}"
echo "# Confirm the limited scope of that edit:"
grep "EPICS_BASE=" "${TARGET}"


# do NOT use these modules
_MODULES_=""
_MODULES_+=" ALIVE"
_MODULES_+=" ALLENBRADLEY"
_MODULES_+=" CAMAC"
_MODULES_+=" DAC128V"
_MODULES_+=" DELAYGEN"
_MODULES_+=" DXP"
_MODULES_+=" DXPSITORO"
_MODULES_+=" GALIL"
_MODULES_+=" IP330"
_MODULES_+=" IPUNIDIG"
_MODULES_+=" LOVE"
_MODULES_+=" MEASCOMP"
_MODULES_+=" QUADEM"
_MODULES_+=" SOFTGLUE"
_MODULES_+=" SOFTGLUEZYNQ"
_MODULES_+=" VAC"
_MODULES_+=" VME"
_MODULES_+=" YOKOGAWA_DAS"
_MODULES_+=" XSPRESS3"

for mod in ${_MODULES_}; do
  cmd="sed -i s:'${mod}=':'#+#${mod}=':g ${TARGET}"
  echo ${cmd}
  eval ${cmd}
done

# use these modules from their GitHub master branch(es)

_MODULES_=""
_MODULES_+=" AREA_DETECTOR"
_MODULES_+=" ASYN"
_MODULES_+=" AUTOSAVE"
_MODULES_+=" BUSY"
_MODULES_+=" CALC"
_MODULES_+=" CAPUTRECORDER"
_MODULES_+=" DEVIOCSTATS"
_MODULES_+=" IP"
_MODULES_+=" IPAC"
_MODULES_+=" LUA"
_MODULES_+=" MCA"
_MODULES_+=" MODBUS"
_MODULES_+=" MOTOR"
_MODULES_+=" OPTICS"
_MODULES_+=" SSCAN"
_MODULES_+=" STD"
_MODULES_+=" STREAM"
_MODULES_+=" XXX"

# # for mod in ${_MODULES_}; do
# #   cmd="sed -i s:'^${mod}=\S*\$':'${mod}=master':g ${TARGET}"
# #   echo ${cmd}
# #   eval ${cmd}
# # done
# for mod in "CAPUTRECORDER"; do
#   cmd="sed -i s:'^${mod}=\S*\$':'${mod}=${CAPUTRECORDER_HASH}':g ${TARGET}"
#   echo ${cmd}
#   eval ${cmd}
# done
# for mod in "MOTOR"; do
#   cmd="sed -i s:'^${mod}=\S*\$':'${mod}=${MOTOR_HASH}':g ${TARGET}"
#   echo ${cmd}
#   eval ${cmd}
# done
# for mod in "STREAM"; do
#   cmd="sed -i s:'^${mod}=\S*\$':'${mod}=2.8.14':g ${TARGET}"
#   echo ${cmd}
#   eval ${cmd}
# done

sed -i s:'git submodule update ADSimDetector':'git submodule update ADSimDetector\ngit submodule update ADURL\ngit submodule update pvaDriver\ngit submodule update ffmpegServer':g ${TARGET}
