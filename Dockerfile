#########################
# STAGE GOLANG-BUILDER  #
#########################

FROM docker.io/fedora:latest as golang-builder

COPY toolbox_install_common.sh /usr/local/bin
COPY toolbox_install_golang.sh /usr/local/bin
RUN /usr/local/bin/toolbox_install_golang.sh

#########################
#      STAGE BASIC      #
#########################

FROM docker.io/fedora:latest as basic

ARG OPENSHIFT_TOOLBOX_COMMIT=unspecified
ENV OPENSHIFT_TOOLBOX_COMMIT $OPENSHIFT_TOOLBOX_COMMIT

COPY toolbox_install_common.sh /usr/local/bin
COPY toolbox_install_basic.sh /usr/local/bin
RUN /usr/local/bin/toolbox_install_basic.sh

COPY --from=golang-builder /root/go/bin/dlv /usr/local/bin

# add start script
COPY toolbox_start.sh /usr/local/bin

RUN adduser toolbox --groups wheel && \
  chgrp 0 /home/toolbox && \
  chmod 775 /home/toolbox

# allow sudo without password
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_wheel_nopasswd

WORKDIR /home/toolbox

CMD [ "/usr/local/bin/toolbox_start.sh" ]

#########################
#      STAGE FULL       #
#########################

FROM basic as full

COPY toolbox_install_full.sh /usr/local/bin
RUN /usr/local/bin/toolbox_install_full.sh
