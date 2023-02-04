FROM  ubuntu:latest
LABEL version="1.1.0" \
      maintainer="prjemian <prjemian@gmail.com>" \
      Description="source: https://github.com/prjemian/epics-docker/"
    #   lastupdate="2023-02-03" \
USER  root
WORKDIR /home

# Install necessary libraries from offical repo
RUN DEBIAN_FRONTEND=noninteractive apt-get update  -y && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
        apt-utils \
        build-essential  \
        libreadline-dev  \
        nano  \
        screen \
        vim \
        git \
        libnet-dev \
        libpcap-dev \
        libusb-1.0-0-dev \
        libusb-dev \
        libx11-dev \
        libxext-dev \
        re2c \
        wget \
        && \
    rm -rf /var/lib/apt/lists/*

# additional software packages added here
ENV APP_ROOT="/opt"
# for use with `crontab -e`
ENV EDITOR="nano"
# only show last few subdirs before console prompt
ENV PROMPT_DIRTRIM=3

COPY ./*.sh ./
COPY ./db ./db/
COPY ./scripts ./scripts/
RUN bash build-base.sh 2>&1 | tee ./build-base.log
# TODO: test the softIoc somehow
RUN bash build-synApps.sh 2>&1 | tee ./build-synApps.log