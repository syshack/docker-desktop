# Builds a base Docker image for building Debian packages
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/desktop:latest
LABEL maintainer Xiangmin Jiao <xmjiao@gmail.com>

USER root
WORKDIR /tmp

# Install some required system tools and packages for X Windows
RUN add-apt-repository ppa:webupd8team/atom && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        dput \
        devscripts \
        javahelper \
        meld \
        atom && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR $DOCKER_HOME
