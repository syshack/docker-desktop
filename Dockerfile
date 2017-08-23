# Builds a base Docker image for building Debian package for qupzilla
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
        gnupg-agent \
        dput \
        fakeroot \
        devscripts \
        javahelper \
        debhelper \
        qtbase5-dev \
        qt5-qmake \
        libqt5webkit5-dev \
        qtbase5-private-dev \
        qtscript5-dev \
        libx11-dev \
        libssl-dev \
        kdelibs5-dev \
        libgnome-keyring-dev \
        libjs-jquery \
        libjs-jquery-ui && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chown -R $DOCKER_USER:$DOCKER_USER $DOCKER_HOME

USER $DOCKER_USER

RUN mkdir $DOCKER_HOME/project && \
    cd $DOCKER_HOME/project && \
    curl -L https://launchpad.net/ubuntu/+archive/primary/+files/qupzilla_2.1.2~dfsg1.orig.tar.xz -o qupzilla_2.1.2~ubuntu16.04.orig.tar.xz && \
    git clone --depth 1 git@github.com:xmjiao/qupzilla-debian.git && \
    cd qupzilla-debian && \
    DEB_FFLAGS_SET="-O2" DEB_CFLAGS_SET="-O2" DEB_CXXFLAGS_SET="-O2" \
    DEB_BUILD_OPTIONS="nocheck" debuild -i -us -uc -b -j2

USER root
WORKDIR $DOCKER_HOME
