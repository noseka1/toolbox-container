github_token=${GITHUB_TOKEN:-}

if [[ -z "$github_token" ]] && [[ -r /run/secrets/GITHUB_TOKEN ]]; then
  github_token=$(cat /run/secrets/GITHUB_TOKEN)
fi

if [[ -z "$github_token" ]]; then
  echo You must pass a non-empty environment variable GITHUB_TOKEN to run this script.
  exit 1
fi

github_get=(curl --header "Authorization: token $github_token" --location --no-progress-meter)

install_dir=/usr/local/bin

function github_get_latest_asset() {
  local latest_release=$("${github_get[@]}" https://api.github.com/repos/$1/releases/latest)
  github_asset_tag=$(echo $latest_release | jq --raw-output '.tag_name')
  github_asset_ver=${github_asset_tag#v}
  github_asset_url=$(echo $latest_release | jq --raw-output ".assets[] | select(.name | test(\"^$2\$\")) | .browser_download_url")
}

function github_download_latest_asset() {
  github_get_latest_asset "$1" "$2"
  echo Downloading $github_asset_url >&2
  "${github_get[@]}" $github_asset_url
}
