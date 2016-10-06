---
layout: post
title:  "VMware Perl SDK auf Ubuntu 16.04 Xenial"
date:   2016-10-06 12:00:00
categories: linux vmware
---

Das VMware Perl SDK prüft vor der Installation ob benötigte Perl Module auf dem System vorhanden sind. Ist dies nicht
der Fall, werden sie per [CPAN] nachinstalliert. Und dies obwohl das Package Repository von Ubuntu die notwendigen Perl
Module bereits als .deb Pakete vorhällt. Ein Paket von der Distribution sollte jedoch einer CPAN Installation vorgezogen
werden. 
Mit dieser Anleitung werden wir das umsetzen und das System mit den notwendigen Paketen präparieren,
so dass der VMware Installer keine Abhängigkeiten auflöst und nur das Perl SDK selbst installiert.

### Perl SDK von VMware
Worum geht es überhaupt. VMware stellt zur Nutzung der [vSphere] API von [vCenter Server] und [ESXi] das Perl SDK
kostenlos zur Verfügung. Darin enthalten sind neben den Perl Modulen für eigene Skripte auch die Remote CLI Kommandos
*vicli-\**.
D.h. eine Installation lohnt sich auch dann, wenn keine eigenen Perl Skripte geschrieben werden sollen, dafür aber
die Konfiguration der vSphere Umgebung per CLI geschehen soll. Alternativ bietet sich dafür aber auch die [VMware VIMA] an.
Die Einstiegsseite zum Perl SDK befindet sich auf der Entwickler Seite von VMware dem [Developer Center].
Dort findet man die [Release Notes] und einen Link zum Download per [my vmware]. 
Für diesen Artikel wurde das 64Bit Perl SDK in der Version 6.0.2 \[3561779\] verwendet.

Nach dem Download wird das tar Archiv zunächst entpackt:
{% highlight bash %}
root@tuxedo:~# tar xfz VMware-vSphere-Perl-SDK-6.0.0-3561779.x86_64.tar.gz
{% endhighlight %}

Das Installationsskript befindet sich nun hier: *vmware-vsphere-cli-distrib/vmware-install.pl*.
Bevor wir es als *root* starten werden wir das Linux System noch vorbereiten.

### Auflösen der Abhängigkeiten
Per *apt* werde zunächst eine Reihe Perl Module installiert.
{% highlight bash %}
root@tuxedo:~# apt install perl-doc libssl-dev libdevel-stacktrace-perl libclass-data-inheritable-perl
libcrypt-openssl-rsa-perl libcrypt-x509-perl libexception-class-perl libpath-class-perl libtry-tiny-perl
libcrypt-ssleay-perl libuuid-perl libpath-class-perl libdata-dump-perl libsoap-lite-perl libxml-sax-perl
libxml-namespacesupport-perl libxml-libxml-perl libmodule-build-perl libnet-inet6glue-perl libclass-methodmaker-perl
{% endhighlight %}

