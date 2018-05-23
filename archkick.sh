if [ "$1" = "inchroot" ]
then
	echo "If you see this text, you are now in your system (or chrooted)!"
	echo "Getting timezones ready..."
	sleep 1
	echo "Listing all Zones"
	while true
	do
		ls /usr/share/zoneinfo/
		echo -n "Please type your zone [EX New York]: "
		read zonein
		if [ ! -d "/usr/share/zoneinfo/$zonein" ]
		then
			echo "ERROR: Please enter a valid zone"
			echo "Make sure you include the capital letters!"
			sleep 3 #work on this bit today
	ln -sf /usr/share/zoneinfo/Zone/SubZone /etc/localtime
else
	clear
	echo "Welcome to ArchKick! v1.0"
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
	echo "Creating swap..."
	mkswap /dev/$partname$swapnum
	swapon /dev/$partname$swapnum
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
		sudo nano /etc/pacman.d/mirrorlist
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
	arch-chroot /mnt bash archkick.sh inchroot
fi
