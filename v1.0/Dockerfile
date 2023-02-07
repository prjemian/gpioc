FROM  ubuntu:latest
LABEL version="1.1.0" \
      maintainer="prjemian <prjemian@gmail.com>" \
      Description="source: https://github.com/prjemian/epics-docker/"
    #   lastupdate="2023-02-03" \
USER  root
WORKDIR /home
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

COPY ./env-vars.sh ./
COPY ./base-build.sh ./
COPY ./db ./db/
RUN bash base-build.sh 2>&1 | tee ./base-build.log

# TODO: test the softIoc somehow
# Run the IOC in a detached screen session and test xxx:UPTIME
#     softIoc -m IOC=demo:  -d $SCRIPT_DIR/db/demo.db
#     caget demo:ao

# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - EPICS synApps
# - - - - - - - - - - - - - - - - - - - - - -
# https://github.com/EPICS-synApps/support#download-the-synapps-modules

ENV SYNAPPS="${APP_ROOT}/synApps"
ENV SYNAPPS_DIR="${SYNAPPS}"
ENV SUPPORT="${SYNAPPS}/support"
ENV PATH="${SUPPORT}/utils:${PATH}"

ENV XXX_HASH=${SYNAPPS_VERSION}
ENV XXX=${SUPPORT}/xxx-${XXX_HASH}
ENV IOCXXX=${XXX}/iocBoot/iocxxx

COPY ./scripts ./scripts/
COPY ./synApps-download.sh ./
RUN bash synApps-download.sh 2>&1 | tee ./synApps-download.log

COPY ./synApps-build.sh ./
RUN bash synApps-build.sh 2>&1 | tee ./synApps-build.log

# TODO: test the XXX IOC somehow
#     cd $IOCXXX/softIoc
#     ./xxx.sh start
#     caget xxx:UPTIME
#     ./xxx.sh stop

