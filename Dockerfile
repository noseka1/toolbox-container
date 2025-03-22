#########################
# STAGE GOLANG-BUILDER  #
#########################

FROM docker.io/fedora:41 as golang-builder

COPY toolbox_install_common.sh /usr/local/bin
COPY toolbox_install_golang.sh /usr/local/bin
RUN --mount=type=secret,id=GITHUB_TOKEN /usr/local/bin/toolbox_install_golang.sh

#########################
#      STAGE BASIC      #
#########################

FROM docker.io/fedora:41 as basic

COPY toolbox_install_common.sh /usr/local/bin
COPY toolbox_install_basic.sh /usr/local/bin
RUN --mount=type=secret,id=GITHUB_TOKEN /usr/local/bin/toolbox_install_basic.sh

COPY --from=golang-builder /root/go/bin/dlv /usr/local/bin

# add start script
COPY toolbox_start.sh /usr/local/bin

ENV HOME=/home/toolbox
WORKDIR /home/toolbox

ARG TOOLBOX_CONTAINER_COMMIT=unspecified
ENV TOOLBOX_CONTAINER_COMMIT $TOOLBOX_CONTAINER_COMMIT

CMD [ "/usr/local/bin/toolbox_start.sh" ]

#########################
#     STAGE MEDIUM      #
#########################

FROM basic as medium

COPY toolbox_install_medium.sh /usr/local/bin
RUN --mount=type=secret,id=GITHUB_TOKEN /usr/local/bin/toolbox_install_medium.sh

COPY toolbox_install_user.sh /usr/local/bin
RUN --mount=type=secret,id=GITHUB_TOKEN \
  GITHUB_TOKEN=$(cat /run/secrets/GITHUB_TOKEN) \
  runuser \
    --whitelist-environment GITHUB_TOKEN \
    --login toolbox \
    /usr/local/bin/toolbox_install_user.sh

COPY toolbox_fix_user.sh /usr/local/bin

#########################
#      STAGE FULL       #
#########################

FROM medium as full

COPY toolbox_install_full.sh /usr/local/bin
COPY bvn13-kcat-fedora.repo /etc/yum.repos.d
RUN --mount=type=secret,id=GITHUB_TOKEN /usr/local/bin/toolbox_install_full.sh
