#!/bin/sh

# Check if the system is booted in UEFI mode

if [ ! -d "/sys/firmware/efi/efivars" ]
then
    # If not, then exit installer

    echo "[Error!] System is not booted in UEFI mode. Please boot in UEFI mode & try again."
    exit 9999
fi

# Update the system clock

timedatectl set-ntp true
clear

# Start screen (user initiated start)

echo "+----------------------------------------------------+"
echo "| A.L.I.B.I. - Arch Linux Interactive Bash Installer |"
echo "+----------------------------------------------------+"
echo ""

echo "This is an interactive install script written
to guide you in the installation of Arch Linux"
echo ""
echo "You will be guided through the following steps"
echo "- Preparing the disk"
echo "- Choosing a kernel and installing the base packages"
echo "- Setting up the base installation"
echo "- Choosing and installing a desktop enviroment"
echo "- Installing Various Apps"
echo ""
read -p "Press enter to begin the installation"
clear

echo "+------------------+"
echo "| DISK PREPARATION |"
echo "+------------------+"
echo ""

# Choose which device to use

fdisk -l
echo ""
echo "Which device will you be installing Arch Linux to?"
echo "WARNING : The selected drive will be wiped."
echo ""
read device
export device   # Set device as enviroment variable for disk format scripts
echo ""
echo "OK. $device will be used."
echo ""

echo "Which filesystem would you like to use?"
echo ""
echo "1) EXT (Default)"
echo "2) BTRFS"
echo ""
read filesystem
echo ""

