#!/bin/sh

echo "+-------+"
echo "| SETUP |"
echo "+-------+"
echo ""
echo "We are now in the chroot envrionment"
echo ""

echo "+--------------------+"
echo "| PARALLEL DOWNLOADS |"
echo "+--------------------+"
echo ""

# Ask if the user wants to enable parallel downloads

echo "Do you want to enable parallel downloads and increase to 20?"
echo "This will allow for packages to be downloaded simultaneously."
echo ""
echo "1) No - Do not enable parallel downloads (Default)"
echo "2) Yes - Enable parallel downloads"
echo ""
read paralleldownloads
echo ""

case "$paralleldownloads" in

    1) # Yes - Enable parallel downloads

    echo "OK. Parallel downloads will not be enabled"

    ;;

    2) # No - Do not enable parallel downloads

    sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 20/' /etc/pacman.conf # Uncomment Parallel Downloads and change value from 5 to 20
    echo "Done. Parallel downloads have been enabled and increased to 20."

    ;;

    *) # Default option

    echo "OK. Parallel downloads will not be enabled"

    ;;

esac
echo ""

echo "+---------------------+"
echo "| MULTILIB REPOSITORY |"
echo "+---------------------+"
echo ""

# Ask if the user wants to enable multilib repo

echo "Do you want to enable the multilib repository?"
echo "This will be needed if you want access to 32-bit applications (such as Steam)"
echo ""
echo "1) No - Do not enable the multilib repository (Default)"
echo "2) Yes - Enable the multilib repository"
echo ""
read multilib
echo ""

case "$multilib" in

    1) # Yes - Enable the multilib repository

    echo "OK. The multilib repository will not be enabled"

    ;;

    2) # No - Do not enable the multilib repository

    sed -i '93,94s/^#//' /etc/pacman.conf # Uncomment [multilib] header (line 93) and repo address (line 94)
    echo "The multilib repository has been enabled."

    ;;

    *) # Default option

    echo "OK. The multilib repository will not be enabled"

    ;;

esac
echo ""

echo "+----------------------+"
echo "| TESTING REPOSITORIES |"
echo "+----------------------+"
echo ""

echo "-------"
echo "Testing"
echo "-------"
echo ""

# Ask if the user wants to enable testing repo

echo "Do you want to enable the testing repository?"
echo "This repository has beta packages and intended to be used by advanced users only"
echo ""
echo "1) No - Do not enable the testing repository (Default)"
echo "2) Yes - Enable the testing repository"
echo ""
read testing
echo ""

case "$testing" in

    1) # Yes - Enable the testing repository

    echo "OK. The testing repository will not be enabled"

    ;;

    2) # No - Do not enable the testing repository

    sed -i '72,73s/^#//' /etc/pacman.conf # Uncomment [testing] header (line 72) and repo address (line 73)

    echo "The testing repository has been enabled."

    ;;

    *) # Default option

    echo "OK. The testing repository will not be enabled"

    ;;

esac
echo ""

echo "-----------------"
echo "Community-Testing"
echo "-----------------"
echo ""

# Ask if the user wants to enable community-testing repo

echo "Do you want to enable the community-testing repository?"
echo "This repository has user-submitted beta packages and intended to be used by advanced users only"
echo ""
echo "1) No - Do not enable the community-testing repository (Default)"
echo "2) Yes - Enable the community-testing repository"
echo ""
read communitytesting
echo ""

case "$commnitytesting" in

    1) # Yes - Enable the community-testing repository

    echo "OK. The community-testing repository will not be enabled"

    ;;

    2) # No - Do not enable the community-testing repository

    sed -i '81,82s/^#//' /etc/pacman.conf # Uncomment [community-testing] header (line 81) and repo address (line 82)
    echo "The community-testing repository has been enabled."

    ;;

    *) # Default option

    echo "OK. The community-testing repository will not be enabled"

    ;;

esac
echo ""

echo "----------------"
echo "Multilib-Testing"
echo "----------------"
echo ""

