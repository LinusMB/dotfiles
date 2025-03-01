# Quick Start

```sh
# Run install script
$ curl https://raw.githubusercontent.com/LinusMB/dotfiles/master/install.sh | bash
```

## Dconf

```sh
# Load desktop settings
$ curl https://raw.githubusercontent.com/LinusMB/dotfiles/master/bin/dconf-settings | bash
```

## Debian

### Sudo

```sh
$ su -
$ apt-get install sudo
$ echo "USERNAME ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers
```

### Network Manager

```sh
sudo sed -i 's/^/#/' /etc/network/interfaces
sudo systemctl enable --now NetworkManager
nmcli dev wifi list
nmcli dev wifi connect "SSID" password "PASSWORD"
```
