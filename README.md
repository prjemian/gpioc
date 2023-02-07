# gpioc

Build the EPICS general purpose IOC.

-- work-in-progress --

CONTENTS

- [gpioc](#gpioc)
  - [IOCs](#iocs)
    - [xxx](#xxx)
    - [ADSimDetector](#adsimdetector)
    - [ADURL](#adurl)
    - [PVA Detector](#pva-detector)
    - [General Purpose - Custom XXX](#general-purpose---custom-xxx)
  - [Version 1 scripts](#version-1-scripts)
  - [References](#references)

## IOCs

### xxx

prefix: `xxx:` (default)

To run, define environment variable `PREFIX="gp:"` (or whatever), then:

```bash
/home/xxx_custom_ioc/softioc/xxx.sh start
```

In docker, define the environment variable `PRE` (without a trailing `:`):

```bash
PRE=gp
CONTAINER=ioc${PRE}
PREFIX=${PRE}:
TMP_ROOT=/tmp/docker_ioc
HOST_IOC_ROOT=${TMP_ROOT}/${CONTAINER}
HOST_TMP_SHARE=${HOST_IOC_ROOT}/tmp
IMAGE=prjemian/gpioc_host
IOC_MANAGER=iocxxx/softioc/xxx.sh

# create the local directory
mkdir -p "${HOST_TMP_SHARE}"
# start the container
docker run -d -it --rm --net=host \
    --name ${CONTAINER} \
    -e "PREFIX=${PREFIX}" \
    -v "${HOST_TMP_SHARE}":/tmp \
    ${IMAGE} \
    bash
# start the IOC
docker exec \
  "${CONTAINER}" \
  /home/start_custom_xxx_ioc.sh

# stop the IOC
docker stop "${CONTAINER}"
# /bin/rm -rf "${HOST_TMP_SHARE}"
```

### ADSimDetector

prefix: `13SIM:`

### ADURL

prefix: `13URL:`

### PVA Detector

prefix: `13PVA:`

### General Purpose - Custom XXX

prefix: `gp:` (or user-specified)

## Version 1 scripts

step | script
---- | ------
Common environment variables | [`env-vars.sh`](./v1.0/env-vars.sh)
Download and Build EPICS base | [`base-build.sh`](./v1.0/base-build.sh)
Download and Prepare synApps | [`synApps-download.sh`](./v1.0/synApps-download.sh)
Build synApps | [`synApps-build.sh`](./v1.0/synApps-build.sh)
Custom xxx IOC | [`custom-xxx-build.sh`](./v1.0/custom-xxx-build.sh)
Custom ADSimDetector IOC | [`custom-adsimdet-build.sh`](./v1.0/custom-adsimdet-build.sh)
Custom ADUrl IOC | [`custom-adurl-build.sh`](./v1.0/custom-adurl-build.sh)
Custom PVA detector IOC | [`custom-adurl-build.sh`](./v1.0/custom-adurl-build.sh)

## References

* https://github.com/prjemian/epics-docker/
