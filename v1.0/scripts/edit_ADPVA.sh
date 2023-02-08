#!/bin/sh

# file: edit_ADPVA.sh
# Purpose: support starting the IOC

cd $(readlink -f "${IOCADPVA}")
ln -s ./envPaths ./envPaths.linux

echo "dbl > dbl-all.txt" >> ./st.cmd

# - - - - - - - - - - - - - - - - - - - - - - - -

pushd ../../../..
make 2>&1 | tee make.log
popd

# - - - - - - - - - - - - - - - - - - - - - - - -

cat > ./run << EOF
#!/bin/sh

"../../bin/${EPICS_HOST_ARCH}/pvaDriverApp" st.cmd.linux
EOF
chmod +x ./run

# - - - - - - - - - - - - - - - - - - - - - - - -

runner="./in-screen.sh"
cat > "${runner}" << EOF
#!/bin/sh

/usr/bin/screen -dm -h 5000 -S iocPva ./run

# start the IOC in a screen session
#  type:
#   screen -r   to start interacting with the IOC command line
#   ^a-d        to stop interacting with the IOC command line
#   ^c          to stop the IOC
EOF
chmod +x "${runner}"
runner=

# - - - - - - - - - - - - - - - - - - - - - - - -

runner="${USER_DIR}/runADPVA.sh"
cat > "${runner}" << EOF
#!/bin/sh

cd ${IOCADPVA}
./in-screen.sh
EOF
chmod +x "${runner}"
runner=
