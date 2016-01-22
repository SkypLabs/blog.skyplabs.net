---
layout: post
title: "[Android] Supprimer une application native à une ROM"
categories:
    - SysAdmin
tags:
    - Android
---
Les différents composants du système d'exploitation Android sont installés sur différentes partitions de manière à séparer les données du système de celles des applications utilisateurs. On retrouve donc la partition **system** qui est montée en lecture seule (ro), et la partition **data** qui elle est montée en lecture/écriture (rw).

Cependant, il arrive de trouver dans certaines ROMs des applications utilisateurs installées par défaut dans la partition système. C'était justement le cas de la ROM SFR installée sur le Nexus One de ma copine. L'application Twitter y était installée nativement sans possibilité de la désinstaller.

Pour remédier à ce désagrément, il est nécessaire d'avoir accès au compte **root** pour pouvoir monter temporairement la partition système en rw. De plus, l'installation du [SDK][android_sdk] va nous permettre de récupérer le shell de notre androphone directement depuis un ordinateur (pour pouvoir utiliser un vrai clavier physique).

Les étapes de réalisation sont les suivantes :

1. Activer le mode **USB debugging** de votre androphone.
2. Une fois connecté à votre ordinateur et après avoir installé le SDK, utiliser la commande `adb shell` pour récupérer le shell de votre androphone.
3. Changer d'utilisateur pour root grace à la commande `su`.
4. Monter la partition système en rw en faisant :

        mount -o remount,rw -t yaffs2 /dev/block/mtdblock3 /system

    Bien entendu, il vous faut adapter ces paramètres selon ce que la commande `mount` vous renvoie comme informations sur la configuration de votre appareil.

5. Vous pouvez maintenant supprimer les applications indésirables situées dans le répertoire `/system/app` en utilisant simplement la commande `rm`. Par exemple :

        rm /system/app/twitter.apk

6. Une fois terminé, remonter la partition system en ro en faisant :

        mount -o remount,ro -t yaffs2 /dev/block/mtdblock3 /system

En plus de permettre de faire le ménage, le fait de supprimer certaines applications natives inutiles permet un gain de place non négligeable sur les appareils qui ne disposent que de peu de mémoire interne.

Sur ce, joyeux noël !

[android_sdk]: http://developer.android.com/sdk/index.html "Android SDK"
