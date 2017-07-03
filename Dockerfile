# Builds a base Docker image for building Debian packages
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/desktop:latest
LABEL maintainer Xiangmin Jiao <xmjiao@gmail.com>

USER root
WORKDIR /tmp
ADD image/bin $DOCKER_HOME/bin

# Install some required system tools and packages for X Windows
RUN add-apt-repository ppa:webupd8team/atom && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        dput \
        devscripts \
        javahelper \
        meld \
        atom && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chown -R $DOCKER_USER:$DOCKER_USER $DOCKER_HOME

USER $DOCKER_USER

RUN mkdir $DOCKER_HOME/project && \
    cd $DOCKER_HOME/project && \
    curl -O -L https://launchpad.net/ubuntu/+archive/primary/+files/octave_4.2.1.orig.tar.gz && \
    git clone --depth 1 https://github.com/xmjiao/octave-debian.git && \
    cd octave-debian && \
    git remote add upstream https://anonscm.debian.org/git/pkg-octave/octave.git && \
    git pull upstream master

USER root
WORKDIR $DOCKER_HOME
