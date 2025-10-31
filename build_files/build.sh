#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1
sudo dnf5 copr enable wezfurlong/wezterm-nightly -y

# this installs a package from fedora repos
dnf5 install -y \
    htop \
    btop \
    nvtop \
    containerd \
    netcat \
    liquidctl \
    neovim \
    knot-utils \
    kernel-tools \
    usbutils \
    bat \
    pciutils \
    yq \
    terminator \
    wezterm
    
cp -r /ctx/usr/* /usr/
cp -r /ctx/etc/* /etc/

chmod -R 0600 /etc/NetworkManager/system-connections/
chmod -R 0600 /usr/lib/NetworkManager/system-connections/
  
# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

systemctl enable \
    systemd-homed \
    incus.socket \
    incus.service \
    fan-speed.service \
    install-incus-agent.service \
    sshd.service

systemctl disable \
    NetworkManager-wait-online.service

authselect enable-feature with-systemd-homed
