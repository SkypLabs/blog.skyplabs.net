---
layout: post
title: "Sniffer le réseau avec Wireshark sans le compte root"
categories:
    - SysAdmin
    - Hacking et Sécurité
    - Réseau
tags:
    - Wireshark
---
Wireshark est un outil d'analyse qui permet de "sniffer" les informations qui passent à travers les interfaces réseau du système sur lequel il est installé. Il est très utilisé car c'est un logiciel complet, multiplateforme et libre. Je me demande d'ailleurs pourquoi je perds mon temps à vous le présenter étant donné que je suis sûr qu'il est déjà installé sur votre ordinateur ou même sur votre téléphone pour les plus bidouilleurs d'entre vous ...

Ceci étant, pour pouvoir sniffer le réseau avec cet outil, vous devez le lancer depuis le compte root pour qu'il puisse passer la carte réseau sélectionnée pour la capture en mode **promiscuous**, ce qui n'est pas très bon pour la sécurité de votre machine. En effet, Wireshark n'est pas réputé pour sa sécurité sans faille. D'ailleurs, une simple recherche dans la **[National Vulnerability Database][NVD]** (NVD) retourne 110 résultats, ce qui est déjà pas mal.

![Capture d'écran du résultat de la recherche à propos de Wireshark sur le site de la NVD][NVD Wireshark]

Pour pouvoir quand même récupérer le trafic réseau sans lancer Wireshark avec le compte root, nous allons nous servir de l'outil `dumpcap` (qui est inclus dans le paquet `wireshark-common`) pour la capture et Wireshark servira seulement à traiter les informations recueillies. Voici donc comment faire :

{% highlight bash linenos %}
sudo dumpcap -i eth0 -w - | wireshark -k -i -
{% endhighlight %}

Grâce à cette méthode, vous pouvez utiliser pleinement les fonctionnalités de Wireshark en live en prenant un minimum de risques.

[NVD]: https://nvd.nist.gov/
[NVD Wireshark]: {{ site.url }}/images/NVD-Wireshark.png "Capture d'écran du résultat de la recherche à propos de Wireshark sur le site de la NVD"
