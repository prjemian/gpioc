#!/bin/bash

# file: recommended_ad_edits.sh
# Purpose: recommended edits:
#    https://areadetector.github.io/master/install_guide.html

# Most edits are now completed by assemble_synApps.sh
# These are also needed.

source "${SCRIPT_DIR}/env_vars.sh"
cd "${AREA_DETECTOR}/configure"

# CONFIG_SITE.local -- no edits

sed -i s:'#ADSIMDETECTOR=':'ADSIMDETECTOR=':g RELEASE.local
sed -i s:'#ADURL=':'ADURL=':g RELEASE.local
# sed -i s:'#FFMPEGSERVER=':'FFMPEGSERVER=':g RELEASE.local
sed -i s:'#PVADRIVER=':'PVADRIVER=':g RELEASE.local

cd ${AREA_DETECTOR}/ADCore/iocBoot

sed -i s:'#NDPvaConfigure':'NDPvaConfigure':g               commonPlugins.cmd
sed -i s:'#dbLoadRecords("NDPva':'dbLoadRecords("NDPva':g   commonPlugins.cmd
sed -i s:'#startPVAServer':'startPVAServer':g               commonPlugins.cmd

# sed -i s:'#ffmpeg':'ffmpeg':g                               commonPlugins.cmd
# sed -i s:'#dbLoadRecords("\$(FFMPEGSERVER':'dbLoadRecords("\$(FFMPEGSERVER':g   commonPlugins.cmd
