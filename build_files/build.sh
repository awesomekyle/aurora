#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

wget -O /tmp/bitwarden.rpm 'https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=rpm'

rm /opt

# this installs a package from fedora repos
dnf5 install -y \
    htop \
    btop \
    nvtop \
    containerd \
    netcat \
    liquidctl \
    /tmp/bitwarden.rpm \
    neovim \
    knot-utils \
    kernel-tools \
    usbutils \
    bat \
    pciutils \
    yq

mv /opt/Bitwarden /usr/share/Bitwarden

cp -r /ctx/usr/* /usr/
cp -r /ctx/etc/* /etc/

ln -s var/opt /opt


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

cp /ctx/fan-speed.service /usr/lib/systemd/system/fan-speed.service

systemctl enable \
    systemd-homed \
    incus.socket \
    incus.service \
    fan-speed.service

authselect enable-feature with-systemd-homed
