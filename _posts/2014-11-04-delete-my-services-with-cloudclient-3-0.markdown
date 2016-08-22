---
layout: post
title:  "Delete my vRA items with CloudClient"
date:   2014-11-04 12:00:00
categories: vmware
---
This shell script snipped will remove all your services from the vRAs items list.
We asume that CloudUtil is able to log in automatically. This can be achieved by setting the 'configuration' as described in my previous post.


{% highlight bash %}
for VMID in $(./cloudclient.sh vra provisioneditem list --format CSV|cut -d, -f1);
do
  ./cloudclient.sh vra provisioneditem action execute --id "$VMID" --action Destroy;
done
{% endhighlight %}
The first command `vra provisioneditems list` receives a list of items owned by the logged in user.
The second part loops over this list and fires a `Destroy` action on each item.

That's it.

### Used Versions

 * [VMware vRealize Automation][vra] 6.1 (vRA) formely vCloud Automation Center (vCAC)
 * [CloudClient][cloudclient-dl] v3.0

[cloudclient-dl]: http://developercenter.vmware.com/web/dp/tool/cloudclient/3.0.0
[vra]: http://www.vmware.com/products/vrealize-automation/

