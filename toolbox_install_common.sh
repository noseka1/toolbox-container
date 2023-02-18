github_token=${GITHUB_TOKEN:-}

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
