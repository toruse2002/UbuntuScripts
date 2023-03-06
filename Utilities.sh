#!/bin/bash
# self exe
chmod +x $0
echo "The executable bit has been added to the script."
while [[ $option -ne 6 ]];do
    # menu
    echo "Select an option:"
    echo "1. Update package list and upgrade packages"
    echo "2. Check and repair file system errors"
    echo "3. Clean up unneeded packages and cached files"
    echo "4. Check and repair disk errors"
    echo "5. Scan and remove malware"
    echo "6. Exit"
    # Input
    read option
    # Execute the selected option
    case $option in
        1) sudo apt update -y -qq && sudo apt -y -qq upgrade;;
        2)
            # available disks
            echo "Select a disk to check for file system errors:"
            lsblk -io NAME,TYPE,SIZE,MOUNTPOINT | grep -E 'disk|part'
            read -p 'Enter  Name disk: ' disk
            sudo fsck -y /dev/$disk;;
        3) sudo apt autoremove && sudo apt autoclean;;
        4)
            # available disks
            echo "Select a disk to check for bad blocks:"
            lsblk -io NAME,TYPE,SIZE,MOUNTPOINT | grep -E 'disk|part'
            read -p 'Enter  Name disk: ' disk
            sudo badblocks -sv /dev/$disk;;
        5)  if ! command -v clamscan &> /dev/null
            then
                echo "ClamAV is not installed. Installing now..."
                sudo apt-get update -qq
                sudo apt-get install -y -qq clamav
                echo "Configuring Database check: 2 checks daemon"
                sudo freshclam -d -c 2
            else
                echo "ClamAV is installed. Scanning for viruses..."
                sudo clamscan --infected -v --recursive /home --move=/var/quarantine --log=/var/log/clamav/clamscan.log /
            fi
            sudo less /var/log/clamav/clamscan.log;;
        6) echo "Bye" ;exit;;
        *) echo "Invalid option. Please select a number from 1 to 6.";;
    esac
done