case "$filesystem" in

    1) # EXT 4 option

    echo "+-------------------------+"
    echo "| DISK PREPARATION - EXT4 |"
    echo "+-------------------------+"
    echo ""

    # Ask if the user wants to use a seperate / and /home partition scheme

    echo "Would you like to use a seperate /home partition?"
    echo "1) Yes (Default)"
    echo "2) No"
    echo ""
    read homePart
    echo ""

    case "$homePart" in

        1) # Seperate home partition option

        echo "OK, A seperate /home partition will be used."
        echo ""

        # Ask the user for the root partition size
        echo "How big of a root partition (/) would you like to create?"
        echo "Ex. Enter +20G for a 20GB root partition"
        echo "NOTE : Don't forget the +"
        echo ""
        read rootsize
        echo ""
        echo "OK. The root partition will be $rootsize."
        echo ""

        # Create the partitions

        (echo g ; echo n ; echo "" ; echo "" ; echo +512M ; echo t ; echo 1 ; echo n ; echo "" ; echo "" ; echo "$rootsize" ; echo n ; echo "" ; echo "" ; echo "" ; echo w ) | fdisk -w always -W always $device  # Create partitions (See below for details)

            # -- echo g                 Create new GPT partition table
            # -- echo n                 Create new partition (boot).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo +512M             Set +512M as last sector.
            # -- echo t                 Change partition type.
            # -- echo 1                 Change first partition to EFI system.
            # -- echo n                 Create new partition (root).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo +rootsize         Set the last sector to user selected last sector.
            # -- echo n                 Create new partition (home).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo ""                Set default last sector (rest of the disk).
            # -- echo w                 Write changes.

        echo "Done. The boot, root, and home partitioons have been created."
        echo ""

        # Format the partitions

        fdisk -l
        echo ""
        echo "Which partition will be the boot/efi partition?"
        echo ""
        read boot
        echo ""
        mkfs.fat -F 32 -n "esp" $boot
        echo ""
        echo "$boot has been formatted to FAT32."
        echo ""

        fdisk -l
        echo ""
        echo "Which partition will be the root partition?"
        echo ""
        read root
        echo ""
        mkfs.ext4 -L "root" $root
        echo ""
        echo "$root has been formatted to EXT4."
        echo ""

        fdisk -l
        echo ""
        echo "Which partition will be the home partition?"
        echo ""
        read home
        echo ""
        mkfs.ext4 -L "home" $home
        echo ""
        echo "$home has been formatted to EXT4."
        echo ""

        # Mount the partitions

        mount $root /mnt
        echo "$root has been mounted to /mnt."

        mount --mkdir $home /mnt/home
        echo "$home has been mounted to /mnt/home."

        mount --mkdir $boot /mnt/boot/efi
        echo "$boot has been mounted to /mnt/boot/efi"
        echo ""
        lsblk -f

        ;;

        2) # No seperate home partition option

        echo "OK, A seperate /home partition will be not used."
        echo ""

        (echo g ; echo n ; echo "" ; echo "" ; echo +512M ; echo t ; echo 1 ; echo n ; echo "" ; echo "" ; echo "" ; echo w ) | fdisk -w always -W always $device # Create partitions (See below for details)

            # -- echo g                 Create new GPT partition table
            # -- echo n                 Create new partition (boot).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo +512M             Set +512M as last sector.
            # -- echo t                 Change partition type.
            # -- echo 1                 Change first partition to EFI system.
            # -- echo n                 Create new partition (root).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo ""                Set default last sector (100% usage).
            # -- echo w                 Write changes.

        echo "Done. The boot and root partitions have been created."
        echo ""

        # Format the partitions

        fdisk -l
        echo ""
        echo "Which partition will be the boot/efi partition?"
        echo ""
        read boot
        echo ""
        mkfs.fat -F 32 -n "esp" $boot
        echo ""
        echo "$boot has been formatted to FAT32."
        echo ""

        fdisk -l
        echo ""
        echo "Which partition will be the root partition?"
        echo ""
        read root
        echo ""
        mkfs.ext4 -L "root" $root
        echo ""
        echo "$root has been formatted to EXT4."
        echo ""

        # Mount the partitions

        mount $root /mnt
        echo "$root has been mounted to /mnt."

        mount --mkdir $boot /mnt/boot/efi
        echo "$boot has been mounted to /mnt/boot/efi"
        echo ""
        lsblk -f

        ;;

        *) # Default option

        echo "OK, A seperate /home partition will be used."
        echo ""

        # Ask the user for the root partition size

        echo "How big of a root partition (/) would you like to create?"
        echo "Ex. Enter +20G for a 20GB root partition"
        echo "NOTE : Don't forget the +"
        echo ""
        read rootsize
        echo ""
        echo "OK. The root partition will be $rootsize."
        echo ""

        # Create the partitions

        (echo g ; echo n ; echo "" ; echo "" ; echo +512M ; echo t ; echo 1 ; echo n ; echo "" ; echo "" ; echo "$rootsize" ; echo n ; echo "" ; echo "" ; echo "" ; echo w ) | fdisk -w always -W always $device  # Create partitions (See below for details)

            # -- echo g                 Create new GPT partition table
            # -- echo n                 Create new partition (boot).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo +512M             Set +512M as last sector.
            # -- echo t                 Change partition type.
            # -- echo 1                 Change first partition to EFI system.
            # -- echo n                 Create new partition (root).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo +rootsize         Set the last sector to user selected last sector.
            # -- echo n                 Create new partition (home).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo ""                Set default last sector (rest of the disk).
            # -- echo w                 Write changes.

        echo "Done. The boot, root, and home partitioons have been created."
        echo ""

        # Format the partitions

        fdisk -l
        echo ""
        echo "Which partition will be the boot/efi partition?"
        echo ""
        read boot
        echo ""
        mkfs.fat -F 32 -n "esp" $boot
        echo ""
        echo "$boot has been formatted to FAT32."
        echo ""

        fdisk -l
        echo ""
        echo "Which partition will be the root partition?"
        echo ""
        read root
        echo ""
        mkfs.ext4 -L "root" $root
        echo ""
        echo "$root has been formatted to EXT4."
        echo ""

        fdisk -l
        echo ""
        echo "Which partition will be the home partition?"
        echo ""
        read home
        echo ""
        mkfs.ext4 -L "home" $home
        echo ""
        echo "$home has been formatted to EXT4."
        echo ""

        # Mount the partitions

        mount $root /mnt
        echo "$root has been mounted to /mnt."

        mount --mkdir $home /mnt/home
        echo "$home has been mounted to /mnt/home."

        mount --mkdir $boot /mnt/boot/efi
        echo "$boot has been mounted to /mnt/boot/efi"
        echo ""
        lsblk -f

        ;;

    esac

    ;;

    2) # BTRFS option

    echo "+--------------------------+"
    echo "| DISK PREPARATION - BTRFS |"
    echo "+--------------------------+"
    echo ""

    # Create partitions

    (echo g ; echo n ; echo "" ; echo "" ; echo +512M ; echo t ; echo 1 ; echo n ; echo "" ; echo "" ; echo "" ; echo w ) | fdisk -w always -W always $device

       # -- echo g                 Create new GPT partition table
       # -- echo n                 Create new partition (boot).
       # -- echo ""                Set default partition number.
       # -- echo ""                Set default first sector.
       # -- echo +512M             Set +512M as last sector.
       # -- echo t                 Change partition type.
       # -- echo 1                 Change first partition to EFI system.
       # -- echo n                 Create new partition (root).
       # -- echo ""                Set default partition number.
       # -- echo ""                Set default first sector.
       # -- echo ""                Set default last sector (100% usage).
       # -- echo w                 Write changes.

    echo "Done. The boot and root partitions have been created."
    echo ""

    # Format the partitions

    fdisk -l
    echo ""
    echo "Which partition will be the boot/efi partition?"
    echo ""
    read boot
    echo ""
    mkfs.fat -F 32 -n "esp" $boot
    echo ""
    echo "$boot has been formatted to FAT32."
    echo ""

    fdisk -l
    echo ""
    echo "Which partition will be the root partition?"
    echo ""
    read root
    echo ""
    mkfs.btrfs -L "root" $root
    echo ""
    echo "$root has been formatted to BTRFS."
    echo ""

    # Mount root partition

    mount $root /mnt

    # Create subvolumes
    # -- @ - This is the main root subvolume on top of which all subvolumes will be mounted.
    # -- @home - This is the home directory. This consists of most of your data including Desktop and Downloads.
    # -- @var - Contains logs, temp. files, caches, games, etc.
    # -- @.snapshots - Directory to store snapshots for snapper (Can exclude this if you plan on using Timeshift)

    # Ask the user for the @.snapshots subvolume creation

    echo "Do you want to create the @.snapshots subvolume?"
    echo "NOTE : This can be excluded if Timeshift will be used instead of Snapper as your preferred snapshot utility."
    echo "1) Yes (Default)"
    echo "2) No"
    echo ""
    echo -n "Enter choice : "; read snapsubvol
    echo ""

    case "$snapsubvol" in

        1) # Snapshot subvolume option

            echo "OK, The following subvolumes will be created..."
            echo ""
            echo "+----------------------------+"
            echo "| Subvolumes  | Mount Points |"
            echo "+----------------------------+"
            echo "| @           | /            |"
            echo "| @var        | /var         |"
            echo "| @.snapshots | /.snapshots  |"
            echo "| @home       | /home        |"
            echo "+----------------------------+"
            echo ""

            # Create subvolumes

            btrfs su cr /mnt/@
            btrfs su cr /mnt/@home
            btrfs su cr /mnt/@var
            btrfs su cr /mnt/@.snapshots
            echo "Subvolumes have been created"

            # Unmount root partition from /mnt and mount @ subvolume

            umount /mnt
            mount -o noatime,commit=120,compress=zstd,subvol=@ $root /mnt

            # Create mountpoints for subvolume

            mkdir -p /mnt/var
            mkdir -p /mnt/home
            mkdir -p /mnt/.snapshots
            echo "Subvolume mount points have been created"

            # Mount subvolumes
            # Btrfs options
              # -- noatime - No access time. Improves system performace by not writing time when thefile was accessed.
              # -- commit - Peridoic interval (in sec) in which data is synchronized to permanent storage.
              # -- compress - Choosing the algorithm for compress. I have set zstd as it has good compression level and speed.
              # -- space_cache - Enables kernel to know where block of free space is on a disk to enable it to write data immediately after file creation.
              # -- subvol - Choosing the subvol to mount.

            mount -o noatime,commit=120,compress=zstd,subvol=@home $root /mnt/home
            mount -o noatime,commit=120,compress=zstd,subvol=@var $root /mnt/var
            mount -o noatime,commit=120,compress=zstd,subvol=@.snapshots $root /mnt/.snapshots
            echo "Subvolumes have been mounted"
            echo ""
            btrfs su li /mnt
            echo ""

            # Mount boot partition

            mount --mkdir $boot /mnt/boot/efi
            echo "$boot has been mounted to /mnt/boot/efi"
            echo ""
            lsblk -f

        ;;

        2) # No snapshot subvolume option

            echo "OK, The following subvolumes will be created..."
            echo ""
            echo "+----------------------------+"
            echo "| Subvolumes  | Mount Points |"
            echo "+----------------------------+"
            echo "| @           | /            |"
            echo "| @var        | /var         |"
            echo "| @home       | /home        |"
            echo "+----------------------------+"
            echo ""

            # Create subvolumes

            btrfs su cr /mnt/@
            btrfs su cr /mnt/@home
            btrfs su cr /mnt/@var
            echo "Subvolumes have been created"

            # Unmount root partition from /mnt

            umount /mnt
            mount -o noatime,commit=120,compress=zstd,subvol=@ $root /mnt

            # Create mountpoints for subvolumes

            mkdir -p /mnt/var
            mkdir -p /mnt/home
            echo "Subvolume mount points have been created"

            # Mount subvolumes
            # Btrfs options
              # -- noatime - No access time. Improves system performace by not writing time when thefile was accessed.
              # -- commit - Peridoic interval (in sec) in which data is synchronized to permanent storage.
              # -- compress - Choosing the algorithm for compress. I have set zstd as it has good compression level and speed.
              # -- subvol - Choosing the subvol to mount.

            mount -o noatime,commit=120,compress=zstd,subvol=@home $root /mnt/home
            mount -o noatime,commit=120,compress=zstd,subvol=@var $root /mnt/var
            echo "Subvolumes have been mounted"
            echo ""
            btrfs su li /mnt
            echo ""

            # Mount boot partition

            mount --mkdir $boot /mnt/boot/efi
            echo "$boot has been mounted to /mnt/boot/efi"
            echo ""
            lsblk -f

        ;;

        *) # Default option

            echo "OK, The following subvolumes will be created..."
            echo ""
            echo "+----------------------------+"
            echo "| Subvolumes  | Mount Points |"
            echo "+----------------------------+"
            echo "| @           | /            |"
            echo "| @var        | /var         |"
            echo "| @.snapshots | /.snapshots  |"
            echo "| @home       | /home        |"
            echo "+----------------------------+"
            echo ""

            # Create subvolumes

            btrfs su cr /mnt/@
            btrfs su cr /mnt/@home
            btrfs su cr /mnt/@var
            btrfs su cr /mnt/@.snapshots
            echo "Subvolumes have been created"

            # Unmount root partition from /mnt and mount @ subvolume

            umount /mnt
            mount -o noatime,commit=120,compress=zstd,subvol=@ $root /mnt

            # Create mountpoints for subvolumes

            mkdir -p /mnt/var
            mkdir -p /mnt/home
            mkdir -p /mnt/.snapshots
            echo "Subvolume mount points have been created"

            # Mount subvolumes
            # Btrfs options
              # -- noatime - No access time. Improves system performace by not writing time when thefile was accessed.
              # -- commit - Peridoic interval (in sec) in which data is synchronized to permanent storage.
              # -- compress - Choosing the algorithm for compress. I have set zstd as it has good compression level and speed.
              # -- space_cache - Enables kernel to know where block of free space is on a disk to enable it to write data immediately after file creation.
              # -- subvol - Choosing the subvol to mount.

            mount -o noatime,commit=120,compress=zstd,subvol=@home $root /mnt/home
            mount -o noatime,commit=120,compress=zstd,subvol=@var $root /mnt/var
            mount -o noatime,commit=120,compress=zstd,subvol=@.snapshots $root /mnt/.snapshots
            echo "Subvolumes have been mounted"
            echo ""
            btrfs su li /mnt
            echo ""

            # Mount boot partition

            mount --mkdir $boot /mnt/boot/efi
            echo "$boot has been mounted to /mnt/boot/efi"
            echo ""
            lsblk -f

        ;;

    esac

    ;;

    *) # Default option

    echo "+-------------------------+"
    echo "| DISK PREPARATION - EXT4 |"
    echo "+-------------------------+"
    echo ""

    # Ask if the user wants to use a seperate / and /home partition scheme

    echo "Would you like to use a seperate /home partition?"
    echo "1) Yes (Default)"
    echo "2) No"
    echo ""
    read homePart
    echo ""

    case "$homePart" in

        1) # Seperate home partition option

        echo "OK, A seperate /home partition will be used."
        echo ""

        # Ask the user for the root partition size

        echo "How big of a root partition (/) would you like to create?"
        echo "Ex. Enter +20G for a 20GB root partition"
        echo "NOTE : Don't forget the +"
        echo ""
        read rootsize
        echo ""
        echo "OK. The root partition will be $rootsize."
        echo ""

        # Create the partitions

        (echo g ; echo n ; echo "" ; echo "" ; echo +512M ; echo t ; echo 1 ; echo n ; echo "" ; echo "" ; echo "$rootsize" ; echo n ; echo "" ; echo "" ; echo "" ; echo w ) | fdisk -w always -W always $device  # Create partitions (See below for details)

            # -- echo g                 Create new GPT partition table
            # -- echo n                 Create new partition (boot).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo +512M             Set +512M as last sector.
            # -- echo t                 Change partition type.
            # -- echo 1                 Change first partition to EFI system.
            # -- echo n                 Create new partition (root).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo +rootsize         Set the last sector to user selected last sector.
            # -- echo n                 Create new partition (home).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo ""                Set default last sector (rest of the disk).
            # -- echo w                 Write changes.

        echo "Done. The boot, root, and home partitioons have been created."
        echo ""

        # Format the partitions

        fdisk -l
        echo ""
        echo "Which partition will be the boot/efi partition?"
        echo ""
        read boot
        echo ""
        mkfs.fat -F 32 -n "esp" $boot
        echo ""
        echo "$boot has been formatted to FAT32."
        echo ""

        fdisk -l
        echo ""
        echo "Which partition will be the root partition?"
        echo ""
        read root
        echo ""
        mkfs.ext4 -L "root" $root
        echo ""
        echo "$root has been formatted to EXT4."
        echo ""

        fdisk -l
        echo ""
        echo "Which partition will be the home partition?"
        echo ""
        read home
        echo ""
        mkfs.ext4 -L "home" $home
        echo ""
        echo "$home has been formatted to EXT4."
        echo ""

        # Mount the partitions

        mount $root /mnt
        echo "$root has been mounted to /mnt."

        mount --mkdir $home /mnt/home
        echo "$home has been mounted to /mnt/home."

        mount --mkdir $boot /mnt/boot/efi
        echo "$boot has been mounted to /mnt/boot/efi"
        echo ""
        lsblk -f

        ;;

        2) # No seperate home partition option

        echo "OK, A seperate /home partition will be not used."
        echo ""

        (echo g ; echo n ; echo "" ; echo "" ; echo +512M ; echo t ; echo 1 ; echo n ; echo "" ; echo "" ; echo "" ; echo w ) | fdisk -w always -W always $device # Create partitions (See below for details)

            # -- echo g                 Create new GPT partition table
            # -- echo n                 Create new partition (boot).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo +512M             Set +512M as last sector.
            # -- echo t                 Change partition type.
            # -- echo 1                 Change first partition to EFI system.
            # -- echo n                 Create new partition (root).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo ""                Set default last sector (100% usage).
            # -- echo w                 Write changes.

        echo "Done. The boot and root partitions have been created."
        echo ""

        # Format the partitions

        fdisk -l
        echo ""
        echo "Which partition will be the boot/efi partition?"
        echo ""
        read boot
        echo ""
        mkfs.fat -F 32 -n "esp" $boot
        echo ""
        echo "$boot has been formatted to FAT32."
        echo ""

        fdisk -l
        echo ""
        echo "Which partition will be the root partition?"
        echo ""
        read root
        echo ""
        mkfs.ext4 -L "root" $root
        echo ""
        echo "$root has been formatted to EXT4."
        echo ""

        # Mount the partitions

        mount $root /mnt
        echo "$root has been mounted to /mnt."

        mount --mkdir $boot /mnt/boot/efi
        echo "$boot has been mounted to /mnt/boot/efi"
        echo ""
        lsblk -f

        ;;

        *) # Default option

        echo "OK, A seperate /home partition will be used."
        echo ""

        # Ask the user for the root partition size

        echo "How big of a root partition (/) would you like to create?"
        echo "Ex. Enter +20G for a 20GB root partition"
        echo "NOTE : Don't forget the +"
        echo ""
        read rootsize
        echo ""
        echo "OK. The root partition will be $rootsize."
        echo ""

        # Create the partitions

        (echo g ; echo n ; echo "" ; echo "" ; echo +512M ; echo t ; echo 1 ; echo n ; echo "" ; echo "" ; echo "$rootsize" ; echo n ; echo "" ; echo "" ; echo "" ; echo w ) | fdisk -w always -W always $device  # Create partitions (See below for details)

            # -- echo g                 Create new GPT partition table
            # -- echo n                 Create new partition (boot).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo +512M             Set +512M as last sector.
            # -- echo t                 Change partition type.
            # -- echo 1                 Change first partition to EFI system.
            # -- echo n                 Create new partition (root).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo +rootsize         Set the last sector to user selected last sector.
            # -- echo n                 Create new partition (home).
            # -- echo ""                Set default partition number.
            # -- echo ""                Set default first sector.
            # -- echo ""                Set default last sector (rest of the disk).
            # -- echo w                 Write changes.

        echo "Done. The boot, root, and home partitioons have been created."
        echo ""

        # Format the partitions

        fdisk -l
        echo ""
        echo "Which partition will be the boot/efi partition?"
        echo ""
        read boot
        echo ""
        mkfs.fat -F 32 -n "esp" $boot
        echo ""
        echo "$boot has been formatted to FAT32."
        echo ""

        fdisk -l
        echo ""
        echo "Which partition will be the root partition?"
        echo ""
        read root
        echo ""
        mkfs.ext4 -L "root" $root
        echo ""
        echo "$root has been formatted to EXT4."
        echo ""

        fdisk -l
        echo ""
        echo "Which partition will be the home partition?"
        echo ""
        read home
        echo ""
        mkfs.ext4 -L "home" $home
        echo ""
        echo "$home has been formatted to EXT4."
        echo ""

        # Mount the partitions

        mount $root /mnt
        echo "$root has been mounted to /mnt."

        mount --mkdir $home /mnt/home
        echo "$home has been mounted to /mnt/home."

        mount --mkdir $boot /mnt/boot/efi
        echo "$boot has been mounted to /mnt/boot/efi"
        echo ""
        lsblk -f

        ;;

    esac

    ;;

