#!/bin/sh

echo "+--------------+"
echo "| POST-INSTALL |"
echo "+--------------+"
echo ""

# VLC
echo "Would you like to install vlc?"
echo ""
echo "Package : vlc"
echo "Description : Multi-platform MPEG VCD/DVD, and DivX player"
echo "Repository : Extra"
echo ""
echo "1) No (Default)"
echo "2) Yes"
echo ""
read vlc
echo ""

case "$vlc" in

    1)

    echo "OK, vlc will not be installed."

    ;;

    2)

    echo "OK, vlc will now be installed..."
    echo ""
    sudo pacman -S vlc --needed --noconfirm
    echo ""
    echo "Done. VLC has been installed."

    ;;


    *)

    echo "OK, vlc will not be installed."

    ;;

esac
echo ""

# KDE Connect
echo "Would you like to install KDE Connect?"
echo ""
echo "Package : kdeconnect"
echo "Description : Adds communication between KDE and your smartphone"
echo "Repository : Extra"
echo ""
echo "1) No (Default)"
echo "2) Yes"
echo ""
read kdeconnect
echo ""

case "$kdeconnect" in

    1)

    echo "OK, KDE Connect will not be installed."

    ;;

    2)

    echo "OK, KDE Connect will now be installed..."
    echo ""
    sudo pacman -S kdeconnect --needed --noconfirm
    echo ""
    echo "Done. KDE Connect has been installed."

    ;;

    *)

    echo "OK, KDE Connect will not be installed."

    ;;

esac
echo ""

# GIMP
echo "Would you like to install GIMP?"
echo ""
echo "Package : gimp"
echo "Description : GNU Image Manipulation Program"
echo "Repository : Extra"
echo ""
echo "1) No (Default)"
echo "2) Yes"
echo ""
read gimp
echo ""

case "$gimp" in

    1)

    echo "OK, GIMP will not be installed."

    ;;

    2)

    echo "OK, GIMP will now be installed..."
    echo ""
    sudo pacman -S gimp --needed --noconfirm
    echo ""
    echo "Done. GIMP has been installed."

    ;;

    *)

    echo "OK, GIMP will not be installed."

    ;;

esac
echo ""

# QEMU and Virt-Manager
echo "Would you like to install QEMU and Virt-Manager?"
echo "NOTE : The following packages will need to be installed"
echo ""
echo "Package : qemu-base"
echo "Description : A basic QEMU setup for headless environments"
echo "Repository : Extra"
echo ""
echo ""
echo "Package : virt-manager"
echo "Description : Desktop user interface for managing virtual machines"
echo "Repository : Community"
echo ""
echo "Package : dnsmasq"
echo "Description : Lightweight, easy to configure DNS forwarder and DHCP server"
echo "Repository : Extra"
echo ""
echo "Package : iptables-nft"
echo "Description : Linux kernel packet control tool (using nft interface)"
echo "Repository : Core"
echo ""
echo "1) Yes"
echo "2) No (Default)"
echo ""
read qemu
echo ""

case "$qemu" in

    1)

    echo "OK, QEMU and Virt-Manager will not be installed."

    ;;

    2)

    echo "OK, QEMU and Virt-Manager will now be installed..."
    echo ""
    sudo pacman -S qemu-base virt-manager dnsmasq iptables-nft --needed
    sudo systemctl enable libvirtd.service
    echo ""
    echo "Done. QEMU and Virt-Manager has been installed."
    echo "The libvirt service has been enabled."

    ;;

    *)

    echo "OK, QEMU and Virt-Manager will not be installed."

    ;;

esac
echo ""

# RetroArch
echo "Would you like to install RetroArch?"
echo ""
echo "Package : retroarch"
echo "Description : Reference frontend for the libretro API"
echo "Repository : Community"
echo ""
echo "Package : libretro-core-info"
echo "Description : Libretro core info files"
echo "Repository : Community"
echo ""
echo "1) Yes"
echo "2) No (Default)"
echo ""
read retroarch
echo ""

case "$retroarch" in

    1)

    echo "OK, RetroArch will not be installed."

    ;;

    2)

    echo "OK, RetroArch will now be installed..."
    echo ""
    sudo pacman -S retroarch libretro-core-info --needed --noconfirm
    echo ""
    echo "Done. RetroArch has been installed."

    ;;

    *)

    echo "OK, RetroArch will not be installed."

    ;;

esac
echo ""

# Yay
echo "Would you like to install yay?"
echo ""
echo "1) No (Default)"
echo "2) Yes"
echo ""
read yay
echo ""

case "$yay" in

    1)

    echo "OK, Yay will not be installed."

    ;;

    2)

    echo "OK, Yay will now be installed..."
    echo ""
    cd /home/home
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd
    rm -rf /home/home/yay/

    ;;

    *)

    echo "OK, yay will not be installed."

    ;;

esac
echo ""
