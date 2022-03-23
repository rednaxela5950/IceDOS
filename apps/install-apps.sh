#!/bin/bash

username=$(whoami)

# Enable multilib
echo "[multilib]" | sudo tee -a /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf

# Update pacman mirrors
sudo pacman -Syyu --noconfirm

# Install Nvidia drivers
# You have to install the GPU drivers before installing Steam because Steam defaults to AMD vulkan drivers
(lspci | grep NVIDIA > /dev/null) && sudo pacman -S nvidia nvidia-dkms nvidia-utils

# Install pacman packages
echo "Installing pacman packages..."
< apps/packages/pacman.txt xargs sudo pacman -S --noconfirm --needed

# Install yay
(cd /opt && sudo git clone https://aur.archlinux.org/yay-git.git && sudo chown -R "$username:$username" ./yay-git && cd yay-git && makepkg -si --noconfirm)

# Install yay packages
yay -Syyu --noconfirm
echo "Installing yay packages..."
< apps/packages/yay.txt xargs yay -S --noconfirm --needed

# Install Proton GE updater
echo "Installing Proton GE updater..."
sudo pip3 install protonup
mkdir -p ~/.local/share/Steam/compatibilitytools.d/
protonup -d ~/.local/share/Steam/compatibilitytools.d/
protonup -y

# Install RPCS3
echo "Installing RPCS3..."
mkdir -p ~/.local/share/rpcs3/
wget --content-disposition https://rpcs3.net/latest-appimage -O ~/.local/share/rpcs3/rpcs3.AppImage
chmod a+x ~/.local/share/rpcs3/rpcs3.AppImage
cp settings/applications/rpcs3.desktop ~/.local/share/applications/rpcs3.desktop

# Install performance tweaks
echo "Installing performance tweaks..."
git clone https://gitlab.com/garuda-linux/themes-and-settings/settings/performance-tweaks.git
(cd performance-tweaks && makepkg -si --noconfirm)
rm -rf performance-tweaks
