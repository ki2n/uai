if [ "$1" = "inchroot" ]
then
	echo "If you see this text, you are now in your system (or chrooted)!"
	echo "Getting timezones ready..."
	sleep 1
	while true
	do
		clear
		echo "Listing all Zones"
		ls /usr/share/zoneinfo/
		echo -n "Please type your zone [EX America]: "
		read zonein
		if [ ! -d "/usr/share/zoneinfo/$zonein" ]
		then
			echo "ERROR: Please enter a valid zone"
			echo "Make sure you include the capital letters!"
			sleep 2
		else
			break
		fi
	done
	
	while true
	do
		clear
		echo "Listing all Zones"
		ls "/usr/share/zoneinfo/$zonein"
		echo -n "Please type your Subzone [EX New_York]: "
		read subin
		if [ ! -f "/usr/share/zoneinfo/$zonein/$subin" ]
		then
			echo "ERROR: Please enter a valid subzone"
			echo "Make sure you include the capital letters!"
			sleep 2
		else
			break
		fi
	done
	ln -sf /usr/share/zoneinfo/$zonein/$subin /etc/localtime
	echo ">>> Using hardware clock to generate..."
	hwclock --systohc
	echo "We are going to use nano again to edit the locale file!"
	echo "All you need to do is uncomment the line that contains your locale!"
	echo "For example: '#text', will become 'text' instead!"
	echo "Would you like to edit that file? [y/n]"
	read -rsn1 chck
	if [ "$chck" = "y" ]
	then
		nano /etc/locale.gen
	else
		echo "Skipping then... [not recommended]"
	fi
	echo "Generating the locale!"
	locale-gen
	clear
	echo "Note, use A-Z,'-' characters only."
	echo "Example hostname: archlinux-pc"
	echo ""
	echo -n "Please type your system hostname: "
	read hostnm
	echo "$hostnm" >> /etc/hostname
	echo ">>> Installing wifi drivers... [if you use ethernet it wont matter]"
	pacman -S dialog wpa_supplicant iw
	clear
	echo ">>> Setting root password"
	passwd
	echo ">>> Installing grub [please accept install]"
	pacman -S grub
	echo ">>> Installing grub onto $2"
	grub-install /dev/$2
	echo ">>> Generating grub file..."
	grub-mkconfig -o /boot/grub/grub.cfg
	clear
	echo "Hooray! You made it! :D. Your system is all ready for use... but, not entirely."
	echo "Now it is time for a post-install."
	echo "You are safe to reboot without doing a post install, which means"
	echo "You have to manually install your desktop environment, tools, and many more.."
	echo ""
	echo "The post install will:"
	echo "- Let you setup your user account"
	echo "- Install your favorite tools"
	echo "- Install a desktop environment/window manager"
	echo "- Some other post install thingies..."
	echo ""
	echo "A post install is totally recommended! Meaning you should do it"
	echo "-------------------------------------------"
	echo "  Press any key to enter the post install"
	read -rsn1
	clear
	echo "- Create your account -"
	echo "Please use characters a-z, A-Z, 1-9, and '-'."
	echo "Good username: bobthe-Cat0123"
	echo "BAD username: Bobby The Cat 42"
	echo ""
	echo -n "Please enter your username: "
	read usname
	useradd -m -s /bin/bash $usname
	passwd $usname
	echo "User $usname has been created!"
	echo "Putting user in sudoers file"
	echo "$usname ALL=(ALL) ALL" >> /etc/sudoers
	echo "User creation done..."
	clear
	echo "Desktop environments and window managers"
	echo "To select: Simply press the letter that you install, for example:"
	echo "Pressing 'g' installs the Gnome desktop environment"
	echo ""
	echo "g = Gnome"
	echo "k = KDE Plasma"
	echo "x = Xfce"
	echo "l = Lxde"
	echo "o = Openbox"
	echo "i = i3wm"
	echo "f = Fluxbox"
	echo "[g/k/x/l/o/i/f]?"
	read -rsn1 da
	if [ "$da" = "g" ]
	then
		echo "Installing gnome..."
		echo "Continue pressing enter to accept all dependencies"
		sleep 1
		pacman -S gnome gnome-extra terminator gdm
		echo "Note: Gnome-terminal is broken... use terminator"
		sleep 2
	elif [ "$da" = "k" ]
	then
		echo "Installing KDE Plasma..."
		echo "Continue pressing enter to accept all dependencies"
		sleep 1
		pacman -S plasma sddm
	elif [ "$da" = "x" ]
	then
		echo "Installing Xfce..."
		echo "Continue pressing enter to accept all dependencies"
		sleep 1
		pacman -S xfce4 xfce4-goodies
	elif [ "$da" = "l" ]
	then
		echo "Installing LXDE..."
		echo "Continue pressing enter to accept all dependencies"
		sleep 1
		pacman -S lxde lxde-common
	elif [ "$da" = "o" ]
	then
		echo "Note: Installing a window manager requires some experience..."
		sleep 1
		pacman -S openbox
	elif [ "$da" = "i" ]
	then
		echo "Note: Installing a window manager requires some experience..."
		sleep 1
		pacman -S i3
	elif [ "$da" = "f" ]
	then
		echo "Note: Installing a window manager requires some experience..."
		sleep 1
		pacman -S fluxbox
	else
		echo "You did not choose a valid de/wm, skipping!"
	fi
	echo "Installing extra stuff"
	pacman -S networkmanager
	pacman -S xorg xorg-server
	if [ "$da" = "g" ]
	then
		systemctl enable gdm
	elif [ "$da" = "k" ]
	then
		systemctl enable sddm
	else
		echo "Installing your display manager..."
		pacman -S lxdm
		systemctl enable lxdm
	fi
	systemctl enable NetworkManager
	pacman -S network-manager-applet
	systemctl enable nm-applet
	echo "Installing pulseaudio so you can hear the ocean... :D"
	pacman -S pulseaudio
	systemctl enable pulseaudio.socket
	pacman -S pa-applet
	systemctl enable pa-applet
	clear
	echo "Tool installation"
	echo "------------------"
	echo "Do you want firefox? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S firefox
	fi
	echo "Do you want chromium? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S chromium
	fi
	echo "Do you want kdenlive? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S kdenlive
	fi
	echo "Do you want Geany? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S geany
	fi
	echo "Do you want Geary for email? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S geary
	fi
	echo "Do you want yaourt for AUR [recommended]? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		echo "" >> /etc/pacman.conf
		echo "[archlinuxfr]" >> /etc/pacman.conf
		echo "SigLevel = Never" >> /etc/pacman.conf
		echo "Server = http://repo.archlinux.fr/$arch" >> /etc/pacman.conf
		pacman -Sy
		pacman -S yaourt
	fi
	echo "Do you want emacs? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S emacs
	fi
	echo "Do you want telegram? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S telegram-desktop
	fi
	echo "Do you want riot messenger? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S riot-desktop
	fi
	echo "Do you want libreoffice? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S libreoffice-fresh
	fi
	echo "Do you want hexchat? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S hexchat
	fi
	echo "Do you want simplescreenrecorder? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S simplescreenrecorder
	fi
	echo "Do you want OBS Studio? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S obs-studio
	fi
	echo "Do you want lmms? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S lmms
	fi
	echo "Do you want gimp? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S gimp
	fi
	echo "Do you want vlc? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S vlc
	fi
	echo "Do you want htop [term]? [y/n]"
	read -rsn1 chc
	if [ "$chc" = "y" ]
	then
		pacman -S htop
	fi
	echo "You are at the end of the line for packages."
	sleep 1
	clear
	echo "Hooray! :D"
	sleep 1
	echo "Your setup is done!"
	sleep 1
	echo "You have successfully installed arch linux onto your system!"
	sleep 1
	echo ""
	echo "Getting ready to reboot in 5 seconds!"
	sleep 1
	echo "4"
	sleep 1
	echo "3"
	sleep 1
	echo "2"
	sleep 1
	echo "1"
	sleep 1
	reboot
	exit
