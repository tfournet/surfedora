#!/bin/sh

#git clone https://github.com/linux-surface/linux-surface

sudo dnf -y config-manager --add-repo=https://pkg.surfacelinux.com/fedora/linux-surface.repo
sudo dnf -y install --allowerasing kernel-surface iptsd libwacom-surface
sudo systemctl enable iptsd
sudo dnf -y install surface-secureboot

echo """
[Unit]
Description=Fedora default kernel updater

[Path]
PathChanged=/boot

[Install]
WantedBy=default.target
""" > /etc/systemd/system/default-kernel.path

echo """
[Unit]
Description=Fedora default kernel updater

[Service]
Type=oneshot
ExecStart=/bin/sh -c \"grubby --set-default /boot/vmlinuz*surface*\"
""" > /etc/systemd/system/default-kernel.service

sudo grubby --set-default /boot/vmlinuz*surface*


# Fixing WiFi
mv -f /usr/lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin /usr/lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin.bak
wget -o /usr/lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin https://raw.githubusercontent.com/linux-surface/ath10k-firmware-override/main/board-2.bin
echo 'options ath10k_core skip_otp=y' > /etc/modprobe.d/ath10k.conf

#i2c Workaround
sed -ie "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash acpi_enforce_resources=lax\"/g" /etc/default/grub




echo "Reboot when ready"