# Ask if the user wants to enable multilib-testing repo
echo "Do you want to enable the multilib-testing repository?"
echo "This repository has 32-bit beta packages and intended to be used by advanced users only"
echo ""
echo "1) No - Do not enable the multilib-testing repository (Default)"
echo "2) Yes - Enable the multilib-testing repository"
echo ""
read multilibtesting
echo ""

case "$multilibtesting" in

    1) # Yes - Enable multilib-testing repository

    echo "OK. The multilib-testing repository will not be enabled"

    ;;

    2) # No - Do not enable the multilib-testing repository

    sed -i '90,91s/^#//' /etc/pacman.conf # Uncomment [multilib-testing] header (line 90) and repo address (line 91)
    echo "The multilib-testing repository has been enabled."

    ;;

    *) # Default option

    echo "OK. The multilib-testing repository will not be enabled"

    ;;

esac
echo ""

echo "+-------------------+"
echo "| REFRESH DATABASES |"
echo "+-------------------+"
echo ""

pacman -Sy
echo ""
echo "The repository databases have been refreshed."
echo ""

echo "+----------+"
echo "| TIMEZONE |"
echo "+----------+"
echo ""

ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime
echo "Done. The system timezone has been set to Canada/Eastern (EST)."
echo ""

echo "+--------------+"
echo "| LOCALIZATION |"
echo "+--------------+"
echo ""

sed -i '177s/^#//' /etc/locale.gen # Uncomment en_US.UTF-8 UTF-8 (line 177) in locale.gen  
echo "LANG=en_US.UTF-8" > /etc/locale.conf # Set system locale
locale-gen # Generate locale
echo ""
echo "Done. The system language has been set to American English."
echo ""

echo "+-----------------------+"
echo "| NETWORK CONFIGURATION |"
echo "+-----------------------+"
echo ""
echo "Let's set up your internet connection..."
echo ""

# Set the hostname

echo "What will the pc's hostname be?"
echo ""
read hostname # Ask for hostname
echo $hostname > /etc/hostname # Set the hostname
echo -e 127.0.0.1'\t'localhost'\n'::1'\t\t'localhost'\n'127.0.1.1'\t'$hostname >> /etc/hosts # Create /etc/host file
echo ""
echo "Done. The hostname has been set to $hostname."

# Download network-manager

echo "We will now download and install the necessary packages to configure your network."
echo ""
pacman -S networkmanager --needed --noconfirm
systemctl enable NetworkManager.service
echo ""
echo "Done. The necessary packages have been installed. Your internet connection has been confirgured."
echo ""

echo "+---------------------+"
echo "| SYSTEM OPTIMIZATION |"
echo "+---------------------+"
echo ""

# Ask if the user would like to set up swap space

echo "Your system's memory information"
echo ""
free -h -g
echo ""
echo "Would you like to create swap space?"
echo "NOTE : Swap space is *HIGHLY* recommended"
echo ""
echo "1) No - Do not create swap space (Default)"
echo "2) Yes - Create swap space (zram)"

echo ""
read swap
echo ""

