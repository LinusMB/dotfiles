#!/usr/bin/env bash

set -e

scriptdir="$(dirname ${BASH_SOURCE[0]})"

link_dots() {
	pushd "${scriptdir}"
	find . -type f ! -path '*/.git/*' ! -name "$(basename ${0})" -print0 |
		while IFS= read -r -d '' file; do
			target="$(pwd)/${file#*/}"
			link="${HOME}/${file#*/}"
			printf "${link} -> ${target}\n"
			ln -sf "${target}" "${link}"
		done
	popd
}

get_go() {
	local arch="$(dpkg --print-architecture)"

	local ver=$(curl -s https://go.dev/VERSION?m=text | head -1)

	curl -fsSL -o /tmp/go.tar.gz "https://go.dev/dl/${ver}.linux-${arch}.tar.gz"

	sudo tar -C "/usr/local" -xzf "/tmp/go.tar.gz" --strip-components=1

	sudo rm "/tmp/go.tar.gz"

	if [[ ":$PATH:" != *":${HOME}/go/bin:"* ]]; then
		printf '${HOME}/go/bin not found in PATH\n'
		printf '$ printf "export PATH=${PATH}:${HOME}/go/bin" >> ${HOME}/.profile\n'
	fi

	go version
}

get_gotools() {
	local tools=(
		"golang.org/x/tools/cmd/goimports@latest"
		"golang.org/x/tools/gopls@latest"
		"github.com/klauspost/asmfmt/cmd/asmfmt@latest"
		"github.com/go-delve/delve/cmd/dlv@latest"
		"github.com/kisielk/errcheck@latest"
		"github.com/davidrjenni/reftools/cmd/fillstruct@master"
		"github.com/rogpeppe/godef@latest"
		"github.com/mgechev/revive@latest"
		"github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
		"honnef.co/go/tools/cmd/staticcheck@latest"
		"github.com/fatih/gomodifytags@latest"
		"golang.org/x/tools/cmd/gorename@master"
		"github.com/jstemmer/gotags@master"
		"golang.org/x/tools/cmd/guru@master"
		"github.com/josharian/impl@master"
		"honnef.co/go/tools/cmd/keyify@master"
		"github.com/fatih/motion@latest"
		"github.com/koron/iferr@master"
	)

	for tool in "${tools[@]}"; do
		go install "${tool}"
	done
}

get_packages() {
	packages=(
		"curl"
		"wget"
		"git"
		"rsync"
		"tree"
		"tmux"
		"unzip"
		"vim"
		"moreutils"
		"jq"
		"shfmt"
		"black"
		"clang-format"
	)
	DEBIAN_FRONTEND=noninteractive sudo apt-get update -qq -y
	for pkg in "${packages[@]}"; do
		if ! dpkg -s "${pkg}" &>/dev/null; then
			printf "\nInstalling ${pkg}...\n"
			DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends "${pkg}"
		fi
	done
}

"${@}"
