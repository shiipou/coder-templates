# Start from base image (built on Docker host)
FROM coder-base:v0.1

# Install everything as root
USER root

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