### Die Details
Wer es genau wissen will, sollte einen Blick in das Installerskript *vmware-install.pl* werfen.
Dort sind verschiedene Perl Array definiert, die die Abhängigkeiten Auflisten. Z.B. *my \@modules* liefert alle
Perl Module mit einer mindest Version. Besonders störend sind jedoch die Einträge im Array *my @module_to_verify*
denn die hier enthaltenen Module müssen exakt in der Version übereinstimmen.
{% highlight perl %}
   my @module_to_verify = (
      {'module' => 'ExtUtils::MakeMaker',  'version' => '6.96',    'path' => 'BINGOS/ExtUtils-MakeMaker-6.96.tar.gz'},
      {'module' => 'Module::Build',        'version' => '0.4205',  'path' => 'LEONT/Module-Build-0.4205.tar.gz'},
      {'module' => 'Net::FTP',             'version' => '2.77',    'path' => 'GBARR/libnet-1.22.tar.gz'},
      {'module' => 'LWP',                  'version' => '5.837',   'path' => 'GAAS/libwww-perl-5.837.tar.gz'}
   );
{% endhighlight %}
So zeigt der Aufruf von
{% highlight bash %}
root@tuxedo:~# perl -e 'use ExtUtils::MakeMaker; print "$ExtUtils::MakeMaker::VERSION\n"'
7.0401
{% endhighlight %}
dass Version 7.0401 bereits auf dem System vorhanden ist. Dies kommt aus dem Ubuntu perl core Paket [perl-modules-5.22].
Der Installer verlang jedoch nach Version 6.96.
Diese Restriktionen lassen sich nicht auflösen. Daher werden wir den Installer Patchen und damit die Einträge
auskommentieren und die Abhängigkeiten aufweichen.
{% highlight patch %}
2466,2469c2466,2469
<       {'module' => 'ExtUtils::MakeMaker',  'version' => '6.96',    'path' => 'BINGOS/ExtUtils-MakeMaker-6.96.tar.gz'},
<       {'module' => 'Module::Build',        'version' => '0.4205',  'path' => 'LEONT/Module-Build-0.4205.tar.gz'},
<       {'module' => 'Net::FTP',             'version' => '2.77',    'path' => 'GBARR/libnet-1.22.tar.gz'},
<       {'module' => 'LWP',                  'version' => '5.837',   'path' => 'GAAS/libwww-perl-5.837.tar.gz'}
---
> #      {'module' => 'ExtUtils::MakeMaker',  'version' => '6.96',    'path' => 'BINGOS/ExtUtils-MakeMaker-6.96.tar.gz'},
> #      {'module' => 'Module::Build',        'version' => '0.4205',  'path' => 'LEONT/Module-Build-0.4205.tar.gz'},
> #      {'module' => 'Net::FTP',             'version' => '2.77',    'path' => 'GBARR/libnet-1.22.tar.gz'},
> #      {'module' => 'LWP',                  'version' => '5.837',   'path' => 'GAAS/libwww-perl-5.837.tar.gz'}
{% endhighlight %}

### Eine Ausnahme bleibt

Das Perl Modul *UUID::Random* ist winzig, aber leider nicht als Debian Paket vorhanden.
Daher werden wir uns ein Paket bauen lassen. Dazu benötigen wir weitere Tools die wir nach dem Ablauf wieder entfernen
können.
{% highlight bash %}
root@tuxedo:~# apt install -y dh-make-perl build-essential
root@tuxedo:~# dh-make-perl --build --cpan UUID::Random
root@tuxedo:~# dpkg -i libuuid-random-perl_0.04-1_all.deb
root@tuxedo:~# apt purge dh-make-perl build-essential
root@tuxedo:~# apt autoremove
{% endhighlight %}
Sorry. An dieser Stelle machen wir doch Gebrauch vom CPAN Tool. Immerhin bleiben wir bei Debian Paketen und überlassen
die Installation alleine der Paketverwaltung von Ubuntu.

### Installation
Damit ist die letzte Hürde genommen und das System vorbereitet. Wir können mit der Installation des Perl SDK beginnen
und den Answeisungen folgen.
{% highlight bash %}
root@tuxedo:~# ./vmware-installer.pl
{% endhighlight %}

### Ausprobieren und weiter Beispiele
Die Remote CLI ist nun ebenfalls installiert und mit Aufrufen wie
{% highlight bash %}
root@tuxedo:~# vicfg-nics --username root --server vesx80.lpw.pri -l
{% endhighlight %}
können z.B. die Netzwerkkarten einese ESXi Hosts aufgelistet werden.
Eine vollständige Referenz der vcli befindet sich auf der [vcli doc] Seite.

Der VMware Blogger William Lam hat auf seinem Github Repository [vghetto-scripts] eine Reihe weitere Perl Beispiele die
gut als Vorlage für eigene Umsetzungen dienen können.


[CPAN]: https://www.perl.org/cpan.html
[vCenter Server]: http://www.vmware.com/products/vcenter-server.html
[ESXi]: http://www.vmware.com/products/esxi-and-esx.html
[vSphere]: http://www.vmware.com/products/vsphere.html
[VMware VIMA]: https://www.vmware.com/support/developer/vima/
[Developer Center]: http://developercenter.vmware.com/web/sdk/60/vsphere-perl
[my vmware]: https://my.vmware.com/group/vmware/get-download?downloadGroup=PERLSDK60U2
[perl-modules-5.22]: http://packages.ubuntu.com/xenial/all/perl-modules-5.22/filelist
[Release Notes]: http://pubs.vmware.com/Release_Notes/en/viperl/60/vsp602_vsperl_relnotes.html
[vghetto-scripts]: https://github.com/lamw/vghetto-scripts/tree/master/perl
[vcli doc]: http://pubs.vmware.com/vsphere-60/topic/com.vmware.vcli.ref.doc/vcli-right.html