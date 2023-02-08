#!/bin/bash

# file: edit_ADSimDetector.sh
# Purpose: support starting the IOC

cd ${IOCADSIMDETECTOR}
ln -s ./envPaths ./envPaths.linux

# - - - - - - - - - - - - - - - - - - - - - - - -

cat > ./run << EOF
#!/bin/sh

"../../bin/\${EPICS_HOST_ARCH}/simDetectorApp" st.cmd
EOF
chmod +x ./run

# - - - - - - - - - - - - - - - - - - - - - - - -

runner="${USER_DIR}/runADSimDetector.sh"
cat > "${runner}" << EOF
#!/bin/sh

cd ${IOCADSIMDETECTOR}
./run
EOF
chmod +x "${runner}"
runner=

# - - - - - - - - - - - - - - - - - - - - - - - -

# TODO: in-screen.sh
# in ${IOCXXX}/softioc/, both `in-screen.sh` and `commands/*`
