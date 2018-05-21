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
		echo "Ethernet selected"
		break
	else
		clear
	fi
done
