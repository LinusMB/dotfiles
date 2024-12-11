# Quick Start

```sh
# Give user no-password sudo permissions
$ echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

# Run install script
$ curl https://raw.githubusercontent.com/LinusMB/dotfiles/master/install.sh | bash
```

## For Gnome

```sh
# Load desktop settings
$ curl https://raw.githubusercontent.com/LinusMB/dotfiles/master/bin/dconf-settings | bash
```
