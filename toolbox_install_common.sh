install_dir=/usr/local/bin

function get_latest() {
  tag=$(curl https://api.github.com/repos/$repo/releases | jq --raw-output '.[0].tag_name')
  ver=${tag#v}
}