else
	clear
	echo "Welcome to ArchKick! v1.1"
	echo "-----------------------------------------------------"
	echo "ArchKick is made for making arch easier to install!"
	echo "It reduces the pain and time of installing arch linux"
	echo "with a simplified installer, it also provides extra"
	echo "settings like picking a desktop environment/window"
	echo "manager so you dont have to spend hours configuring"
	echo "things!"
	echo "-----------------------------------------------------"
	echo "            Press any key to continue"
	read -rsn1
	clear
	echo "Notice"
	echo "-----------------------------------------------------"
	echo "ArchKick isnt perfect, so just note these, PS, these"
	echo "are temporary and will be added in the future!"
	echo "  - You are to be using a legacy bios, not UEFI."
	echo "  - Only english keymap support, a fork would be"
	echo "    needed for multiple versions"
	echo "  - May not work for nvidia drivers"
	echo "  - May not work on all machines"
	echo "A try is worth of course, just be careful not to break"
	echo "Your whole system! This guy may nuke!"
	echo "-----------------------------------------------------"
	echo "             Press any key to continue"
	read -rsn1
	clear
	while true
	do
		echo "Do you use wifi or ethernet?  [w/e]"
		read -rsn1 chc
		if [ "$chc" = "w" ]
		then
			echo "Wifi selected. Running wifi-menu tool"
			wifi-menu
			break
		elif [ "$chc" = "e" ]
		then
			echo "Ethernet selected, no problem since it works out of the box!"
			break
		else
			clear
		fi
	done
	echo ">>> Updating system clock"
	timedatectl set-ntp true
	clear
	echo "= Partitioning ="
	echo "Showing all devices"
	lsblk
	echo "Please format your answer like this, sda, sdb, sdc, and so on..."
	echo "DO NOT INCLUDE THE /dev/ PART IN IT!"
	echo ""
	echo -n "Please enter your host system to install on [ex: sda, sdb, sdc]: "
	read partname
	echo -n "What number for /dev/$partname are you putting root on? [ex: 1, 2, 3]: "
	read partnum
	while true
	do
		echo "Are you going to use swap? [y/n]"
		read -rsn1 swapa
		if [ "$swapa" = "y" ]
		then
			echo -n "What number for /dev/$partname are you putting SWAP on? [ex: 1, 2, 3]: "
			read swapnum
			swap="on"
			break
		elif [ "$swapa" = "n" ]
		then
			echo "Swap will NOT be selected"
			swap="off"
			break
		else
			clear
		fi
	done
	echo "Opening cfdisk for ease of use!"
	echo "If you are unsure how to use it, you can always pull up"
	echo "A second device [ex, laptop] and see how to use it!"
	echo "REMEMBER to write the changes to disk once done!"
	echo ""
	echo "Summary"
	echo "- Root will be on $partname$partnum"
	echo "- Swap will be on $partname$swapnum"
	cfdisk /dev/$partname
	echo "Formatting root as ext4..."
	mkfs.ext4 /dev/$partname$partnum
	if [ "$swap" = "yes" ]
	then
		echo "Creating swap..."
		mkswap /dev/$partname$swapnum
		swapon /dev/$partname$swapnum
	fi
	mount /dev/$partname$partnum /mnt
	echo "Note, next thing requires knowledge of the nano text editor"
	echo "Do you want to edit the mirrorlist file, you should [y/n]"
	read -rsn1 rchc
	if [ "$rchc" = "y" ]
	then
		echo "Note: To save and exit, do"
		echo "  CTRL+X -> Y -> ENTER"
		echo "Press any key to continue"
		read -rsn1
		nano /etc/pacman.d/mirrorlist
	elif [ "$rchc" = "n" ]
	then
		echo "Skipping then..."
	else
		echo "Skipping then..."
	fi
	clear
	echo "Getting ready to install the host system fully..."
	echo ""
	echo "For packages such as sudo, you should choose the base-devel package!"
	echo "Meaning, go for the base-devel option."
	echo ""
	echo "If you want the Base-devel package, press 'y' [recommended]"
	echo "If you just want the Base package, press 'n' [not recommended]"
	echo "If you are confused, just press 'y'."
	echo "[y/n]?"
	read -rsn1 chcc
	if [ "$chcc" = "y" ]
	then
		echo "Installing the base and base-devel!"
		pacstrap /mnt base base-devel
	elif [ "$chcc" = "n" ]
	then
		echo "Ok, installing base only. [Not recommended]"
		pacstrap /mnt base
	else
		echo "Non valid option selected. Installing base-devel..."
		pacstrap /mnt base base-devel
	fi
	genfstab -U /mnt >> /mnt/etc/fstab
	arch-chroot /mnt bash archkick.sh inchroot $partname
fi
