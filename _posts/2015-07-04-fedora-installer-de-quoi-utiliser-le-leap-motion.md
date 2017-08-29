---
layout: post
title: "[Fedora] Installer de quoi utiliser le Leap Motion"
categories:
    - Logiciel
tags:
    - Leap Motion
    - RPM
---
L'utilisation du [Leap Motion][LM_site_officiel] sur les systèmes GNU/Linux est officiellement supportée mais seul un paquet DEB est fourni. Nous allons donc voir comment le convertir en paquet RPM fonctionnel pour Fedora.

Tout d'abord, vous devez télécharger la dernière version du [Leap Motion Setup][LM_setup] pour Linux :

    wget https://warehouse.leapmotion.com/apps/4143/download -O leap-setup.tgz
    tar zxvf leap-setup.tgz
    cd Leap_Motion_Installer_Packages_release_public_linux/

Ensuite, nous allons utiliser l'outil `alien` pour faire la conversion. Si ce dernier n'est pas installé :

    # Pour Fedora <= 21
    sudo yum install alien
    # Pour Fedora > 21
    sudo dnf install alien

<!--more-->

Nous pouvons maintenant procéder à la conversion :

    sudo alien -r Leap-*-x64.deb

Nous pourrions nous dire que notre paquet RPM est prêt à être installé mais voici ce qui se passe lorsque l'on tente l'installation dans l'état actuel des choses :

    sudo rpm -ivh leap-*.x86_64.rpm
    Preparing...                          ################################# [100%]
    file /lib from install of leap-2.2.7+30199-2.x86_64 conflicts with file from package filesystem-3.2-28.fc21.x86_64
    file /usr/lib from install of leap-2.2.7+30199-2.x86_64 conflicts with file from package filesystem-3.2-28.fc21.x86_64
    file /usr/bin from install of leap-2.2.7+30199-2.x86_64 conflicts with file from package filesystem-3.2-28.fc21.x86_64
    file /usr/sbin from install of leap-2.2.7+30199-2.x86_64 conflicts with file from package filesystem-3.2-28.fc21.x86_64

Pour résoudre les conflits avec le paquet `filesystem`, nous allons utiliser l'outil `rpmrebuild` :

    # Pour Fedora <= 21
    sudo yum install rpmrebuild
    # Pour Fedora > 21
    sudo dnf install rpmrebuild

Ce dernier nous permet d'éditer le fichier `Spec` d'un paquet RPM. Il est possible de préciser quel éditeur de texte nous souhaitons utiliser à l'aide de la variable d'environnement `EDITOR` :

    export EDITOR=/usr/bin/vim

Nous pouvons maintenant exécuter `rpmrebuild` :

    rpmrebuild -pe leap-*.x86_64.rpm

Il nous faut maintenant supprimer les lignes `%dir` qui posent problème, à savoir :

    %dir %attr(0755, root, root) "/lib"
    %dir %attr(0755, root, root) "/usr/bin"
    %dir %attr(0755, root, root) "/usr/lib"
    %dir %attr(0755, root, root) "/usr/sbin"

Une fois supprimées, vous pouvez enregistrer et quitter l'éditeur de texte. Une confirmation vous sera demandée par la suite, à laquelle il faut répondre oui. Le nouveau paquet RPM sera disponible dans `~/rpmbuild/RPMS/x86_64`. Il ne vous reste plus qu'à procéder à l'installation :

    cd ~/rpmbuild/RPMS/x86_64
    sudo rpm -ivh leap-*.x86_64.rpm

[LM_site_officiel]: https://www.leapmotion.com/
[LM_setup]: https://warehouse.leapmotion.com/apps/4186/download
