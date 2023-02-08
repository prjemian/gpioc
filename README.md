# gpioc

Build the EPICS general purpose IOC.

-- work-in-progress --

CONTENTS

- [gpioc](#gpioc)
  - [IOCs](#iocs)
    - [XXX](#xxx)
    - [ADSimDetector](#adsimdetector)
    - [ADURL](#adurl)
    - [PVA Detector](#pva-detector)
    - [Custom XXX - General Purpose](#custom-xxx---general-purpose)
    - [Custom ADSimDetector](#custom-adsimdetector)
  - [Version 1 scripts](#version-1-scripts)
  - [References](#references)

## IOCs

### XXX

prefix: `xxx:` (default)

```bash
/home/iocxxx/softioc/xxx.sh start
```

### ADSimDetector

prefix: `13SIM1:`

```bash
/home/runADSimDetector.sh
# or
# ${IOCADSIMDETECTOR}/run
```

### ADURL

prefix: `13URL1:`

```bash
/home/runADURL.sh
```

### PVA Detector

prefix: `13PVA1:`

```bash
/home/runADPVA.sh
```

### Custom XXX - General Purpose

prefix: user-specified (such as `gp:`)

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
STARTER_SCRIPT=/home/start_custom_xxx_ioc.sh

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
docker exec "${CONTAINER}" "${STARTER_SCRIPT}"

# stop the IOC
docker stop "${CONTAINER}"
# /bin/rm -rf "${HOST_TMP_SHARE}"
```

### Custom ADSimDetector

prefix: user-specified (such as `ad:`)

To run, define environment variable `PREFIX="ad:"` (or whatever), then:

```bash
# TODO:
```

## Version 1 scripts

step | script
---- | ------
Common environment variables | [`env-vars.sh`](./v1.0/env-vars.sh)
Download and Build EPICS base | [`base-build.sh`](./v1.0/base-build.sh)
Download and Prepare synApps | [`synApps-download.sh`](./v1.0/synApps-download.sh)
Build synApps | [`synApps-build.sh`](./v1.0/synApps-build.sh)
Configure ADSimDetector IOC | [`edit_ADSimDetector`](./v1.0/scripts/edit_ADSimDetector.sh)
Configure ADURL IOC | [`edit_ADURL`](./v1.0/scripts/edit_ADURL.sh)
Configure pvaDriver IOC | [`edit_ADPVA`](./v1.0/scripts/edit_ADPVA.sh)
Custom xxx IOC | [`custom-xxx-build.sh`](./v1.0/custom-xxx-build.sh)
TODO | ...
Custom ADSimDetector IOC | [`custom-adsimdet-build.sh`](./v1.0/custom-adsimdet-build.sh)
Custom ADUrl IOC | [`custom-adurl-build.sh`](./v1.0/custom-adurl-build.sh)
Custom pvaDriver IOC | [`custom_adpva_build.sh`](./v1.0/custom_adpva_build.sh)

## References

- [epics-docker](https://github.com/prjemian/epics-docker/)
