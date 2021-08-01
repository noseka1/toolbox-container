INSTALL_DIR=/usr/local/bin

function get_latest() {
  TAG=$(curl https://api.github.com/repos/$REPO/releases | jq --raw-output '.[0].tag_name')
  VER=${TAG#v}
}
