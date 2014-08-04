---
layout: post
title:  "Building a jukebox on RaspberryPi with QR code scanner"
---

## Hardware components

* Raspberry Pi B
* Raspberry Pi Camera
* 

## Software components

* Raspbian Image as operating system on Raspberry Pi
* [xmms2](https://xmms2.org/) play and manage music library
* [ZBar](bar code reader with QR code support)
* 

Install the packages on the Raspberry Pi via command line:
```bash
# sudo apt-get install xmm2 zbar-tools
```

### Get the camera up and running
The tool ZBar is used to identify a qr code in the cameras picture.
Unfortenately ZBar does not support the Raspeberry Pi camera directly. It read images from video 4 linux devices only.
But there are video4linux device drivers available for the Raspberry Pi camera. 

We'll have to install some software packages from the a different repository.
This complete procedure is described on [Linux Projects](http://www.linux-projects.org/modules/sections/index.php?op=viewarticle&artid=14)

{% highlight bash %}
# wget http://www.linux-projects.org/listing/uv4l_repo/lrkey.asc && sudo apt-key add ./lrkey.asc
# sudo echo "deb http://www.linux-projects.org/listing/uv4l_repo/raspbian/ wheezy main" > /etc/apt/sources.list.d/linux-projects.list
# sudo apt-get update 
# sudo apt-get install uv4l uv4l-raspicam uv4l-raspicam-extras
{% endhighlight %}






