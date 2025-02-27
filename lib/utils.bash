#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for skeema.
GH_REPO="https://github.com/skeema/skeema"
TOOL_NAME="skeema"
TOOL_TEST="skeema version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if skeema is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if skeema has other means of determining installable versions.
	list_github_tags
}

get_platform() {
	local name=$(uname)
	case $name in
		Linux)
			echo "linux"
			;;
		Darwin)
			echo "mac"
			;;
		*)
			echo "unknown"
	esac
}

get_arch() {
  local arch=$(uname -m)
  case $arch in
    amd64 | x86_64)
      echo "amd64"
      ;;
    arm64 | aarch64)
      echo "arm64"
      ;;
    arm)
      echo "arm"
      ;;
    *)
      echo "i386"
  esac
}

download_release() {
	local version="$1"
	local filename="$2"
  local platform=$(get_platform)
  local arch=$(get_arch)
	local supported_platforms=("linux" "mac")
	local supported_archs=("amd64" "arm64")

	if [[ ! " ${supported_platforms[@]} " =~ " ${platform} " ]]; then
		fail "Unsupported platform: $platform"
	fi
	if [[ ! " ${supported_archs[@]} " =~ " ${arch} " ]]; then
		fail "Unsupported architecture: $arch"
	fi

	local url="$GH_REPO/releases/download/v${version}/skeema_${version}_${platform}_${arch}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version... from $url"
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert skeema executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
