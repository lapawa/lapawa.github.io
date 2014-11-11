---
layout: post
title:  "Introducing VMware Integrated OpenStack VIO"
date:   2014-11-11 12:00:00
categories: vmware
---
This short shell script snipped will remove all your services from the vRAs items list.
We asume that CloudUtil is able to log in automatically. This can be achieved by setting the 'configuration' as described in my previous post.

The first part 'vra provisioneditems list' receives a list of items owned by the logged in user.
The second part loops over this list and fires a 'destroy' action on each of them.
Thats it.


{% highlight bash %}
cc$ for VMID in $(./cloudclient.sh vra provisioneditem list --format CSV|cut -d, -f1);
do
  ./cloudclient.sh vra provisioneditem action execute --id "$VMID" --action Destroy;
done
{% endhighlight %}

[cloudclient-dl]: http://developercenter.vmware.com/web/dp/tool/cloudclient/3.0.0
[cloudclient-blog]: http://blogs.vmware.com/consulting/tag/cloudclient