esac
echo ""

echo "+------------------+"
echo "| PRE-INSTALLATION |"
echo "+------------------+"
echo ""

# Enable parallel downloads

sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 20/' /etc/pacman.conf # Uncomment Parallel Downloads and change value from 5 to 20
echo "Parallel downloads have been enabled and increased to 20."
echo ""

# Obtain a fresh mirrorlist
    # --country = defines which countries mirrors are picked from
    # --latest = defines the number of most recently synchronized mirrors to save
    # --protocol = defines the website protocol each mirror shoould
    # --sort rate = sort the mirrorlist in order of download speed
    # --save = defines the location in which to save the new mirrorlist

echo "Please wait while a new mirrorlist is being generated."
echo ""
echo "Mirrors : Canada, US, Worldwide"
echo "# of Mirrors : 50"
echo "Protocol : http, https"
echo "Sort by : Speed"
echo "Save Location : /etc/pacman.d/mirrorlist"
reflector --country 'Canada,US, ' --latest 50 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist &>/dev/null # Hiding error message if any
echo ""
echo "A new list of mirrors has been generated."
echo ""

echo "+-------------------+"
echo "| BASE INSTALLATION |"
echo "+-------------------+"
echo ""

# Ask which kernel to use

echo "What kernel would you like to use?"
echo ""
echo "1) linux (Default)"
echo "2) linux-lts"
echo "3) linux-hardened"
echo "4) linux-zen"
echo ""
read kernelName
echo ""

