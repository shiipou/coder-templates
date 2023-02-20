# Start from base image (built on Docker host)
FROM coder-base:v0.1

ARG V_VERSION

# Force user to coder
USER coder

# Install V
RUN [ -z "$V_VERSION" ] && export V_VERSION=$(curl -fsS https://raw.githubusercontent.com/lenra-io/lenra_cli/master/VERSION)

RUN curl -sL https://github.com/vlang/v/releases/download/${V_VERSION}/v_linux.zip -o v_linux.zip && \
    unzip v_linux.zip -d $HOME/ && \
    rm v_linux.zip

RUN $HOME/v/v symlink