case "$swap" in

    1) # Yes - Create swap space (zram)

    echo "Ok. No swap space will be created."

    ;;

    2) # No - Do not creat e swap space

    # Ask the user for the desired swap size

    echo "+---------------+-----------+"
    echo "| Recommended Swap Size     |"
    echo "+---------------+-----------+"
    echo "| RAM Size      | Swap Size |"
    echo "+---------------+-----------+"
    echo "| Less than 2GB | RAM x2    |"
    echo "| 2GB-8GB       | RAM       |"
    echo "| More than 8GB | RAM x0.5  |"
    echo "+---------------+-----------+"
    echo ""
    echo "How much swap space would you like to allocate?
    Ex. Enter 4G to allocate 4GB of swap space"
    echo ""
    read swapsize
    echo ""
    echo "OK. $swapsize will be allocated to zram swap."
    echo ""

    # Create zram module

    mkdir -p /etc/modules-load.d
    touch /etc/modules-load.d/zram.conf
    echo "zram" > /etc/modules-load.d/zram.conf
    echo "Zram moldule has been enabled."

    # Define the number of zram modules

    mkdir -p /etc/modprobe.d/
    touch /etc/modprobe.d/zram.conf
    echo "options zram num_devices=1" > /etc/modprobe.d/zram.conf
    echo "The number of zram module(s) has been set to 1."

    # Define the zram size using a udev rule

    mkdir -p /etc/udev/rules.d/
    touch /etc/udev/rules.d/99-zram.rules
    echo "KERNEL==\"zram0\",ATTR{disksize}=\"$swapsize\" RUN=\"/usr/bin/mkswap /dev/zram0\",TAG+=\"systemd\"" > /etc/udev/rules.d/99-zram.rules
    echo "Zram udev rule has been created."

    # Create Systemd unit file

    mkdir -p /etc/systemd/system/
    touch /etc/systemd/system/zram.service
    echo -e [Unit]'\n'Description=Swap with zram'\n'After=multi-user.target'\n\n'[Service]'\n'Type=oneshot'\n'RemainAfterExit=true'\n'ExecStartPre=/sbin/mkswap /dev/zram0'\n'ExecStart=/sbin/swapon /dev/zram0'\n'ExecStop=/sbin/swapoff /dev/zram0'\n\n'[Install]'\n'WantedBy=multi-user.target >> /etc/systemd/system/zram.service
    echo "Systemd unit file has been created."

    # Enable zram

    echo ""
    systemctl enable zram.service
    echo ""
    echo "Done. $swapsize has been allocated to zram swap."
    echo ""

    ;;

    *) # Default option

    echo "Ok. No swap space will be created."

    ;;

esac
echo ""

# Ask if the user wants to start Fstrim for SSDs

echo "Do you want to enable to FSTrim service?"
echo "This is HIGHLY recommended if you are using an SSD"
echo ""
echo "1) No - Do not enable FSTrim service (Default)"
echo "2) Yes - Enable FSTrim service"
echo ""
read fstrim
echo ""

case "$fstrim" in

    1) # Yes - Enable FSTrim service

    echo "OK. The FSTrim service will be not started"

    ;;

    2) # No - Do not enable FSTrim service

    systemctl enable fstrim.timer
    echo ""
    echo "OK. The FSTrim service has been started"

    ;;

    *) # Default option

    echo "OK. The FSTrim service will be not started"

    ;;

esac
echo ""

echo "+---------------+"
echo "| USER ACCOUNTS |"
echo "+---------------+"
echo ""

echo "+--------------+"
echo "| ROOT ACCOUNT |"
echo "+--------------+"
echo ""

# Ask if the user wants to set a root password

echo "Do you want to set a password for the root account?"
echo "Not setting a password for the root account will disable it"
echo ""
echo "** NOTE : Disabling the root account is not recommended as it"
echo "will be needed for troubleshooting your system **"
echo ""
echo "1) Yes - Set a password (Default)"
echo "2) No - Disable root account"
echo ""
read rootaccount
echo ""

case "$rootaccount" in

    1) # Yes - Set a password

    echo "Let's set the password for the root account."
    echo ""
    passwd
    echo ""
    echo "Done. The root account has been enabled and the password has been set"

    ;;

    2) # No - Disable root account

    echo "OK, the root account will be disabled."

    ;;

    *) # Default option

    echo "Let's set the password for the root account."
    echo ""
    passwd
    echo ""
    echo "Done. The root account has been enabled and the password has been set"

    ;;

esac
echo ""

echo "+-------------------+"
echo "| SUPERUSER ACCOUNT |"
echo "+-------------------+"
echo ""

# Create A Superuser

echo "Let's create a superuser"
echo ""
echo "What will the name of your user account be?"
read username  # Ask for account name
useradd -m $username # Create a new account with chosen username and a home directory for the new user
echo ""
echo "Let's set the password for $username."
passwd $username # Set the password
echo ""
usermod -aG wheel $username # Add the user to the wheel group
sed -i '85s/^#//' /etc/sudoers # Enable wheel group members to execute commands
echo "$username has been created and added to the wheel group."

