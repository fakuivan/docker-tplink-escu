FROM ubuntu

RUN apt update \
 && DEBIAN_FRONTEND=noninteractive apt install -y wget gnupg xvfb x11-xserver-utils python3-pip \
 && pip3 install pyinotify \
 && echo "deb [arch=amd64] https://xpra.org/ focal main" > /etc/apt/sources.list.d/xpra.list \
 && wget -q https://xpra.org/gpg.asc -O- | apt-key add - \
 && apt update \
 && DEBIAN_FRONTEND=noninteractive apt install -y xpra \
 && mkdir -p /run/user/0/xpra

ARG XPRA_UID=1000

# Taken from https://github.com/tyson-swetnam/docker-xpra/blob/7393a271023551e2a5eea15bd8830c22993dadd7/app/Dockerfile#L26-L29
RUN adduser --disabled-password --gecos "VICE_User" --uid "$XPRA_UID" xpra_user && \
    mkdir -p /run/user/"$XPRA_UID"/xpra /run/xpra && \
    chown xpra_user:xpra_user /run/user/"$XPRA_UID"/xpra /run/xpra

USER xpra_user

WORKDIR /home/xpra_user

ENTRYPOINT [ "xpra" ]
