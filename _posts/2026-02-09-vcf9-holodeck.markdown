---
layout: post
title:  "Solving VCF Installer Download Verification failures"
date:   2026-02-09 12:00:00
categories: vcf
---
Validating a download in the VCF Installer apppliance can fail if the disk was out of space.
This results in an error messages similar to this one:
{% highlight bash %}
09-02-2026 15:02:04  SddcMgmtDomain[5401]: [ERROR] Bundle download for bundle NSX_T_MANAGER failed. Please log in to VCF Installer (https://10.1.10.250) and resolve any issues causing bundle download failure.
09-02-2026 15:02:04  SddcMgmtDomain[5401]: [ERROR] @{componentType=NSX_T_MANAGER; version=9.0.1.0.24952111; bundleId=028849ee-d3e7-5748-9b90-47d503c6dd3e; downloadId=19f34215-09e5-4039-b260-b1208357f0ff; downloadStatus=FAILED; downloadedSize=0; downloadStartTime=1770649238378; downloadEndTime=1770649323276; downloadScheduledTime=1770649233962; isDownloadCancellable=True; message=LcmException: Patch file /nfs/vmware/vcf/nfs-mount/bundle/depot/local/bundles/028849ee-d3e7-5748-9b90-47d503c6dd3e/028849ee-d3e7-5748-9b90-47d503c6dd3e/nsx-unified-appliance-9.0.1.0.24952114.ova checksum bf449ae1ffebf88b84fbbe28da819918621b7e4782fabc629afbb514fd8dbde9 does NOT match with the element checksum f8176ea21e9b5a0b7f969d148b024de266be49799a89a3c85d93d0aec6c6e82d; isDownloadable=True}
{% endhighlight %}

Removing the mentioned downloads from VCF Installer GUI does not help, because the file stays in the appliance.
Solve it purging the file from it via ssh.

1. ssh from holorouter to vcfinstaller
{% highlight bash %}
# ssh vcf@vcfinstallera.site-a.vcf.lab
# su -
# rm /nfs/vmware/vcf/nfs-mount/bundle/depot/local/bundles/028849ee-d3e7-5748-9b90-47d503c6dd3e/028849ee-d3e7-5748-9b90-47d503c6dd3e/nsx-unified-appliance-9.0.1.0.24952114.ova
{% endhighlight %}
Restart Download from GUI

[Holodeck]: https://vmware.github.io/Holodeck/
[github]: https://github.com/vmware/Holodeck