# Ask for user shell
echo "What shell should $username use?"
echo ""
echo "1) Bash (Bourne Again Shell) (Default)"
echo "2) Zsh (Z-Shell)"
echo "3) Fish (Friendly Interactive Shell)"
echo ""
read userShell
echo ""

case "$userShell" in

    1) # Bash

    echo "OK $username will use Bash as their default shell."

    ;;

    2) # Zsh

    echo "OK. $username's shell will be changed to Zsh."
    echo ""
    pacman -S zsh --needed --noconfirm
    echo ""
    chsh -s /bin/zsh $username
    echo ""
    echo "OK $username now uses Zsh as their default shell."

    ;;

    3) # Fish

    echo "OK. $username's shell will be changed to Fish."
    echo ""
    pacman -S fish --needed --noconfirm
    echo ""
    chsh -s /bin/fish $username
    echo ""
    echo "OK $username now uses Fish as their default shell."

    ;;

    *) # Default option

    echo "OK $username will use Bash as their default shell."

    ;;

esac
echo ""

echo "+---------------+"
echo "| VIDEO DRIVERS |"
echo "+---------------+"
echo ""

# Ask user for video drivers to install

echo "What video drivers would you like to use?"
echo ""
echo "1) None (Default)"
echo "2) AMD/ATI (Open-source)"
echo "3) Intel (Open-source)"
echo "4) nVidia (Open-source)"
echo "5) nVidia (Proprietary)"
echo "6) VMWare / VirtualBox / QEMU"
echo ""
read gpuName
echo ""

case "$gpuName" in

    1) # None

    echo "OK. No video drivers will be installed."

    ;;

    2) # AMD/ATI

    echo "OK. The AMD/ATI (Open-source) drivers will be installed."
    echo ""
    pacman -S mesa xf86-video-amdgpu xf86-video-ati libva-mesa-driver vulkan-radeon --needed --noconfirm
    echo ""
    echo "Done. The AMD/ATI (Open-source drivers have been installed."

    ;;

    3) # Intel

    echo "OK. The Intel (Open-source) drivers will be installed."
    echo ""
    pacman -S mesa xf86-video-intel lbva-mesa-driver vulkan-intel --needed --noconfirm
    echo ""
    echo "Done. The Intel (Open-source) drivers have been installed."

    ;;

    4) # nVidia (Open-source)

    echo "OK. The nVidia (Open-source) drivers will be installed."
    echo ""
    pacman -S mesa xf86-video-nouveau libva-mesa-driver --needed --noconfirm
    echo ""
    echo "Done. The nVidia (Open-source) drivers have been installed."

    ;;

    5) # nVidia (Proprietary)

    echo "OK. The nVidia (Proprietary) drivers will be installed."
    echo ""
    pacman -S nvidia --needed --confirm
    echo ""
    echo "Done. The nVidia (Proprietary) drivers have been installed."

    ;;

    6) # VMWare / Virtualbox / QEMU

    echo "OK. The VMWare / Virtualbox / QEMU drivers will be installed."
    echo ""
    pacman -S xf86-video-vmware spice-vdagent --needed --noconfirm
    echo ""
    echo "Done. The VMWare / Virtualbox / QEMU drivers have been installed."

    ;;

    *) # Default option

    echo "OK. No video drivers will be installed."

    ;;

esac
echo ""

echo "+--------------+"
echo "| AUDIO SERVER |"
echo "+--------------+"
echo ""

# Ask user for audio server to install

echo "What audio server would you like to use?"
echo ""
echo "1) None (Default)"
echo "2) PulseAudio"
echo "3) Pipewire"
echo ""
read audioName
echo ""

