github_token=${GITHUB_TOKEN:-}

if [[ -z "$github_token" ]] && [[ -r /run/secrets/GITHUB_TOKEN ]]; then
  github_token=$(cat /run/secrets/GITHUB_TOKEN)
fi

if [[ -z "$github_token" ]]; then
  echo You must pass a non-empty environment variable GITHUB_TOKEN to run this script.
  exit 1
fi

githubget=(curl --header "Authorization: token $github_token" --location)

install_dir=/usr/local/bin

function get_latest() {
  tag=$("${githubget[@]}" https://api.github.com/repos/$repo/releases | jq --raw-output '.[0].tag_name')
  ver=${tag#v}
}

function github_get_latest_asset() {
  local latest_release=$("${githubget[@]}" https://api.github.com/repos/$1/releases/latest)
  github_asset_tag=$(echo $latest_release | jq --raw-output '.tag_name')
  github_asset_ver=${github_asset_tag#v}
  github_asset_url=$(echo $latest_release | jq --raw-output ".assets[] | select(.name | test(\"$2\")) | .browser_download_url")
}