# Install the base system
    # base = Minimal package set to define a basic Arch Linux installation
    # base-devel = Addition GNU utils not included in base package
    # linux firmware = Firmware files for Linux

case "$kernelName" in

   1) # Linux kernel

   echo "OK, The linux kernel will be installed."
   echo ""
   pacstrap /mnt base base-devel linux linux-firmware nano man-pages man-db
   echo ""

   ;;

   2) # Linux-lts kernel

   echo "OK, The linux-lts kernel will be installed."
   echo ""
   pacstrap /mnt base base-devel linux-lts linux-firmware nano man-pages man-db
   echo ""

   ;;

   3) # Linux-hardened kernel

   echo "OK, The linux kernel will be installed."
   echo ""
   pacstrap /mnt base base-devel linux-hardened linux-firmware nano man-pages man-db
   echo ""

   ;;

   4) # Linux-zen kernel

   echo "OK, The linux-zen kernel will be installed."
   echo ""
   pacstrap /mnt base base-devel linux-zen linux-firmware nano man-pages man-db
   echo ""

   ;;

   *) # Default option

   echo "OK, The linux kernel will be installed."
   echo ""
   pacstrap /mnt base base-devel linux linux-firmware nano man-pages man-db
   echo ""

   ;;

esac
echo "The base packages have been installed."
echo ""

