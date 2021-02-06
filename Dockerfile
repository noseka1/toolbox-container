FROM docker.io/fedora:latest as basic

ARG OPENSHIFT_TOOLBOX_COMMIT=unspecified
ENV OPENSHIFT_TOOLBOX_COMMIT $OPENSHIFT_TOOLBOX_COMMIT

COPY install_basic.sh /usr/local/bin
RUN /usr/local/bin/install_basic.sh

# add start script
COPY start.sh /usr/local/bin

RUN adduser toolbox --groups wheel && \
  chgrp 0 /home/toolbox && \
  chmod 775 /home/toolbox

# allow sudo without password
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_wheel_nopasswd

WORKDIR /home/toolbox

CMD [ "/usr/local/bin/start.sh" ]

#########################
#      STAGE  FULL      #
#########################

FROM basic as full

COPY install_full.sh /usr/local/bin
RUN /usr/local/bin/install_full.sh
