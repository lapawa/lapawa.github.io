---
layout: post
title:  "Introducing VMware CloudClient v3.0"
date:   2014-10-29 12:00:00
categories: vmware
---

VMware has released a new generation command line interface called CloudClient.
The 46MB sized ZIP file is freely available in the [VMware Developer Center][cloudclient-dl].
It's a java application and runs on every machine with JRE 1.7.
The connectivity to several VMware vCloud products is implemented in plugins.
These four plugins get shipped with Cloudclient version 3.0:

  * Login - Handles sessions and credentials
  * SRM - VMware Side Recovery Manager
  * VCO - VMware vCenter Orchestrator v5.5
  * VRA - VMware vRealize Automation v6.0.1 and 6.1 ( formely know as vCloud Automation Center )
  

### Installation
Extract the downloaded zip file in an appropriate location.

### Browse the documentation
The zip file includes some documenation in html format which can be browsed with the starting page *doc/index.html*
Further usage scenarios are described on the official [CloudClient Blog][cloudclient-blog]

### Launching Cloud Client
There are two scripts to handle the appropriate launch of the java main class.

One for Windows:
{% highlight batch %}
cloudclient.bat
{% endhighlight %}
And one for Linux, MacOSX or other UNIX similar systems.
{% highlight batch %}
sh cloudclient.sh
{% endhighlight %}
You'll get an interactive prompt when starting the client without any arguments.

[cloudclient-dl]: http://developercenter.vmware.com/web/dp/tool/cloudclient/3.0.0
[cloudclient-blog]: http://blogs.vmware.com/consulting/tag/cloudclient

