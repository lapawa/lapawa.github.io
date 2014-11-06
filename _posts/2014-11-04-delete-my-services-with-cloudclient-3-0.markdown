---
layout: post
title:  "Delete my vRA items with CloudClient v3.0"
date:   2014-11-04 12:00:00
categories: vmware
---


{% highlight bash %}
cc$ for VMID in $(./cloudclient.sh vra provisioneditem list --format CSV|cut -d, -f1);
do
  ./cloudclient.sh vra provisioneditem action execute --id "$VMID" --action Destroy;
done
{% endhighlight %}

### Installation
Extract the downloaded zip file in an appropriate location.

### Browse the documentation
The zip file includes some documenation in html format which can be browsed with the starting page *doc/index.html*
Further usage scenarios are described on the official [CloudClient Blog][cloudclient-blog]


[cloudclient-dl]: http://developercenter.vmware.com/web/dp/tool/cloudclient/3.0.0
[cloudclient-blog]: http://blogs.vmware.com/consulting/tag/cloudclient

