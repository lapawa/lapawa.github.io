---
layout: post
title:  "VMware Remote Console - für Linux"
date:   2016-09-02 12:00:00
categories: linux vmware
---

Was lange währt wird endlich gut. VMware hatte schon vor längerem angekündig die VMware Remote Console auch auf Linux lauffähig zu machen. Mit Version 9 der (VMRC) ist es nun so weit. Die [Release Notes] führen als Neuerung die Unterstützung von Linux Systemen auf.

Großartig. Endlich sind neben Windows und Mac User auch Nutzer diverser Linux Derivate in der Lage die Konsole einer VMware virtuellen Maschine mit einem Full-Feature-Client zu bedienen. Und das ohne den Umweg über VMware Workstation oder Player.

Drauf gekommen bin ich über den vSphere [HTML5 Web Client] für vCenter 6.
Er gibt einem die Url für den [aktuellen VMRC Download]. Für den ca. 60MB großen Download benötigt man einen my.vmware.com Account.
![Launch VMRC Screenshot]({{ site.url }}/assets/2016-09-01_html5-client-launch-vmrc.jpg)

Als Gegenstück auf der VMware Seite werden durch VMRC9 nicht nur Verbindugnen zum vCenter Server, sondern auch
zum vRealize Automation unterstützt. Damit ist die VMRC nicht nur für vSphere Administratoren interessant,
sondern kann durchaus auch auf den Desktops von Endanwendern landen die keinen direkten Zugang zur virtuellen Infrastruktur haben, sondern ihre virtuellen Server über das Self Service Portal provisionieren.


### Installation
Schauen wir uns also an, wie die Software sich auf einem Xubuntu 16.04.1LTS schlägt.
Nach dem Download machen wir das '.bundle' file ausführbar und starten das Skript per sudo
{% highlight batch %}
chmod +x VMware-Remote-Console-9.0.0-4288332.x86_64.bundle
sudo ./VMware-Remote-Console-9.0.0-4288332.x86_64.bundle
{% endhighlight %}
Eventuell verweigert der Installer seinen Dienst mit einer Meldung über nicht aufgelöste Abhängigkeiten.

![VMware Installer - unmet dependency]({{site.url}}/assets/2016-09-02_vmrc-installer-failed-dependency.png)

In meinem Fall lag das an einer bereits installierten VMware Workstation 12.1. Die beiden Produkte können offensichtlich nicht gleichzeitig auf dem selben System installiert sein. Was auch wenig Sinn ergibt, da VMware Workstation eine VMRC bereits mitbringt.
Also deinstallieren wir die Workstation erstmal.

{% highlight bash %}
vmware-installer  --uninstall-product=vmware-workstation```
{% endhighlight %}
Und starten die Installation erneut.


### Fehlersuche beim Installer
Wer sich für die Details der Installers interessiert, kann dessen Loglevel auf DEBUG hochschrauben.
{% highlight bash %}
sudo VMIS_LOG_LEVEL=DEBUG /home/zarq/Downloads/VMware-Remote-Console-9.0.0-4288332.x86_64.bundle
{% endhighlight %}
Und die Ausgaben parallel im Logfile verfolgen.
{% highlight bash %}
tail -f /var/log/vmware-installer
{% endhighlight %}

### Auflistung der installierten VMware Komponenten
Der VMware installer führt sehr genau Buch darüber was bereits auf dem System installiert ist.
So kann er die die Produkte und deren Komponenten auflisten.
{% highlight bash %}
$ vmware-installer --list-products
Product Name         Product Version     
==================== ====================
vmware-vmrc          9.0.0.4288332       

$ vmware-installer --list-components
Component Name       Component Long Name                      Component Version   
==================== ======================================== ====================
vmware-installer     VMware Installer                         2.1.0.4288174       
vmware-player-setup  VMware Remote Console Setup              9.0.0.4288332       
vmware-usbarbitrator VMware USB Arbitrator                    15.1.6.4288332      
vmware-vmrc-app      VMware Remote Console                    9.0.0.4288332       
vmware-vmrc          VMware Remote Console                    9.0.0.4288332       
{% endhighlight %}

### Nutzen der VMRC
Ist die VMRC erfolgreicht installiert, so kann sie direkt aus dem vSphere Web Client bzw HTML5 Client verwendet werden.
Denn sie wurde als Protokollhandler für URLs die mit vmrc:// beginnen registriert. Das Verfahren gilt für alle dem freedesktop Standard folgenden Linux Desktop Umgebung und in diesem [Custom URI Handler] Artikel beschrieben.
Hier ein Beispiel für den Aufruf aus dem HTML5 Client:


```vmrc://clone:cst-VCT-52597724-f4c2-3a6d-a2fb-16692a099ced--tp-76-5B-1B-87-85-C2-5F-5A-A1-21-34-A8-6B-56-82-10-16-53-4F-E5@vcsa.lpw.pri```

William Lam hat vor einiger Zeit auf seinem Blog [VirtuallyGhetto] das Format dieser URL beschrieben.

Damit stehen für Linux Nutzer gleich zwei Konsolenzugänge zur Verfügung. Zum einen die in den vSphere Web Client integrierte HTML5 Konsole. Sie bietet einen Out-Of-The-Box Zugang zur VM, hat dafür aber eine begrenzte Funktionalität.

Und zum Anderen können wir uns über die 'echte' VMRC freuen und einer VM [MagicSysReq] senden oder sie mit lokalen USB Geräten verbinden.
Die Verknüpfung zur VMRC wird in dieser Datei ```/usr/share/applications/vmware-vmrc.desktop``` beschrieben.

### Ausblick
Der Zugriff auf die VMware Konsole per Linux Client ist nun möglich. Eine Sinnvolle Weiterentwicklung des Tools wäre in meinen Augen die Erweiterung um eine Katalogverwaltung  der Verbindungen. So wie man es von anderen Remote Desktop Tools kennt. Durch das URL Schema ließe es sich sogar mit überschaubarem Aufwand in bestehende Tools wie etwa [Remmina] integrieren.
Dies würde den Zugang zu den 'eigenen' VMs völlig unabhängig von dem vCenter Web Client machen und ein flottes Arbeiten ermöglichen.

[HTML5 Web Client]: https://labs.vmware.com/flings/vsphere-html5-web-client
[aktuellen VMRC Download]: https://www.vmware.com/go/download-vmrc
[Release Notes]: http://pubs.vmware.com/Release_Notes/en/vmrc/90/vmrc-90-release-notes.html
[MagicSysReq]: https://www.kernel.org/doc/Documentation/sysrq.txt
[VirtuallyGhetto]: http://www.virtuallyghetto.com/2014/10/standalone-vmrc-vm-remote-console-re-introduced-in-vsphere-5-5-update-2b.html
[Custom URI handler]: http://edoceo.com/howto/xfce-custom-uri-handler
[Remmina]: http://www.remmina.org
