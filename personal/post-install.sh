#!/bin/sh

echo "+--------------+"
echo "| POST-INSTALL |"
echo "+--------------+"
echo ""

echo "+--------------+"
echo "| APPLICATIONS |"
echo "+--------------+"
echo ""

echo "VLC will now be installed..."
echo ""
sudo pacman -S vlc --needed --noconfirm
echo ""

echo "KDE Connect will now be installed..."
echo ""
sudo pacman -S kdeconnect --needed --noconfirm
echo ""

echo "GIMP will now be installed..."
echo ""
sudo pacman -S gimp --needed --noconfirm
echo ""

echo "QEMU and Virt-Manager will now be installed..."
echo ""
sudo pacman -S qemu-base virt-manager dnsmasq iptables-nft --needed
sudo systemctl enable libvirtd.service
echo ""

echo "RetroArch will now be installed..."
echo ""
sudo pacman -S retroarch libretro-core-info --needed --noconfirm
echo ""

echo "Yay will now be installed..."
echo ""
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd
rm -rf ~/yay/
