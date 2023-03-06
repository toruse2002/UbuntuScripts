#!/bin/bash
#efibootmgr use case
chmod +x $0
# Find the Windows boot partition
windows_part=$(sudo parted -l 2>/dev/null | grep -m 1 'Microsoft basic data' | awk '{print $1}')

if [ -z "$windows_part" ]; then
  echo "ERROR: Could not find Windows partition"
  exit 1
fi

# Add Windows boot option to EFI boot manager
sudo efibootmgr --create --label "Windows Boot Manager" --loader "\\EFI\\Microsoft\\Boot\\bootmgfw.efi" --bootnum 0000 --disk "$windows_part"

# Set Windows boot option as the default
sudo efibootmgr --bootorder 0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,000A,000B,000C,000D,000E,000F

echo "Windows boot option added to EFI boot manager"
