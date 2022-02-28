FROM ubuntu

RUN apt update \
 && DEBIAN_FRONTEND=noninteractive apt install -y wget gnupg xvfb x11-xserver-utils python3-pip \
 && pip3 install pyinotify \
 && echo "deb [arch=amd64] https://xpra.org/ focal main" > /etc/apt/sources.list.d/xpra.list \
 && wget -q https://xpra.org/gpg.asc -O- | apt-key add - \
 && apt update \
 && DEBIAN_FRONTEND=noninteractive apt install -y xpra

ARG IMAGE_ARCH=x86_64
ARG S6_OVERLAY_VERSION=3.0.0.2-2

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch-"${S6_OVERLAY_VERSION}".tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${IMAGE_ARCH}-${S6_OVERLAY_VERSION}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-"${IMAGE_ARCH}"-"${S6_OVERLAY_VERSION}".tar.xz

# Taken from https://github.com/tyson-swetnam/docker-xpra/blob/7393a271023551e2a5eea15bd8830c22993dadd7/app/Dockerfile#L26-L29
RUN adduser --disabled-password --gecos "VICE_User" xpra_user
COPY rootfs/ /

ENTRYPOINT [ "/entrypoint.sh", "xpra" ]