# Download setup and post-install scripts and place them in the new root partition

echo "One moment while we download the setup script..."
echo ""
curl https://raw.githubusercontent.com/anhvo8836/personal/main/scripts/setup.sh > /mnt/setup.sh
echo ""

echo "One moment while we download the post-install script..."
echo ""
curl https://raw.githubusercontent.com/anhvo8836/personal/main/scripts/post-install.sh > /mnt/post-install.sh
echo ""

# Generate FSTab file

genfstab -U /mnt > /mnt/etc/fstab
echo "Fstab file has been created."
echo ""

# Change root into the new installation and run the setup script

echo "We will now configure the new installation."
sleep 2;clear
arch-chroot /mnt sh /setup.sh

# Remove setup script

rm /mnt/setup.sh

# Unmount all drives (surpressing all error messages)

umount /mnt;clear

# Ending prompt (user-initiated reboot)

echo "+----------------------------------------------------+"
echo "| A.L.I.B.I. - Arch Linux Interactive Bash Installer |"
echo "+----------------------------------------------------+"
echo ""

echo "Arch Linux has been installed and configured."
echo "Your system is ready to reboot."
echo "Remember to disconnect your installation media."
echo ""
echo "+--------------------------------------------------+"
echo "| Author : Anh Vo (https://github.com/anhvo8836)   |"
echo "| Script Language : Bash                           |"
echo "| Source Code : https://github.com/anhvo8836/alibi |"
echo "+--------------------------------------------------+"
echo ""
read -p "Press enter to reboot your system"
reboot
