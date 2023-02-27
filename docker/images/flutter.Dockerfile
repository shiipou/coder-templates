# Start from base image (built on Docker host)
FROM ubuntu:20.04

# Install everything as root
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


# Install Node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

# Set back to coder user
USER coder

# Prepare Android directories and system variables
RUN mkdir -p $HOME/Android/sdk
ENV ANDROID_SDK_ROOT $HOME/Android/sdk
RUN mkdir -p $HOME/.android && touch $HOME/.android/repositories.cfg

# Set up Android SDK
RUN curl -fsSLO sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools $HOME/Android/sdk/tools
RUN cd $HOME/Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd $HOME/Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:$HOME/Android/sdk/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor

# Install coder binary
RUN curl -fsSL https://coder.com/install.sh | sh