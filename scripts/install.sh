#!/bin/bash

# --- Color Definitions ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}===========================================${NC}"
echo -e "${GREEN}    Asus Linux ACPI Fix Installer          ${NC}"
echo -e "${BLUE}===========================================${NC}"

# Check for dependencies (cpio is required for archive creation)
if ! command -v cpio &> /dev/null; then
    echo -e "${RED}Error: 'cpio' is not installed.${NC} Please run: sudo apt install iasl cpio"
    exit 1
fi

# Ensure the script is executed from the 'scripts/' directory
if [[ ! -d "../bin" ]]; then
    echo -e "${RED}Error: Directory '../bin' not found.${NC} Please run this script from the 'scripts/' directory."
    exit 1
fi

# Cleanup previous temporary files and create kernel hierarchy
rm -rf kernel 2>/dev/null
mkdir -p kernel/firmware/acpi

echo -e "${YELLOW}Please select the patches you want to include in the image:${NC}"
echo "1) TXHC Fix only (Resolves Shutdown/Suspend hangs)"
echo "2) EC0 Fix only  (Resolves Thermal Sensor/AE_NOT_FOUND errors)"
echo "3) Both Patches  (Full Fix - Recommended)"
echo "4) Exit"
read -p "Selection [1-4]: " choice

case $choice in
    1)
        cp ../bin/TXHC_patch.aml kernel/firmware/acpi/
        IMG_NAME="txhc_fixed.img"
        echo -e "${GREEN}Action: Selected TXHC Fix.${NC}"
        ;;
    2)
        cp ../bin/EC0T_patch.aml kernel/firmware/acpi/
        IMG_NAME="ec0t_fixed.img"
        echo -e "${GREEN}Action: Selected EC0 Thermal Fix.${NC}"
        ;;
    3)
        cp ../bin/*.aml kernel/firmware/acpi/
        IMG_NAME="acpi_fixed.img"
        echo -e "${GREEN}Action: Selected Full Fix (TXHC + EC0).${NC}"
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid selection.${NC}"
        exit 1
        ;;
esac

# Create the CPIO archive for early initrd loading
echo -e "\n${BLUE}Building $IMG_NAME...${NC}"
find kernel | cpio -H newc -o > "../$IMG_NAME" 2>/dev/null

if [[ -f "../$IMG_NAME" ]]; then
    echo -e "${GREEN}Success! $IMG_NAME has been created in the project root.${NC}"
    echo -e "\n${YELLOW}--- DEPLOYMENT INSTRUCTIONS ---${NC}"
    echo -e "1. Copy the image to boot directory:"
    echo -e "   ${BLUE}sudo cp ../$IMG_NAME /boot/${NC}"
    echo -e "2. Add the following line to ${BLUE}/etc/default/grub${NC}:"
    echo -e "   ${GREEN}GRUB_EARLY_INITRD_LINUX_CUSTOM=\"$IMG_NAME\"${NC}"
    echo -e "3. Update GRUB and reboot:"
    echo -e "   ${BLUE}sudo update-grub && sudo reboot${NC}"
    echo -e "4. Verify after reboot:"
    echo -e "   ${BLUE}dmesg | grep -i \"Table Upgrade\"${NC}"
else
    echo -e "${RED}Failed to create the ACPI image archive.${NC}"
fi

# Remove temporary kernel directory
rm -rf kernel
