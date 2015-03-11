---
layout: post
title:  "Get Linux running on ASUS X205TA netbook"
date:   2015-03-11 12:00:00
categories: linux hardware gentoo
---

Found this nice piece of hardware from [ASUS]. The equipment measures up to my expectations! It's small and lightweight. Has long battery life, is build around a standard x86 cpu and is fan-less. There is only one point I have to worry about. ASUS installed an operating system I can't get happy with.

Some people already tried to get rid of the Windows and installed [Debian],[Ubuntu] or some other Linux Distribution.
This seems to be tricky and support for some hardware components is not yet available. But that's a common situation for Linux enthusiast. I'll start the journey and will build my own [Gentoo] system with this cute Netbook.

## Boot a working environment
The Gentoo based [SystemRescueCd] will be used as the working system to start the install process.
Create a bootable USB stick [prepareusb].

### Boot external media
The Asus 32bit UEFI identifies a bootable media by looking for the file /boot/bootia32.efi on a vfat partition.

 1. Copy a 32bit Grub stage for the ASUS EFI boot. 
{% highlight bash %}
sudo cp /usr/share/icons/Tango/index.theme /usr/lib/vmware/share/icons/Human/
vmware
{% endhighlight %}
 1.  Et voila. The icons are visible again.

### Configure the hardware
  1. Enter the 'BIOS' by pressing F2 on the initial boot screen.
  1. Disable TPM
  1. Select 

[asus]: http://www.asus.com/in/Notebooks_Ultrabooks/ASUS_EeeBook_X205TA
[debian]: https://wiki.debian.org/InstallingDebianOn/Asus/X205TA
[ubuntu]: https://github.com/lopaka/instructions/blob/master/ubuntu-14.10-install-asus-x205ta.md
[gentoo]: http://www.gentoo.org
[systemrescuecd]: http://www.sysresccd.org/SystemRescueCd_Homepage
[prepareusb]: http://www.sysresccd.org/Sysresccd-manual-en_How_to_install_SystemRescueCd_on_an_USB-stick
[uefibooting]: https://help.ubuntu.com/community/UEFIBooting

