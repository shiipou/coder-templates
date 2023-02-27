# Start from base image
FROM elixir:1.13

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

# Force user to coder
USER coder

# Install coder binary
RUN curl -fsSL https://coder.com/install.sh | sh