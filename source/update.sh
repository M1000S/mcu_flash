#!/bin/bash

function make_katapult {
  cd ~/katapult
  make clean
  echo "$1"
  make menuconfig KCONFIG_CONFIG="$1"
  make -j4 KCONFIG_CONFIG="$1"
  cp out/deployer.bin "$dir_cfg/firmware.bin"
  make clean
  cd ~
}

function make_klipper {
  cd ~/klipper
  make clean
  echo "$1"
  make menuconfig KCONFIG_CONFIG="$1"
  make -j4 KCONFIG_CONFIG="$1"
  cp out/klipper.bin "$dir_cfg/firmware.bin"
  make clean
  cd ~
}

function flash_mcu_can {
  cd ~
  sudo systemctl stop klipper
  echo "Starting CAN flash"
  #python3 ~/katapult/scripts/flashtool.py -i "$can_ifc" -f "$dir_cfg/firmware.bin" -u "$1"
  rm "$dir_cfg/firmware.bin"
  sudo systemctl start klipper
}

function flash_mcu_usb {
  cd ~  
  sudo systemctl stop klipper
  echo "Starting USB flash"
  #python3 ~/katapult/scripts/flashtool.py -d "$1" -f "$dir_cfg/firmware.bin"
  rm "$dir_cfg/firmware.bin"
  sudo systemctl start klipper
}

function flash_mcu_bridge {
  cd ~  
  sudo systemctl stop klipper
  echo "Jump to boot"
  #python3 ~/katapult/scripts/flashtool.py -i can0 -u "$1" -r
  sleep 5
  echo "Starting BRIDGE flash"
  #python3 ~/katapult/scripts/flashtool.py -d "$2" -f "$dir_cfg/firmware.bin"
  rm "$dir_cfg/firmware.bin"
  sudo systemctl start klipper
}

function updateMcu()
{
    read -p "Update katapult bootloader? (Y/N): " confirm
    if [ "$confirm" == "Y" ] || [ "$confirm" == "y" ]; then
        echo "Make katapult bootloader for $1"
        make_katapult "$file_make_katapult_prefix$1"
        echo "Flash katapult bootloader to $1"
        case ${mcubus[$2]} in
            "USB") flash_mcu_usb "${mcuidusb[$2]}" ;;
            "CAN") flash_mcu_can "${mcuidcan[$2]}" ;;
            "BRIDGE") flash_mcu_bridge "${mcuidcan[$2]}" "${mcuidusb[$2]}" ;;
            *) ;;
        esac
        echo ${mcubus[$2]}
        echo ${mcuidcan[$2]}
        echo ${mcuidusb[$2]}
        
    fi
    echo "Make klipper firmware for $1"
    make_klipper "$file_make_klipper_prefix$1"
    echo "Flash klipper firmware to $1"
    case ${mcubus[$2]} in
        "USB") flash_mcu_usb "${mcuidusb[$2]}" ;;
        "CAN") flash_mcu_can "${mcuidcan[$2]}" ;;
        "BRIDGE") flash_mcu_bridge "${mcuidcan[$2]}" "${mcuidusb[$2]}" ;;
        *) ;;
    esac
    read -p "${green}Updating $1 done. Press any key to continue.${white}" confirm
}