case "$audioName" in

    1) # None

    echo "OK. No audio server will be installed."

    ;;

    2) # PulseAudio

    echo "OK. PulseAudio will be installed."
    echo ""
    pacman -S pulseaudio pavucontrol pulseaudio-alsa pulseaudio-jack --needed --noconfirm
    echo ""
    echo "Done. PulseAudio has been installed."

    ;;

    3) # Pipewire

    echo "OK. Pipewire will be installed."
    echo ""
    pacman -S pipewire wireplumber pipewire-pulse pipewire-alsa pipewire-jack gst-plugin-pipewire --needed --noconfirm
    echo ""
    echo "Done. Pipewire has been installed."

    ;;

    *) # Default option

    echo "OK. No audio server will be installed."

    ;;

esac
echo ""

echo "+----------+"
echo "| PRINTERS |"
echo "+----------+"
echo ""

# Ask if the user wants to install printer drivers

echo "Would you like to install the gutenprint and ghostscript packages?"
echo "These will aid in setting up any required printers."
echo ""
echo "Package : gutenprint"
echo "Description : Top quality printer drivers for POSIX systems"
echo "Repository : Extra"
echo ""
echo "Package : ghostscript"
echo "Description : An interpreter for the PostScript language"
echo "Repository : Extra"
echo ""
echo "1) No (Default)"
echo "2) Yes"
echo ""
read printer
echo ""

case "$printer" in

    1) # No

    echo "OK. The gutenprint and ghostscript packages will not be installed."

    ;;

    2) # Yes

    echo "OK. The gutenprint and ghostscript packages will now be installed."
    echo ""
    pacman -S gutenprint ghostscript --noconfirm
    sudo systemctl enable cups.service
    echo ""
    echo "Done. The gutenprint and ghostscript packages has been installed."
    echo "The CUPS Printer service has been started"

    ;;

    *) # Default option

    echo "OK. The gutenprint and ghostscript packages will not be installed."

    ;;

esac
echo ""

echo "+---------+"
echo "| DESKTOP |"
echo "+---------+"
echo ""

# Ask if the user would like to install a desktop environment or a window manager

echo "Would you like to install one of the desktop environment or a window manager profiles?"
echo ""
echo "1) None (Default)"
echo "2) Desktop Environment"
echo "3) Window Manager"
echo ""
read desktop
echo ""

