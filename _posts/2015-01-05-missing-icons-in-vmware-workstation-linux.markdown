---
layout: post
title:  "Fix missing icons in VMware Workstation for Linux"
date:   2015-01-05 12:00:00
categories: vmware
---

I'm using Xubuntu on several linux boxes and have seen missing icons in the VMware workstation GUI for several times now.
This is annoying and makes every task a guess.
![Missing Icons Screenshot]({{ site.url }}/assets/vmware-workstation-missing-icons.jpg)

The reason lies in a missing *index.theme* file as mentioned in this VMware community thread [[Missing index.theme]][vmwcom-index-theme].
I picked the file from the *Tango* theme and copied it to folders with the VMware workstations icons.
This icon theme seems to support the naming schema best as stated in another VMware community thread [[Icon Naming Schema]][vmwcom-icon-names].
{% highlight bash %}
sudo apt-get install tango-icon-theme
sudo cp /usr/share/icons/Tango/index.theme /usr/lib/vmware/share/icons/hicolor/
sudo cp /usr/share/icons/Tango/index.theme /usr/lib/vmware/share/icons/Human/
vmware
{% endhighlight %}
Et voila. The icons are visible again.
![VMware workstation with icons]({{site.url}}/assets/vmware-workstation-with-icons.jpg)

[vmwcom-index-theme]: https://communities.vmware.com/thread/495753
[vmwcom-icon-names]: https://communities.vmware.com/message/1200005

### Used Versions
* VMware Workstation for Linux 64Bit 10.0.2 build-1744117
* Ubuntu 12.04.5 LTS
