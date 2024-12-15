#!/bin/bash
source mcu-flash.cfg

declare -A mcu_type
declare -A mcu_id

if [ ! -d "$dir_klipper" ]; then
  echo "$dir_klipper does not exist."
else
  echo "$dir_klipper exists."
fi

if [ ! -d "$dir_katapult" ]; then
  echo "$dir_katapult does not exist."
else
  echo "$dir_katapult exists."
fi

if [ ! -d "$dir_config" ]; then
  echo "$dir_config does not exist."
  mkdir $dir_config
  echo "$dir_config created."
fi

  if [ ! -f "$dir_config/mcu.cfg" ]; then
    echo "$dir_config/mcu.cfg does not exist."
    echo "MCU_NAME,FLASH_TYPE <USB|CAN|BRIDGE|LINUX>,DEVICE_ID" > "$dir_config/mcu.cfg"
    echo "$dir_config/mcu.cfg created."
    echo "Fill out $dir_config/mcu.cfg and restart."
    exit 0
  else
    echo "Read mcus from $dir_config/mcu.cfg."
    while read p; do 
        echo "$p"
        if [[ ! $p == *"MCU_NAME"* ]]; then
            IFS=', ' read -r -a array <<< "$p"
            echo ${array[@]}
            mcu_type[${array[0]}]="${array[1]},${array[2]}"
            #mcu_id[${array[0]}] = ${array[1]}
            echo "config.make.klipper.${array[0]}"
            if [ ! -f "$dir_config/config.make.klipper.${array[0]}" ]; then
                echo "" >> "$dir_config/config.make.klipper.${array[0]}"
                echo "$dir_config/config.make.klipper.${array[0]} created."
            fi
        fi
    done < "$dir_config/mcu.cfg"
  fi

for key in "${!mcu_type[@]}" 
do
   echo $key
   echo ${mcu_type[$key]}
done


function flash_mcu {
  sudo systemctl stop klipper
  cd ~/klipper
  make clean
  #make menuconfig KCONFIG_CONFIG=config.make.klipper.octopus
  # make -j4 KCONFIG_CONFIG=config.make.klipper.octopus

  ### Jump2Boot Bridge
  #python3 ~/katapult/scripts/flashtool.py -i can0 -u 8f5ad134a670 -r
  
  ### USB
  #python3 ~/katapult/scripts/flashtool.py -d /dev/serial/by-id/usb-katapult_stm32g0b1xx_32003B000A504B4633373520-if00 -f ~/klipper/out/klipper.bin
  #python3 ~/katapult/scripts/flashtool.py -d /dev/serial/by-id/usb-katapult_stm32g0b1xx_32003B000A504B4633373520-if00 -f ~/katapult/out/deployer.bin
  ### CAN
  #python3 ~/katapult/scripts/flashtool.py -i can0 -f ~/klipper/out/klipper.bin -u e6002b2b0540
  #python3 ~/katapult/scripts/flashtool.py -i can0 -f ~/katapult/out/deployer.bin -u e6002b2b0540

  echo $1
  echo ${mcu_type[$1]}
  make clean
  sudo systemctl stop klipper
}



PS3="Select mcu please: "

items=(${!mcu_type[@]})

while true; do
    select item in "${items[@]}" Quit
    do
        clear
        if [ $REPLY -gt ${#items[@]} ]; then
            echo "We're done!"; break 2;
        else
            echo "Start flashing mcu #$REPLY"; flash_mcu "$item"; break ;
        fi
    done
done