case "$desktop" in

    1) # None

    echo "OK. No desktop environment or window manager will be installed."

    ;;

    2) # Desktop Environments

    # Credit : These profiles were copied from archinstall profiles and modified accordingly
    # The original profiles can be found here : https://gitlab.archlinux.org/archlinux/archinstall/-/tree/master/profiles

    # Additions/Changes

    # All - added network-manager-applet to all profiles for easier internet configuration after first boot

    # Plasma - added print-manager as Plasma doesn't have a printer section in Settings by default

    echo "--------------------"
    echo "Desktop Environments"
    echo "--------------------"
    echo ""

    # Ask user for which desktop environment to install

    echo "What desktop environment would you like to install?"
    echo ""
    echo "1) None (Default)"
    echo "2) Budgie"
    echo "3) Cinnamon"
    echo "4) Cutefish"
    echo "5) Deepin"
    echo "6) Enlightenment"
    echo "7) Gnome"
    echo "8) LXQT"
    echo "9) Mate"
    echo "10) Plasma"
    echo "11) XFCE"
    echo ""
    read desktop
    echo ""

    case "$desktop" in

        1) # None

        echo "OK. No desktop environment will be installed."

        ;;

        2) # Budgie

        echo "OK. The Budgie desktop will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit budgie-desktop gnome lightdm lightdm-gtk-greeter network-manager-applet --needed --noconfirm;systemctl enable lightdm.service
        echo ""
        echo "Done. The Budgie desktop has been installed."

        ;;

        3) # Cinnamon

        echo "OK. The Cinnamon desktop will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit cinnamon system-config-printer gnome-keyring gnome-terminal blueberry metacity lightdm lightdm-gtk-greeter network-manager-applet --needed --noconfirm;systemctl enable lightdm.service
        echo ""
        echo "Done. The Cinnamon desktop has been installed."

        ;;

        4) # Cutefish

        echo "OK. The Cutefish desktop will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit cutefish noto-fonts sddm cutefish-terminal network-manager-applet --needed --noconfirm;systemctl enable sddm.service
        echo ""
        echo "Done. The Cutefish desktop has been installed."

        ;;

        5) # Deepin

        echo "OK. The Deepin desktop will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit deepin deepin-terminal deepin-editor lightdm lightdm-gtk-greeter network-manager-applet --needed --noconfirm;systemctl enable lightdm.service
        echo ""
        echo "Done. The Deepin desktop has been installed."

        ;;

        6) # Enlightenment

        echo "OK. The Enlightenment desktop will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit enlightenment terminology lightdm lightdm-gtk-greeter network-manager-applet --needed --noconfirm;systemctl enable lightdm.service
        echo ""
        echo "Done. The Enlightenment desktop has been installed."

        ;;

        7) # GNOME

        echo "OK. The GNOME desktop will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit gnome gnome-tweaks gdm network-manager-applet --needed --noconfirm;systemctl enable gdm.service
        echo ""
        echo "Done. The GNOME desktop has been installed."

        ;;

        8) # LXQT

        echo "OK. The LXQT desktop will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit lxqt breeze-icons oxygen-icons xdg-utils ttf-freefont leafpad slock sddm --needed --noconfirm;systemctl enable sddm.service
        echo ""
        echo "Done. The LXQT desktop has been installed."

        ;;

        9) # Mate

        echo "OK. The Mate desktop will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit mate mate-extra lightdm lightdm-gtk-greeter --needed --noconfirm;systemctl enable lightdm.service
        echo ""
        echo "Done. The Mate desktop has been installed."
        ;;

        10) # Plasma

        echo "OK. The Plasma desktop will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit plasma-meta plasma-wayland-session konsole kwrite dolphin ark sddm egl-wayland print-manager network-manager-applet --needed --noconfirm;systemctl enable sddm.service
        echo ""
        echo "Done. The Plasma desktop has been installed."

        ;;

        11) # XFCE

        echo "OK. The XFCE desktop will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit xfce4 xfce4-goodies pavucontrol gvfs xarchiver lightdm lightdm-gtk-greeter network-manager-applet --needed --noconfirm;systemctl enable lightdm.service
        echo ""
        echo "Done. The XFCE desktop has been installed."

        ;;

        *) # Default option

        echo "OK. No desktop environment will be installed."

        ;;

    esac

    ;;

    3) # Window Managers

    # Credit : These profiles were copied from archinstall profiles and modified accordingly
    # The original profiles can be found here : https://gitlab.archlinux.org/archlinux/archinstall/-/tree/master/profiles

    # Additions/Changes

    # All
    # Swapped in alacritty as the default terminal for all profiles except for BSPWM

    # Awesome
    # lightdm and lightdm-gtk-greeter were added as Awesome WM does not come with a login manager by default
        # Added so the user doesn't have to use startx to start the WM
    # feh was swapped out for nitrogen as a more user-friendly option for setting wallpapers

    echo "+-----------------+"
    echo "| WINDOW MANAGERS |"
    echo "+-----------------+"
    echo ""

    # Ask user for which window manager to install

    echo "What window manager would you like to install?"
    echo ""
    echo "1) None (Default)"
    echo "2) Awesome"
    echo "3) BSPWM"
    echo "4) i3"
    echo "5) Qtile"
    echo "6) Sway"
    echo ""
    read window_manager
    echo ""

    case "$window_manager" in

        1) # None

        echo "OK. No window manager will be installed."

        ;;

        2) # Awesome

        echo "OK. The Awesome window manager will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit awesome xorg-xrandr alacritty nitrogen slock terminus-font gnu-free-fonts ttf-liberation xsel lightdm lightdm-gtk-greeter --needed --noconfirm;systemctl enable lightdm.service
        echo ""
        echo "The Awesome window manager has been installed."

        ;;

        3) # BSPWM

        echo "OK. The BSPWM window manager will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit bspwm sxhkd dmenu xdo rxvt-unicode lightdm light-gtk-greeter --needed --noconfirm;systemctl enable lightdm.service
        echo ""
        echo "The BSPWM window manager has been installed."

        ;;

        4) # i3

        # Ask the user which version of i3 to install

        echo "Which version of i3 would you like to install?"
        echo ""
        echo "1) i3-wm (Default)"
        echo "2) i3-gaps"
        echo ""
        read i3
        echo ""

            # Install chosen version of i3

            case "i3" in

                1) # i3-wm

                echo "OK. The i3 window manager will be installed."
                echo ""
                pacman -S xorg-server xorg-xinit i3-wm i3lock i3status i3blocks alacritty dmenu lightdm lightdm-gtk-greeter --needed --noconfirm;systemctl enable lightdm.service
                echo ""
                echo "The i3 window manager has been installed."

                ;;

                2) # i3-gaps

                echo "OK. The i3-gaps window manager will be installed."
                echo ""
                pacman -S xorg-server xorg-xinit i3-gaps i3lock i3status i3blocks alacritty dmenu lightdm lightdm-gtk-greeter  --needed --noconfirmsystemctl enable lightdm.service
                echo ""
                echo "The i3-gaps window manager has been installed."

                ;;

                *) # Default option

                echo "OK. The i3 window manager will be installed."
                echo ""
                pacman -S xorg-server xorg-xinit i3-wm i3lock i3status i3blocks alacritty dmenu lightdm lightdm-gtk-greeter --needed --noconfirm;systemctl enable lightdm.service
                echo ""
                echo "The i3 window manager has been installed."

                ;;

            esac

        ;;

        5) # Qtile

        echo "OK. The Qtile window manager will be installed."
        echo ""
        pacman -S xorg-server xorg-xinit qtile alactritty lightdm lightdm-gtk-greeter --needed --noconfirm;systemctl enable lightdm.service
        echo ""
        echo "The Qtile window manager has been installed."

        ;;

        6) # Sway

        echo "OK. The Sway window manager will be installed."
        echo ""
        pacman -S sway swaylock swayidle waybar dmenu light grim slurp pavucontrol foot --needed --noconfirm
        echo ""
        echo "The Sway window manager has been installed."

        ;;

        *) # Default option

        echo "OK. No window manager will be installed."

        ;;

    esac

    ;;

    *) # Default option

    echo "OK. No desktop environment or window manager will be installed."

    ;;

