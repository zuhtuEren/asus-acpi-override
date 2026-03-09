#!/bin/bash

# --- Color Definitions ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===========================================${NC}"
echo -e "${RED}    Asus Linux ACPI Fix Uninstaller        ${NC}"
echo -e "${BLUE}===========================================${NC}"

# Check for root privileges (required to modify /boot)
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script must be run as root.${NC} Use: sudo ./uninstall.sh"
   exit 1
fi

# List of potential images created by the installer
IMAGES=("acpi_fixed.img" "txhc_fixed.img" "ec0t_fixed.img")
FOUND_ANY=false

echo -e "${YELLOW}Searching for installed ACPI patches in /boot...${NC}"

for img in "${IMAGES[@]}"; do
    if [[ -f "/boot/$img" ]]; then
        echo -e "${BLUE}Found:${NC} /boot/$img"
        read -p "Do you want to remove this patch? (y/n): " confirm
        if [[ $confirm == [yY] ]]; then
            rm "/boot/$img"
            echo -e "${GREEN}Removed:${NC} /boot/$img"
            FOUND_ANY=true
        fi
    fi
done

if [ "$FOUND_ANY" = false ]; then
    echo -e "${YELLOW}No patches were found in /boot.${NC}"
else
    echo -e "\n${GREEN}Cleanup of /boot is complete.${NC}"
fi

echo -e "\n${YELLOW}--- IMPORTANT: MANUAL STEPS REQUIRED ---${NC}"
echo -e "1. Edit your GRUB configuration:"
echo -e "   ${BLUE}sudo nano /etc/default/grub${NC}"
echo -e "2. Remove or comment out the following line:"
echo -e "   ${RED}GRUB_EARLY_INITRD_LINUX_CUSTOM=\"...\"${NC}"
echo -e "3. Update GRUB to apply changes:"
echo -e "   ${BLUE}sudo update-grub${NC}"
echo -e "4. Reboot your system.${NC}"

echo -e "\n${BLUE}Uninstallation process finished.${NC}"
