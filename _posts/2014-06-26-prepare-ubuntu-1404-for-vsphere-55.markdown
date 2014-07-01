---
layout: post
title:  "Prepare Ubuntu for vSphere customization"
date:   2014-06-26 12:00:00
categories: vmware
---

VMware vSphere can adjust the guest operating system configuration while cloning a virtual machine. VMware vCenter provides the `customization specifications`. Cloud management tool like VMware Cloud Automation Center use this feature to get network configuration and hostname into a fresh deployed virtual machine.
While writing this text the most recent version from VMwares vSphere is 5.5 Update1. It does not support the most recent linux distribution Ubuntu 14.04 LTS.
In the further lines I'll describe a way to get this new peace of software running with vSphere 5.5u1 customization specifications.
Jekyll also offers powerful support for code snippets:

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

Check out the [Jekyll docs][jekyll] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll's GitHub repo][jekyll-gh].

[jekyll-gh]: https://github.com/mojombo/jekyll
[jekyll]:    http://jekyllrb.com