esac
echo ""

echo "+-------------------+"
echo "| BOOTLOADER (GRUB) |"
echo "+-------------------+"
echo ""
echo "Let's download the microcode package for your CPU as well as the necessary packages to install the bootloader."
echo ""

# Ask for CPU brand and download required packages

echo "What brand of CPU do you have?"
echo ""
echo "1) AMD"
echo "2) Intel"
echo ""
read cpuName
echo ""

case "$cpuName" in

    1) # AMD

    echo "OK. The required packages will now be downloaded and installed."
    echo ""
    pacman -S grub efibootmgr amd-ucode --needed --noconfirm
    echo ""
    echo "Done. The required packages have been downloaded and installed."

    ;;

    2) # Intel

    echo "OK. The required packages will now be downloaded and installed."
    echo ""
    pacman -S grub efibootmgr intel-ucode --needed --noconfirm
    echo ""
    echo "Done. The required packages have been downloaded and installed."

    ;;

    *) # Default option (no microcode)

    echo "OK. The required packages will now be downloaded and installed."
    echo ""
    pacman -S grub efibootmgr --needed --noconfirm
    echo ""
    echo "Done. The required packages have been downloaded and installed."

    ;;

esac
echo ""

# Install the bootloader

echo "We will now install GRUB as the bootloader."
echo ""
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi # Install GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo ""
echo "Done. GRUB has been installed as the bootlader."
echo ""

echo "+----------------------+"
echo "| STARTER APPLICATIONS |"
echo "+----------------------+"
echo ""

# Ask if the user wants to install a list of starter applications

