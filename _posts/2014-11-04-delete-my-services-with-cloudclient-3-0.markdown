---
layout: post
title:  "Delete my vRA items with CloudClient v3.0"
date:   2014-11-04 12:00:00
categories: vmware
---
This short shell script snipped will remove all your services from the vRAs items list.
We asume that CloudUtil is able to log in automatically. This can be achieved by setting the 'configuration' as described in my previous post.


{% highlight bash %}
for VMID in $(./cloudclient.sh vra provisioneditem list --format CSV|cut -d, -f1);
do
  ./cloudclient.sh vra provisioneditem action execute --id "$VMID" --action Destroy;
done
{% endhighlight %}
The first command `vra provisioneditems list` receives a list of items owned by the logged in user.
The second part loops over this list and fires a `Destroy` action on each item.
Thats it.


[cloudclient-dl]: http://developercenter.vmware.com/web/dp/tool/cloudclient/3.0.0
[cloudclient-blog]: http://blogs.vmware.com/consulting/tag/cloudclient

