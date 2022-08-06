#########################
# STAGE GOLANG-BUILDER  #
#########################

FROM docker.io/fedora:36 as golang-builder

COPY toolbox_install_common.sh /usr/local/bin
COPY toolbox_install_golang.sh /usr/local/bin
RUN /usr/local/bin/toolbox_install_golang.sh

#########################
#      STAGE BASIC      #
#########################

FROM docker.io/fedora:36 as basic

ARG TOOLBOX_CONTAINER_COMMIT=unspecified
ENV TOOLBOX_CONTAINER_COMMIT $TOOLBOX_CONTAINER_COMMIT

COPY toolbox_install_common.sh /usr/local/bin
COPY toolbox_install_basic.sh /usr/local/bin
RUN /usr/local/bin/toolbox_install_basic.sh

COPY --from=golang-builder /root/go/bin/dlv /usr/local/bin

# add start script
COPY toolbox_start.sh /usr/local/bin

ENV HOME=/home/toolbox
WORKDIR /home/toolbox

CMD [ "/usr/local/bin/toolbox_start.sh" ]

#########################
#      STAGE FULL       #
#########################

FROM basic as full

COPY toolbox_install_full.sh /usr/local/bin
RUN /usr/local/bin/toolbox_install_full.sh
