 #!/bin/sh

 echo "+--------------+"
echo "| APPLICATIONS |"
echo "+--------------+"
echo ""

# Text Editor
echo "A terminal-based text editor is HIGHLY recommended"
echo "Would you like to install nano or vim?"
echo ""
echo "Package : nano"
echo "Description : Pico editor clone with enhancements"
echo "Repository : Core"
echo ""
echo "Package : vim"
echo "Description : Vi Improved, a highly configurable, improved version of the vi text editor"
echo "Repository : Extra"
echo ""
echo "1) Nano"
echo "2) Vim"
echo "3) Both"
echo "4) None (Default)"
echo ""
read texteditor
echo ""

case "$texteditor" in
    1)
    echo "OK. Nano will now be installed."
    echo ""
    pacman -S nano --needed --noconfirm
    echo ""
    echo "Done. Nano has been installed."
    ;;
    2)
    echo "OK. Vim will now be installed."
    echo ""
    pacman -S vim --needed --noconfirm
    echo ""
    echo "Done. Vim has been installed."
    ;;
    3)
    echo "OK. Nano and Vim will now be installed."
    echo ""
    pacman -S nano vim --needed --noconfirm
    echo ""
    echo "Done. Nano and Vim have been installed."
    ;;
    3)
    echo "No text editor will be installed."
    ;;
    *)
    echo "No text editor will be installed."
    ;;
esac
echo ""

# Htop
echo "Would you like to install htop?"
echo ""
echo "Package : htop"
echo "Description : Interactive process viewer"
echo "Repository : Extra"
echo ""
echo "1) Yes"
echo "2) No (Default)"
echo ""
read htop
echo ""

case "$htop" in
    1)
    echo "OK, htop will now be installed..."
    echo ""
    pacman -S htop --needed --noconfirm
    echo ""
    echo "Done. Htop has been installed."
    ;;
    2)
    echo "OK, htop will not be installed."
    ;;
    *)
    echo "OK, htop will not be installed."
    ;;
esac
echo ""

# Git
echo "Would you like to install git?"
echo ""
echo "Package : git"
echo "Description : the fast distributed version control system"
echo "Repository : Extra"
echo ""
echo "1) Yes"
echo "2) No (Default)"
echo ""
read git
echo ""

case "$git" in
    1)
    echo "OK, git will now be installed..."
    echo ""
    pacman -S git --needed --noconfirm
    echo ""
    echo "Done. Git has been installed."
    ;;
    2)
    echo "Git will not be installed."
    ;;
    *)
    echo "Git will not be installed."
    ;;
esac

# Neofetch
echo "Would you like to install neofetch?"
echo ""
echo "Package : neofetch"
echo "Description : A CLI system information tool written in BASH that supports displaying images."
echo "Repository : Community"
echo ""
echo "1) Yes"
echo "2) No (Default)"
echo ""
read neofetch
echo ""

case "$neofetch" in
    1)
    echo "OK, neofetch will now be installed..."
    echo ""
    pacman -S neofetch --needed --noconfirm
    echo ""
    echo "Done. Neofetch has been installed."
    ;;
    2)
    echo "Neofetch will not be installed."
    ;;
    *)
    echo "Neofetch will not be installed."
    ;;
esac
echo ""

# Firefox
echo "Would you like to install firefox?"
echo ""
echo "Package : firefox"
echo "Description : Standalone web browser from mozilla.org"
echo "Repository : Extra"
echo ""
echo "1) Yes"
echo "2) No (Default)"
echo ""
read firefox
echo ""

case "$firefox" in
    1)
    echo "OK, Firefox will now be installed..."
    echo ""
    pacman -S firefox --needed --noconfirm
    echo ""
    echo "Done. Firefox has been installed."
    ;;
    2)
    echo "OK, Firefox will not be installed."
    ;;
    *)
    echo "OK, Firefox will not be installed."
    ;;
esac
echo ""

# VLC
echo "Would you like to install vlc?"
echo ""
echo "Package : vlc"
echo "Description : Multi-platform MPEG VCD/DVD, and DivX player"
echo "Repository : Extra"
echo ""
echo "1) Yes"
echo "2) No (Default)"
echo ""
read vlc
echo ""

case "$vlc" in
    1)
    echo "OK, vlc will now be installed..."
    echo ""
    pacman -S vlc --needed --noconfirm
    echo ""
    echo "Done. VLC has been installed."
    ;;
    2)
    echo "OK, vlc will not be installed."
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
echo "1) Yes"
echo "2) No (Default)"
echo ""
read kdeconnect
echo ""

case "$kdeconnect" in
    1)
    echo "OK, KDE Connect will now be installed..."
    echo ""
    pacman -S kdeconnect --needed --noconfirm
    echo ""
    echo "Done. KDE Connect has been installed."
    ;;
    2)
    echo "OK, KDE Connect will not be installed."
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
echo "1) Yes"
echo "2) No (Default)"
echo ""
read gimp
echo ""

case "$gimp" in
    1)
    echo "OK, GIMP will now be installed..."
    echo ""
    pacman -S gimp --needed --noconfirm
    echo ""
    echo "Done. GIMP has been installed."
    ;;
    2)
    echo "OK, GIMP will not be installed."
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
    echo "OK, QEMU and Virt-Manager will now be installed..."
    echo ""
    pacman -S qemu-base virt-manager dnsmasq iptables-nft --needed
    systemctl enable libvirtd.service
    echo ""
    echo "Done. QEMU and Virt-Manager has been installed."
    echo "The libvirt service has been enabled."
    ;;
    2)
    echo "OK, QEMU and Virt-Manager will not be installed."
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
    echo "OK, RetroArch will now be installed..."
    echo ""
    pacman -S retroarch libretro-core-info --needed --noconfirm
    echo ""
    echo "Done. RetroArch has been installed."
    ;;
    2)
    echo "OK, RetroArch will not be installed."
    ;;
    *)
    echo "OK, RetroArch will not be installed."
    ;;
esac
echo ""
