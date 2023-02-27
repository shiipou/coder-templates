# Start from base image (built on Docker host)
FROM ubuntu:20.04

USER root

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
    bash \
    build-essential \
    ca-certificates \
    curl \
    htop \
    locales \
    man \
    python3 \
    python3-pip \
    software-properties-common \
    sudo \
    systemd \
    systemd-sysv \
    unzip \
    vim \
    wget && \
    # Install latest Git using their official PPA
    add-apt-repository ppa:git-core/ppa && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes git

# Add a user `coder` so that you're not developing as the `root` user
RUN useradd coder \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

ARG V_VERSION

# Force user to coder
USER coder

# Install V
RUN [ -z "$V_VERSION" ] && export V_VERSION=$(curl -fsS https://raw.githubusercontent.com/lenra-io/lenra_cli/master/VERSION)

RUN curl -sL https://github.com/vlang/v/releases/download/${V_VERSION}/v_linux.zip -o v_linux.zip && \
    unzip v_linux.zip -d $HOME/ && \
    rm v_linux.zip

RUN $HOME/v/v symlink

# Install coder binary
RUN curl -fsSL https://coder.com/install.sh | sh