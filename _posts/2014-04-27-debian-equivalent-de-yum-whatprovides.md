---
layout: post
title: "[Debian] Équivalent de \"yum whatprovides\""
categories:
    - SysAdmin
tags:
    - RPM
    - yum
---
Les outils **apt-get** et **aptitude** ne possèdent pas d'équivalent à l'option `whatprovides` de yum. Cependant, il existe un logiciel nommé **apt-file** capable de remplir cette tâche :

    aptitude install apt-file
    apt-file update
    apt-file search <file>
