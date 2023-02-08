FROM  ubuntu:latest
LABEL version="1.1.0" \
      maintainer="prjemian <prjemian@gmail.com>" \
      Description="source: https://github.com/prjemian/epics-docker/"
    #   lastupdate="2023-02-03" \
USER  root
ENV USER_DIR=/home
WORKDIR ${USER_DIR}
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

COPY ./env-vars.sh "${USER_DIR}/"
COPY ./base-build.sh "${USER_DIR}/"
COPY ./db/demo.db "${USER_DIR}/db/"
RUN bash "${USER_DIR}/base-build.sh" 2>&1 | tee "${USER_DIR}/base-build.log"

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

COPY ./scripts/edit_assemble_synApps.sh "${USER_DIR}/scripts/"
COPY ./scripts/recommended_AD_edits.sh "${USER_DIR}/scripts/"
COPY ./synApps-download.sh "${USER_DIR}/"
RUN bash synApps-download.sh 2>&1 | tee "${USER_DIR}/synApps-download.log"

COPY ./synApps-build.sh "${USER_DIR}/"
COPY ./scripts/copy_screens.sh "${USER_DIR}/scripts/"
COPY ./scripts/modify_adl_in_ui_files.sh "${USER_DIR}/scripts/"
RUN bash synApps-build.sh 2>&1 | tee "${USER_DIR}/synApps-build.log"

# TODO: test the XXX IOC somehow
#     cd $IOCXXX/softIoc
#     ./xxx.sh start
#     caget xxx:UPTIME
#     ./xxx.sh stop

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - custom synApps XXX IOC
# - - - - - - - - - - - - - - - - - - - - - -

COPY ./custom-xxx-build.sh "${USER_DIR}/"
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

RUN bash "${USER_DIR}/custom-xxx-build.sh" 2>&1 | tee "${USER_DIR}/custom-xxx-build.log"
WORKDIR "${SYNAPPS}/iocs/xxx_custom"

WORKDIR ${USER_DIR}

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - EPICS ADSimDetector
# - - - - - - - - - - - - - - - - - - - - - -

ENV IOCADSIMDETECTOR="${AREA_DETECTOR}/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector"
COPY ./scripts/edit_ADSimDetector.sh "${USER_DIR}/scripts/"
RUN \
    ln -s "${IOCADSIMDETECTOR}" "${SUPPORT}/iocSimDetector" \
    && ln -s "${IOCADSIMDETECTOR}" "${APP_ROOT}/iocSimDetector" \
    && ln -s "${IOCADSIMDETECTOR}" "${USER_DIR}/iocSimDetector" \
    && bash "${USER_DIR}/scripts/edit_ADSimDetector.sh"

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - Final
# - - - - - - - - - - - - - - - - - - - - - -

RUN ln -s "${APP_ROOT}/screens" /tmp/screens
WORKDIR ${USER_DIR}
