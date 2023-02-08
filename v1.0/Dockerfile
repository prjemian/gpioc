FROM  ubuntu:latest
LABEL version="2.0.0" \
      maintainer="prjemian <prjemian@gmail.com>" \
      lastupdate="2023-02-08" \
      Description="source: https://github.com/prjemian/gpioc/"
USER  root
ENV USER_DIR=/home
ENV LOG_DIR="${USER_DIR}/logs"
ENV SCRIPT_DIR="${USER_DIR}/scripts"
WORKDIR "${USER_DIR}"
CMD ["/bin/bash"]

# Install necessary libraries from offical repo
RUN DEBIAN_FRONTEND=noninteractive apt-get update  -y && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
        apt-file \
        apt-utils \
        build-essential  \
        git \
        libnet-dev \
        libntirpc-dev \
        libpcap-dev \
        libreadline-dev  \
        libusb-1.0-0-dev \
        libusb-dev \
        libx11-dev \
        libxext-dev \
        nano  \
        re2c \
        screen \
        vim \
        wget \
        && \
    apt-file update && \
    rm -rf /var/lib/apt/lists/*

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ENV APP_ROOT=/tmp/build_gpioc
ENV APP_ROOT="/opt/epics"

ENV BASE_VERSION=7.0.4.1
ENV SYNAPPS_VERSION=R6-2-1
ENV EPICS_HOST_ARCH=linux-x86_64

# for use with `crontab -e`
ENV EDITOR="nano"

# only show last few subdirs before console prompt
ENV PROMPT_DIRTRIM=3

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - EPICS base
# - - - - - - - - - - - - - - - - - - - - - -

# base
ENV EPICS_BASE_NAME="base-${BASE_VERSION}"
# export EPICS_BASE_DIR_NAME=base-R${BASE_VERSION}

ENV EPICS_ROOT="${APP_ROOT}/${EPICS_BASE_NAME}"
ENV PATH="${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}:${PATH}"

COPY ./scripts/env_vars.sh "${SCRIPT_DIR}/"
COPY ./scripts/base_build.sh "${SCRIPT_DIR}/"
COPY ./db/demo.db "${USER_DIR}/db/"
RUN \
    mkdir -p "${APP_ROOT}" \
    && mkdir -p "${LOG_DIR}"
RUN bash "${SCRIPT_DIR}/base_build.sh" 2>&1 | tee "${LOG_DIR}/docker_base_build.log"

# TODO: test the softIoc somehow
# Run the IOC in a detached screen session and test xxx:UPTIME
#     softIoc -m IOC=demo:  -d $USER_DIR/db/demo.db
#     caget demo:ao

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - EPICS synApps
# - - - - - - - - - - - - - - - - - - - - - -
# https://github.com/EPICS-synApps/support#download-the-synapps-modules

ENV SYNAPPS="${APP_ROOT}/synApps"
ENV SYNAPPS_DIR="${SYNAPPS}"
ENV SUPPORT="${SYNAPPS}/support"
ENV PATH="${SUPPORT}/utils:${PATH}"

ENV AD_HASH=R3-11
ENV AREA_DETECTOR="${SUPPORT}/areaDetector-${AD_HASH}"
ENV XXX_HASH="${SYNAPPS_VERSION}"
ENV XXX="${SUPPORT}/xxx-${XXX_HASH}"
ENV IOCXXX="${XXX}/iocBoot/iocxxx"

COPY ./scripts/edit_assemble_synapps.sh "${SCRIPT_DIR}/"
COPY ./scripts/recommended_ad_edits.sh "${SCRIPT_DIR}/"
COPY ./scripts/synapps_download.sh "${SCRIPT_DIR}/"
RUN bash "${SCRIPT_DIR}/synapps_download.sh" 2>&1 | tee "${LOG_DIR}/docker_synapps_download.log"

COPY ./scripts/synapps_build.sh "${SCRIPT_DIR}/"
COPY ./scripts/copy_screens.sh "${SCRIPT_DIR}/"
COPY ./scripts/modify_adl_in_ui_files.sh "${SCRIPT_DIR}/"
RUN bash "${SCRIPT_DIR}/synapps_build.sh" 2>&1 | tee "${LOG_DIR}/docker_synapps_build.log"

# TODO: test the XXX IOC somehow
#     cd $IOCXXX/softIoc
#     ./xxx.sh start
#     caget xxx:UPTIME
#     ./xxx.sh stop

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - custom synApps XXX IOC
# - - - - - - - - - - - - - - - - - - - - - -

COPY ./scripts/custom_xxx_build.sh "${SCRIPT_DIR}/"
COPY ./db/general_purpose.db "${USER_DIR}/db/"
COPY ./db/asyn_motor.db.diffs "${USER_DIR}/db/"
WORKDIR "${SUPPORT}"

RUN \
    mkdir "${SYNAPPS}/iocs" \
    && tar cf - "xxx-${XXX_HASH}" | (cd "${SYNAPPS}/iocs" && tar xf -) \
    && cd "${SYNAPPS}/iocs" \
    && mv "${SYNAPPS}/iocs/xxx-${XXX_HASH}" xxx_custom \
    && cd xxx_custom \
    && /bin/rm -rf .git \
    && make clean

RUN bash "${SCRIPT_DIR}/custom_xxx_build.sh" 2>&1 | tee "${LOG_DIR}/docker_custom_xxx_build.log"
WORKDIR "${SYNAPPS}/iocs/xxx_custom"

WORKDIR ${USER_DIR}

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - EPICS ADSimDetector
# - - - - - - - - - - - - - - - - - - - - - -

ENV IOCADSIMDETECTOR="${AREA_DETECTOR}/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector"
COPY ./scripts/edit_adsimdetector.sh "${SCRIPT_DIR}/"
RUN \
    ln -s "${IOCADSIMDETECTOR}" "${SUPPORT}/iocSimDetector" \
    && ln -s "${IOCADSIMDETECTOR}" "${APP_ROOT}/iocSimDetector" \
    && ln -s "${IOCADSIMDETECTOR}" "${USER_DIR}/iocSimDetector" \
    && bash "${SCRIPT_DIR}/edit_adsimdetector.sh"

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - EPICS ADURL
# - - - - - - - - - - - - - - - - - - - - - -

ENV IOCADURL="${AREA_DETECTOR}/ADURL/iocs/urlIOC/iocBoot/iocURLDriver"
COPY ./scripts/edit_adurl.sh "${SCRIPT_DIR}/"
RUN \
    ln -s "${IOCADURL}" "${SUPPORT}/iocUrl" \
    && ln -s "${IOCADURL}" "${APP_ROOT}/iocUrl" \
    && ln -s "${IOCADURL}" "${USER_DIR}/iocUrl" \
    && bash "${SCRIPT_DIR}/edit_adurl.sh"

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - EPICS (AD) pvaDriver
# - - - - - - - - - - - - - - - - - - - - - -

ENV IOCADPVA="${AREA_DETECTOR}/pvaDriver/iocs/pvaDriverIOC/iocBoot/iocPvaDriver"
COPY ./scripts/edit_adpva.sh "${SCRIPT_DIR}/"
RUN \
    ln -s "${IOCADPVA}" "${SUPPORT}/iocPva" \
    && ln -s "${IOCADPVA}" "${APP_ROOT}/iocPva" \
    && ln -s "${IOCADPVA}" "${USER_DIR}/iocPva" \
    && bash "${SCRIPT_DIR}/edit_adpva.sh"

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - EPICS custom ADSimDetector
# - - - - - - - - - - - - - - - - - - - - - -

# ENV IOCADSIMDETECTOR="${AREA_DETECTOR}/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector"
COPY ./scripts/custom_adsimdet.sh "${SCRIPT_DIR}/"
# RUN \
#     ln -s "${IOCADSIMDETECTOR}" "${SUPPORT}/iocSimDetector" \
#     && ln -s "${IOCADSIMDETECTOR}" "${APP_ROOT}/iocSimDetector" \
#     && ln -s "${IOCADSIMDETECTOR}" "${USER_DIR}/iocSimDetector" \
#     && bash "${SCRIPT_DIR}/edit_ADSimDetector.sh"

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - Final
# - - - - - - - - - - - - - - - - - - - - - -

RUN ln -s "${APP_ROOT}/screens" /tmp/screens
WORKDIR ${USER_DIR}
