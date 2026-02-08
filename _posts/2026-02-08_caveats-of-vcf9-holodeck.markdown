---
layout: post
title:  "Solving caveats with VMware Cloud Foundation 9 Holodeck"
date:   2026-02-08 12:00:00
categories: vcf
---

VMware [Holodeck] is a set of scripts delivered in a Photon OS Appliance which can setup a VMware Cloud Foundation Installation on a single ESX Host System or a vSphere Clusters. 

Installing VMware Holodeck for VCF9 as described on [github] might get a little bit cumbersome.
In this article I'll collect the caveats I've stepped into and tried to solve.

## Holorouter 
### Name resolution from Holorouter to public network fails sometimes
Sometimes a name server resolution fails on holorouter.
{% highlight bash %}
root@holorouter [ ~ ]# ping www.vmware.com
ping: www.vmware.com: Name or service not known
root@holorouter [ ~ ]#
{% endhighlight %}

Checking the systemd resolved configurations shows two different nameserver records in the PhotonOS appliance.
{% highlight bash %}
root@holorouter [ ~ ]# cat /etc/resolv.conf
# This is /run/systemd/resolve/resolv.conf managed by man:systemd-resolved(8).
# Do not edit.
#
# This file might be symlinked as /etc/resolv.conf. If you're looking at
# /etc/resolv.conf and seeing this text, you have followed the symlink.
#
# This is a dynamic resolv.conf file for connecting local clients directly to
# all known uplink DNS servers. This file lists all configured search domains.
#
# Third party programs should typically not access this file directly, but only
# through the symlink at /etc/resolv.conf. To manage man:resolv.conf(5) in a
# different way, replace this symlink by a static file or a different symlink.
#
# See man:systemd-resolved.service(8) for details about the supported modes of
# operation for /etc/resolv.conf.

nameserver 10.1.1.1
nameserver 192.168.1.1
search vcf.lab lab.example.com
root@holorouter [ ~ ]#
{% endhighlight %}

The first nameserver 10.1.1.1 is served by a dnsmasq process running on the holorouter itself within a kubernetes pod. It can resolve records for the Holodeck Installation itself from zone vcf.lab.
You can get a complete list of records from the kubernetes configmap.

{% highlight bash %}
root@holorouter [ ~ ]# kubectl describe  configmap/dnsmasq
{% endhighlight %}

All other or foreign queries can be answered by the second nameserver entry 192.168.1.1, which is the default from your network in which holorouter was provisioned.

It depends on the client applications behaviour if the name resolution is functional with this setup. Some clients will ask both nameserver at the same time. Other might use a round-robin algorithm. From my experience it is not deterministic.  

#### Solution
Lets bring in some hierachy in the DNS server setup. All queries should go to the dnsmasq pod first and will get forwarded network DNS server if the zone is not vcf.lab.

1. Remove the external nameserver record from the appliance setup.
{% highlight bash %}
# root@holorouter [ ~ ]# resolvectl dns eth0 10.1.1.1
{% endhighlight %}
2. Add the network DNS server to the dnmasq configuration
{% highlight bash %}
root@holorouter [ ~ ]# kubectl edit  configmap/dnsmasq
data:
  dnsmasq.conf: |-
    server=192.168.100.100
{% endhighlight %}
3. Restart dnmasq pod
{% highlight bash %}
root@holorouter [ ~ ]# kubectl  get pods | grep dnsmasq
dnsmasq-deployment-9796d69c6-85k8b       1/1     Running                 0                100s
root@holorouter [ ~ ]# kubectl  delete pod/dnsmasq-deployment-9796d69c6-85k8b
pod "dnsmasq-deployment-9796d69c6-xq6n9" deleted
root@holorouter [ ~ ]#
{% endhighlight %}

Let's verify the solution:
{% highlight bash %}
root@holorouter [ ~ ]# ping www.vmware.com
PING www.vmware.com.cdn.cloudflare.net (104.18.33.181) 56(84) bytes of data.
64 bytes from 104.18.33.181 (104.18.33.181): icmp_seq=1 ttl=55 time=7.67 ms
64 bytes from 104.18.33.181 (104.18.33.181): icmp_seq=2 ttl=55 time=7.25 ms
^C
--- www.vmware.com.cdn.cloudflare.net ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 7.248/7.459/7.670/0.211 ms
root@holorouter [ ~ ]#
{% endhighlight %}

[Holodeck]: https://vmware.github.io/Holodeck/
[github]: https://github.com/vmware/Holodeck
