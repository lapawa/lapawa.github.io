---
layout: post
title:  "Get Linux running on ASUS X205TA netbook"
date:   2015-03-11 12:00:00
categories: linux hardware gentoo
---

Found this nice piece of hardware from [ASUS]. The equipment measures up to my expectations! It's small and lightweight. Has long battery life, is build around a standard x86 cpu and is fan-less. There is only one point I have to worry about. ASUS installed an operating system I can't get happy with.

Some people already tried to get rid of the Windows and installed [Debian],[Ubuntu] or some other Linux Distribution.
This seems to be tricky and support for some hardware components is not yet available. But that's a common situation for Linux enthusiast. I'll start the journey and will build my own [Gentoo] system with this cute Netbook.

# Hardware

Device   | type                  | Connection | dev     | Kernel config
---------|-----------------------|------------|---------|----------
Keyboard | PDEC3393:00 0B05:8585 | i2c        | input3  | I2C_HID, I2C_DESIGNWARE_CORE, I2C_DESIGNWARE_PLATFORM
Touchpad | ELAN0100:00 04F3:0401 | i2c        | input4  | I2C_HID
Internal Flash | HS200 MMC card  | sdhci-acpi | mmcblk0 | CONFIG_MMC_SDHCI_ACPI
WLAN     | Broadcom 43341        | sdio       | wlan0   | B43_SDIO
USB2.0   | Enhanced Host Controller| pci      |         | USB_EHCI_PCI
Bluetooh | Generic Bluetooth SDIO| sdio       |         | 
Sound    |                       |            |         |
SDcard reader |                  |            |         |
Camera   |                       | usb        |         |


## Boot a working environment
The Gentoo based [SystemRescueCd] will be used as the working system to start the install process.
Create a bootable USB stick [prepareusb].

### Boot external media
The Asus 32bit UEFI identifies a bootable media by looking for the file /boot/bootia32.efi on a vfat partition.

 1. Copy a 32bit Grub stage for the ASUS EFI boot. 

## Configure the hardware
  1. Enter the 'BIOS' by pressing F2 on the initial boot screen.
  1. Disable TPM
  1. Select 


## Get the hardware running

### Keyboard
The keyboard is connected via I2C bus and linux will recognise it if the kernel modules **i2c_designware_core** and **i2c_designware_platform** are loaded.

### Linux clocksource
While booting linux spit out a message about unstable tsc registers and switched over to a different clocksource.
```
[    5.513987] Clocksource tsc unstable (delta = 136016997 ns)
```
The effect can drive you crazy. I had watchdog message and killed processes. Failed builds and no repeat function with the keyboard.
Enforce the kernel to keep tsc as the right clocksource by adding  **clocksource=tsc** to your grub config.

### flash disk
Patched by [Nell Hardcastle]


[asus]: http://www.asus.com/in/Notebooks_Ultrabooks/ASUS_EeeBook_X205TA
[debian]: https://wiki.debian.org/InstallingDebianOn/Asus/X205TA
[ubuntu]: https://github.com/lopaka/instructions/blob/master/ubuntu-14.10-install-asus-x205ta.md
[gentoo]: http://www.gentoo.org
[systemrescuecd]: http://www.sysresccd.org/SystemRescueCd_Homepage
[prepareusb]: http://www.sysresccd.org/Sysresccd-manual-en_How_to_install_SystemRescueCd_on_an_USB-stick
[uefibooting]: https://help.ubuntu.com/community/UEFIBooting
[Nell Hardcastle]: https://dev-nell.com/rpmb-emmc-errors-under-linux.html

