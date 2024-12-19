#!/bin/bash
dir_cfg=~/printer_data/mcu-flash
dir_cfg_make_katapult=$dir_cfg/katapult
dir_cfg_make_klipper=$dir_cfg/klipper
dir_source=source
file_mcu_cfg=$dir_cfg/mcu.cfg
file_mcu_sh=$dir_source/mcu.sh
file_update_sh=$dir_source/update.sh
file_make_katapult_prefix=$dir_cfg_make_katapult/config.make.katapult.
file_make_klipper_prefix=$dir_cfg_make_klipper/config.make.klipper.
can_ifc=can0

source source/utils.cfg

############################################
## setup folder and config file if not exist
init_performed=no
if [ ! -d "$dir_cfg" ]; then
    mkdir $dir_cfg
    echo "${yellow}Added $dir_cfg folder"
fi

if [ ! -d "$dir_cfg_make_katapult" ]; then
    mkdir $dir_cfg_make_katapult
    echo "Added $dir_cfg_make_katapult folder"
fi

if [ ! -d "$dir_cfg_make_klipper" ]; then
    mkdir $dir_cfg_make_klipper
    echo "Added $dir_cfg_make_klipper folder"
fi

if [ ! -f "$file_mcu_cfg" ]; then
    filestring=$'MCUS=(\n'
    filestring+=$')\n'
    echo "$filestring" > $file_mcu_cfg
    echo "Added $file_mcu_cfg file"
    init_performed="yes"
fi

if [[ $init_performed == "yes" ]]; then
    echo "${magenta}Please configure your mcus in $file_mcu_cfg!"
    exit 0
fi
##
############################################


source $file_mcu_cfg
source $file_mcu_sh
source $file_update_sh

mcucfg_evaluateMcus
mcucfg_checkMakeConfig

function mainMenu(){
    while true; do 
        clear
        echo "${cyan}/============ Main Menu ============\\"
        echo "Available actions:"
        PS3="Please select: "
        select action in "Update MCUs" Quit
        do
            case $action in
                "Update MCUs") updateMcuMenu ;break;;
                "Quit") break 2;;
                *) echo "Invalid selction";;
            esac
        done
    done
}

function updateMcuMenu(){
    while true; do
        clear 
        echo "${cyan}/============ Update MCUs ============\\"
        echo "Available actions:"
        PS3="Please select: "
        select action in ${mcunames[@]} "Back"
        do
            if [[ "$action" == "Back" ]]; then
                break 2
            fi
            if [[ $REPLY > ${#mcunames[@]} ]]; then
                echo "Invalid slection"
                break
            else
                echo "Start updating mcu $action${white}"
                updateMcu "$action" $(getIndexFromName "$action")
                break
            fi
        done
    done
}

#mcucfg_printMcus
mainMenu