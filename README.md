# mcu_flash utility

## Description
Small tool for updating mcu firmware.
- Single script to update all mcus bootloader and application.
- Keep mcu configurations in seperate directory with clear naming

## How it works
- Flashing is done with katapult flash tool
- <b>Updating katapult is done via deployer. Ensure the option is set in katapult make config!</b>
- <b>BUS</b> types
    - For mcus connected via <b>USB</b>
        - Katapult is flashed via USB (katapult make must be configured for USB)
        - Klipper is flashed via USB (klipper make must be configured for USB)
    - For mcus connected via <b>CAN</b>
        - Katapult is flashed via CAN (katapult make must be configured for CAN)
        - Klipper is flashed via CAN (klipper make must be configured for CAN)
    - For mcus connected via USB but used as USB to CAN <b>BRIDGE</b>
        - Katapult is flashed via USB (katapult make must be configured for USB, not for USB to CAN Bridge!)
        - Klipper is flashed via CAN (klipper make must be configured for USB to CAN Bridge!)
- klipper must alwys be updated after katapult is updated.<br>
  (Reason is that the deployer is flashed into klipper memory area. Then it updates the bootloader)
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
    - Add a line for each mcu with following informations and format. See example [mcu.cfg](example_configs/mcu.cfg)<br>
        [#]="MCU_NAME,BUS,CAN-ID,USB-ID"
        - BUS: CAN|USB|BRIDGE (see [How it works](#how-it-works))
        - CAN-ID: CAN-ID|-
        - USB-ID: USB-ID|-</br>
  
- If you have make config files already available:
    - Copy katapult make config files to folder ~/printer_data/mcu-flash/katapult and rename them to config.make.katapult.<MCU_NAME_IN_MCU.CFG>
    - Copy klipper make config files to folder ~/printer_data/mcu-flash/katapult and rename them to config.make.klipper.<MCU_NAME_IN_MCU.CFG>
- If you dont have make files they will be generated at first update

### Usage
Execute ./mcu-flash.sh in folder ~/mcu_flash<br>
Follow the menu :-)

### Tips
- Add systemctl * klipper to sudoers to avoid password prompt

### Useful links
* [Katapult](https://github.com/Arksine/katapult)
* [Esoterical CAN Guide](https://canbus.esoterical.online/)
* [Dr.Klipper - Flash Guide](https://drklipper.de/doku.php?id=klipper_faq:flash_guide:start)