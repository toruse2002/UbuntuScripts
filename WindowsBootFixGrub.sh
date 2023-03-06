#!/bin/bash
chmod +x $0
# Find the Windows boot partition
windows_part=$(sudo parted -l 2>/dev/null | grep -m 1 'Microsoft basic data' | awk '{print $1}')

if [ -z "$windows_part" ]; then
  echo "ERROR: Could not find Windows partition"
  exit 1
fi

# Mount the Windows partition
sudo mkdir /mnt/windows
sudo mount -t ntfs "$windows_part" /mnt/windows

# Add Windows boot entry to GRUB
sudo tee -a /etc/grub.d/40_custom > /dev/null <<EOF
menuentry "Windows 10" {
    insmod part_msdos
    insmod ntfs
    set root='hd0,msdos1'
    search --no-floppy --fs-uuid --set=root $(sudo blkid -s UUID -o value $windows_part)
    chainloader +1
}
EOF

# Update GRUB configuration
sudo update-grub

# Unmount the Windows partition
sudo umount /mnt/windows
sudo rmdir /mnt/windows

echo "Windows boot entry added to GRUB menu"
