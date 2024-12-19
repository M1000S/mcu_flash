# mcu_flash utility

## Description
Small tool for updating mcu firmware.
- Single script to update all mcus bootloader and application.
- Keep mcu configurations in seperate directory with clear naming

## Usage

### Prerequisites
- All mcus are flashed with katapult bootloader
- Default install directories needed
    - ~/katapult
    - ~/klipper
    - ~/printer_data

Note: Developed and tested and used on MainsailOS.

### Installation
- clone the repository to home directory
- At first execution of /mcu_flash/mcu-flash.sh the folder structure in printer_data is setup
 
### Deinstallation
- Delete folders
    - ~/mcu_flash
    - ~/printer_data/mcu-flash

### Configuration
- The mcus which shall be updated have to be configured in file ~/printer_data/mcu-flash/mcu.cfg
    - Add a line for each mcu with following informations and format:
        [#]="MCU_NAME,BUS,CAN-ID,USB-ID"
        - BUS: CAN|USB|BRIDGE
        - CAN-ID: CAN-ID|-
        - USB-ID: USB-ID|-
    See example configurations for examples
- If you have make config files already available:
    - Copy katapult make config files to folder ~/printer_data/mcu-flash/katapult and rename them to config.make.katapult.<MCU_NAME_IN_MCU.CFG>
    - Copy klipper make config files to folder ~/printer_data/mcu-flash/katapult and rename them to config.make.klipper.<MCU_NAME_IN_MCU.CFG>
- If you dont have make files they will be generated at first update

### Usage
Execute ./mcu-flash.sh in folder ~/mcu_flash<br>
Follow the menu :-)

### Tips
- Add systemctl * klipper to sudoers to avoid password prompt