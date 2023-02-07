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

## IOCs

### xxx

prefix: `xxx:`

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
Custom xxx IOC | [`build-custom-xxx.sh`](./v1.0/build-custom-xxx.sh)
Custom ADSimDetector IOC | [`build-custom-adsimdet.sh`](./v1.0/custom-adsimdet-build.sh)
Custom ADUrl IOC | [`build-custom-adurl.sh`](./v1.0/custom-adurl-build.sh)
Custom PVA detector IOC | [`build-custom-adurl.sh`](./v1.0/custom-adurl-build.sh)
