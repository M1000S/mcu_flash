#!/bin/bash
bustypes=(USB CAN BRIDGE)
mcunames=()
mcubus=()
mcuidcan=()
mcuidusb=()

function getIndexFromName(){
    for i in "${!mcunames[@]}"; do
        if [[ "${mcunames[$i]}" = "$1" ]]; then
            echo "${i}";
        fi
    done
}

function mcucfg_checkMakeConfig(){
    for mcuname in "${mcunames[@]}"; do
        if [ ! -f "$file_make_katapult_prefix$mcuname" ]; then
            echo "" > "$file_make_katapult_prefix$mcuname"
            echo "Added $file_make_katapult_prefix$mcuname"
        fi
        if [ ! -f "$file_make_klipper_prefix$mcuname" ]; then
            echo "" > "$file_make_klipper_prefix$mcuname"
            echo "Added $file_make_klipper_prefix$mcuname"
        fi
    done
}

function mcucfg_evaluateMcus(){
    mcunames=()
    for mcu in "${MCUS[@]}"; do
        IFS=',' read -ra mcuattribs <<< "$mcu"
        mcunames+=(${mcuattribs[0]})
        mcubus+=(${mcuattribs[1]})
        mcuidcan+=(${mcuattribs[2]})
        mcuidusb+=(${mcuattribs[3]})
    done
}

function mcucfg_printMcus(){
    echo ${mcunames[@]}
    echo ${mcubus[@]}
    echo ${mcuidcan[@]}
    echo ${mcuidusb[@]}
}



