#!/usr/bin/env bash

_packages() { 
    sudo add-apt-repository -y ppa:aslatter/ppa
    sudo apt-get -y update

    sudo apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        wget \
        git \
        rsync \
        tree \
        tmux \
        alacritty \
        unzip \
        vim-gtk3 \
        moreutils \
        jq \
        shfmt \
        black \
        clang-format \
        fonts-inconsolata
}

_basic() {
    curl -fLo ~/.bashrc https://raw.githubusercontent.com/LinusMB/dotfiles/master/bashrc
    curl -fLo ~/.profile https://raw.githubusercontent.com/LinusMB/dotfiles/master/profile
    curl -fLo ~/.gitconfig https://raw.githubusercontent.com/LinusMB/dotfiles/master/gitconfig
    curl -fLo ~/.inputrc https://raw.githubusercontent.com/LinusMB/dotfiles/master/inputrc
    curl -fLo ~/.alacritty.yml https://raw.githubusercontent.com/LinusMB/dotfiles/master/alacritty.yml
    curl -fLo ~/.tmux.conf https://raw.githubusercontent.com/LinusMB/dotfiles/master/tmux.conf
}

_vim() {
    mkdir -p ~/.vim/pack/plugins/start
    mkdir -p ~/.vim/colors

    git clone --depth 1 https://github.com/tpope/vim-surround.git ~/.vim/pack/plugins/start/vim-surround
    git clone --depth 1 https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
    git clone --depth 1 https://github.com/psf/black.git ~/.vim/pack/plugins/start/black
    git clone --depth 1 https://github.com/prettier/vim-prettier.git ~/.vim/pack/plugins/start/vim-prettier

    curl -fLo ~/.vim/colors/gruvbox.vim https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim

    curl -fLo ~/.vimrc https://raw.githubusercontent.com/LinusMB/dotfiles/master/vimrc
}

_golang() {
    local arch="$(dpkg --print-architecture)"
    local ver="$(curl -s https://go.dev/VERSION?m=text | head -1)"

    curl -fsSL -o /tmp/go.tar.gz "https://go.dev/dl/${ver}.linux-${arch}.tar.gz"
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz --strip-components=1
    sudo rm /tmp/go.tar.gz

    go version

    go install golang.org/x/tools/cmd/goimports@latest
    go install golang.org/x/tools/gopls@latest
    go install github.com/klauspost/asmfmt/cmd/asmfmt@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    go install github.com/kisielk/errcheck@latest
    go install github.com/davidrjenni/reftools/cmd/fillstruct@master
    go install github.com/rogpeppe/godef@latest
    go install github.com/mgechev/revive@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install honnef.co/go/tools/cmd/staticcheck@latest
    go install github.com/fatih/gomodifytags@latest
    go install golang.org/x/tools/cmd/gorename@master
    go install github.com/jstemmer/gotags@master
    go install golang.org/x/tools/cmd/guru@master
    go install github.com/josharian/impl@master
    go install honnef.co/go/tools/cmd/keyify@master
    go install github.com/fatih/motion@latest
    go install github.com/koron/iferr@master
}

_vscode() {
	code --install-extension golang.go
	code --install-extension vscodevim.vim
	code --install-extension ms-python.python
    code --install-extension ms-python.black-formatter

	local configfile="${HOME}/.config/Code/User/settings.json"

	printf '{}' > "${configfile}"
	jq '. + {"editor.fontFamily": "Inconsolata"}' "${configfile}" | sponge "${configfile}"
	jq '. + {"editor.fontSize": 16}' "${configfile}" | sponge "${configfile}"
	jq '. + {"editor.cursorBlinking": "solid"}' "${configfile}" | sponge "${configfile}"
	jq '. + {"editor.formatOnSave": true}' "${configfile}" | sponge "${configfile}"
    jq '. + {"editor.autoClosingBrackets": "never"}' "${configfile}" | sponge "${configfile}"
    jq '. + {"terminal.integrated.fontSize": 16}' "${configfile}" | sponge "${configfile}"
	jq '. + {"terminal.integrated.allowChords": false}' "${configfile}" | sponge "${configfile}"
    jq '. + { 
                "terminal.integrated.commandsToSkipShell": [
                    "-workbench.action.quickOpen",
                    "-workbench.action.terminal.deleteWordLeft"
                ] 
            }' "${configfile}" | sponge "${configfile}"
	jq '. + {"terminal.integrated.sendKeybindingsToShell":true}' "${configfile}" | sponge "${configfile}"
    jq '. + {"window.openFilesInNewWindow": "default"}' "${configfile}" | sponge "${configfile}"
	jq '. + {"vim.useCtrlKeys": true}' "${configfile}" | sponge "${configfile}"
    jq '. + {"vim.useSystemClipboard": true}' "${configfile}" | sponge "${configfile}"
    jq '. + {"vim.leader": "<space>"}' "${configfile}" | sponge "${configfile}"
    jq '. + {"vim.handleKeys": {"<C-j>": true, "<C-k>: true"}}' "${configfile}" | sponge "${configfile}"
    jq '. + {
                "vim.normalModeKeyBindingsNonRecursive": [
                    {
                        "before": ["<C-k>"],
                        "after": ["O", "<Esc>", "j"]
                    },
                    {
                        "before": ["<C-j>"],
                        "after": ["o", "<Esc>", "k"]
                    },
                    {
                        "before": ["<leader>", "g"],
                        "after": ["g", "d"]
                    },
                    {
                        "before": ["<leader>", "p", "d"],
                        "commands": ["editor.action.peekDefinition"]
                    },
                    {
                        "before": ["<leader>", "p", "c"],
                        "commands": ["editor.action.revealDeclaration"]
                    },
                    {
                        "before": ["<leader>", "t"],
                        "commands": ["workbench.action.quickOpen"]
                    }
                ],
            }' "${configfile}" | sponge "${configfile}"
}

_overpassfont() {
	mkdir -p "${HOME}/.local/share/fonts"
	wget "https://github.com/RedHatOfficial/Overpass/releases/download/v3.0.5/overpass-3.0.5.zip" -O "/tmp/overpass-3.0.5.zip"
	unzip -d "${HOME}/.local/share/fonts" "/tmp/overpass-3.0.5.zip"
	fc-cache -f -v
}

_packages
_basic
_vim
_golang
