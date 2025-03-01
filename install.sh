#!/usr/bin/env bash
# shellcheck enable=require-variable-braces

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
        unzip \
        vim-gtk3 \
        moreutils \
        jq \
        shellcheck \
        shfmt \
        xclip \
        black \
        clang-format
}

_basic() {
    curl -fLo ~/.bashrc https://raw.githubusercontent.com/LinusMB/dotfiles/master/bashrc
    curl -fLo ~/.profile https://raw.githubusercontent.com/LinusMB/dotfiles/master/profile
    curl -fLo ~/.gitconfig https://raw.githubusercontent.com/LinusMB/dotfiles/master/gitconfig
    curl -fLo ~/.inputrc https://raw.githubusercontent.com/LinusMB/dotfiles/master/inputrc
    curl -fLo ~/.tmux.conf https://raw.githubusercontent.com/LinusMB/dotfiles/master/tmux.conf
}

_desktop() {
    mkdir -p ~/.i3
    mkdir -p ~/.config/gtk-3.0/

    sudo apt-get install -y --no-install-recommends \
        i3-wm \
        suckless-tools \
        pcmanfm \
        imagemagick \
        feh \
        udiskie \
        xinit \
        x11-xserver-utils \
        chromium \
        alacritty \
        gvfs \
        gnome-themes-extra \
        fonts-inconsolata

    _overpassfont
    convert -size 1920x1080 gradient:"#cc85b5-#491f5f" -blur 0x50 -distort SRT 40 ~/wp.png

    curl -fLo ~/.xinitrc https://raw.githubusercontent.com/LinusMB/dotfiles/master/xinitrc
    curl -fLo ~/.i3/config https://raw.githubusercontent.com/LinusMB/dotfiles/master/i3config
    curl -fLo ~/.alacritty.yml https://raw.githubusercontent.com/LinusMB/dotfiles/master/alacritty.yml

    cat <<'EOF' >>~/.profile
if [[ "$(tty)" = "/dev/tty1" ]]; then
    exec startx
fi
EOF

    cat <<'EOF' >~/.gktrc-2.0
include "/home/linus/.gtkrc-2.0.mine"
gtk-theme-name="Adwaita-dark"
gtk-icon-theme-name="hicolor"
gtk-font-name="Overpass 12"
gtk-cursor-theme-name="Adwaita"
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintfull"
EOF

    cat <<'EOF' >~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=hicolor
gtk-font-name=Overpass 12
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF
}

_vim() {
    mkdir -p ~/.vim/pack/plugins/start
    mkdir -p ~/.vim/colors

    git clone --depth 1 https://github.com/tpope/vim-surround.git ~/.vim/pack/plugins/start/vim-surround
    git clone --depth 1 https://github.com/tpope/vim-commentary ~/.vim/pack/plugins/start/vim-commentary
    git clone --depth 1 https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
    git clone --depth 1 https://github.com/psf/black.git ~/.vim/pack/plugins/start/black
    git clone --depth 1 https://github.com/prettier/vim-prettier.git ~/.vim/pack/plugins/start/vim-prettier

    curl -fLo ~/.vim/colors/gruvbox.vim https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim

    curl -fLo ~/.vimrc https://raw.githubusercontent.com/LinusMB/dotfiles/master/vimrc
}

_golang() {
    local arch
    local ver
    arch="$(dpkg --print-architecture)"
    ver="$(curl -s https://go.dev/VERSION?m=text | head -1)"

    curl -fLo /tmp/go.tar.gz "https://go.dev/dl/${ver}.linux-${arch}.tar.gz"
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

    local configfile="~/.config/Code/User/settings.json"

    printf '{}' >"${configfile}"
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

_docker() {
    sudo apt-get -y update
    sudo apt-get install -y docker.io
    sudo usermod -aG docker "$(whoami)"
    sudo systemctl enable --now docker
}

_overpassfont() {
    mkdir -p ~/.local/share/fonts
    curl -fLo /tmp/overpass-3.0.5.zip https://github.com/RedHatOfficial/Overpass/releases/download/v3.0.5/overpass-3.0.5.zip
    unzip -d ~/.local/share/fonts /tmp/overpass-3.0.5.zip
    fc-cache -f -v
}

_ktfmt() {
    mkdir -p ~/bin
    curl -fLo ~/ktfmt.jar https://github.com/facebook/ktfmt/releases/download/v0.53/ktfmt-0.53-jar-with-dependencies.jar
    cat <<'EOF' >~/bin/ktfmt
#!/usr/bin/env bash
java -jar ~/ktfmt.jar --google-style "$@"
EOF
    chmod +x ~/bin/ktfmt
}

_packages
_basic
_vim
_golang
_ktfmt