echo "Do you want to install these start applications?"
echo ""
echo "Package : htop"
echo "Description : Interactive process viewer"
echo "Repository : Extra"
echo ""
echo "Package : git"
echo "Description : the fast distributed version control system"
echo "Repository : Extra"
echo ""
echo "Package : neofetch"
echo "Description : A CLI system information tool written in BASH that supports displaying images."
echo "Repository : Community"
echo ""
echo "Package : firefox"
echo "Description : Standalone web browser from mozilla.org"
echo "Repository : Extra"
echo ""
echo "1) No - Do not install any starter applications (Default)"
echo "2) Yes - Install ALL starter applications"
echo "3) Let me choose what to install"
echo ""
read starter_apps
echo ""

case "$starter_apps" in

    1) # No - Do not install any starter applications
    
    echo "OK, the starter applications will not be installed."
    
    ;;
    
    2) # Yes - Install ALL starter applications
    
    echo "OK, the starter applications will now be installed."
    echo ""
    pacman -S htop git neofetch firefox --needed --noconfirm
    echo ""
    echo "Done. The starter applications have been installed."
    
    ;;
    
    3) # Let me choose what to install
    
        echo "Would you like to install htop?"
        echo ""
        echo "Package : htop"
        echo "Description : Interactive process viewer"
        echo "Repository : Extra"
        echo ""
        echo "1) No (Default)"
        echo "2) Yes"
        echo ""
        read htop
        echo ""

        case "$htop" in
        
            1) # No
            
            echo "OK, htop will not be installed."
            
            ;;
        
            2) # Yes
            
            echo "OK, htop will now be installed..."
            echo ""
            pacman -S htop --needed --noconfirm
            echo ""
            echo "Done. Htop has been installed."
            
            ;;
            
            *) # Default option
            
            echo "OK, htop will not be installed."
            
            ;;
            
        esac
        echo ""
        
        echo "Would you like to install git?"
        echo ""
        echo "Package : git"
        echo "Description : the fast distributed version control system"
        echo "Repository : Extra"
        echo ""
        echo "1) No (Default)"
        echo "2) Yes"
        echo ""
        read git
        echo ""

        case "$git" in
        
            1) # No
            
            echo "Git will not be installed."
            
            ;;
            
            2) # Yes
            
            echo "OK, git will now be installed..."
            echo ""
            pacman -S git --needed --noconfirm
            echo ""
            echo "Done. Git has been installed."
            
            ;;
            
            *) # Default option
            
            echo "Git will not be installed."
            
            ;;
            
        esac        
    
        echo "Would you like to install neofetch?"
        echo ""
        echo "Package : neofetch"
        echo "Description : A CLI system information tool written in BASH that supports displaying images."
        echo "Repository : Community"
        echo ""
        echo "1) No (Default)"
        echo "2) Yes"
        echo ""
        read neofetch
        echo ""

        case "$neofetch" in
        
            1) # No
            
            echo "Neofetch will not be installed."
            
            ;;
        
            2) #Yes
        
            echo "OK, neofetch will now be installed..."
            echo ""
            pacman -S neofetch --needed --noconfirm
            echo ""
            echo "Done. Neofetch has been installed."
            
            ;;
            
            *) # Default option
            
            echo "Neofetch will not be installed."
            
            ;;
            
        esac
        echo ""    
    
        echo "Would you like to install firefox?"
        echo ""
        echo "Package : firefox"
        echo "Description : Standalone web browser from mozilla.org"
        echo "Repository : Extra"
        echo ""
        echo "1) No (Default)"
        echo "2) Yes"
        echo ""
        read firefox
        echo ""

        case "$firefox" in
        
            1) # No
            
            echo "OK, Firefox will not be installed."
            
            ;;
        
            2) # Yes
            
            echo "OK, Firefox will now be installed..."
            echo ""
            pacman -S firefox --needed --noconfirm
            echo ""
            echo "Done. Firefox has been installed."
            
            ;;
            
            *)
            
            echo "OK, Firefox will not be installed."
            
            ;;
            
        esac
    
    ;;
    
    *) #Default option

    echo "OK, the starter applications will not be installed."

    ;;
    
esac
echo ""

echo "+----------+"
echo "| FINISHED |"
echo "+----------+"
sleep 2;clear
