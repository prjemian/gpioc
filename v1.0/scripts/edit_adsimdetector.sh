#!/bin/bash

# file: edit_adsimdetector.sh
# Purpose: support starting the IOC

cd ${IOCADSIMDETECTOR}
ln -s ./envPaths ./envPaths.linux

echo "dbl > dbl-all.txt" >> ./st.cmd

# - - - - - - - - - - - - - - - - - - - - - - - -

cat > ./run << EOF
#!/bin/sh

"../../bin/\${EPICS_HOST_ARCH}/simDetectorApp" st.cmd
EOF
chmod +x ./run

# - - - - - - - - - - - - - - - - - - - - - - - -

runner="./in-screen.sh"
cat > "${runner}" << EOF
#!/bin/sh

/usr/bin/screen -dm -h 5000 -S iocSimDetector ./run

# start the IOC in a screen session
#  type:
#   screen -r   to start interacting with the IOC command line
#   ^a-d        to stop interacting with the IOC command line
#   ^c          to stop the IOC
EOF
chmod +x "${runner}"
runner=

# - - - - - - - - - - - - - - - - - - - - - - - -

runner="${USER_DIR}/runADSimDetector.sh"
cat > "${runner}" << EOF
#!/bin/sh

cd ${IOCADSIMDETECTOR}
./in-screen.sh
EOF
chmod +x "${runner}"
runner=
