---
layout: post
title: "Faire un update-grub depuis un live CD/USB"
categories:
    - SysAdmin
tags:
    - GRUB
---
Sur toutes les machines dont je dispose à mon domicile, je n'ai installé Windows que sur une seule d'entre elles en multiboot avec Ubuntu (et oui, il faut avouer qu'avoir un Windows sous la main est toujours utile malgré tout). Cependant, ce vilain petit canard m'a causé quelques soucis lorsque j'ai réinstallé mes systèmes sur cet ordinateur (à cause d'un changement de disque dur).

En effet, j'ai installé Ubuntu avant Windows car je n'avais pas son disque de réinstallation à ce moment là (prêté à quelqu'un). J'ai donc laissé 100 Go au début de mon disque dur pour le futur Windows et installé Ubuntu sur le reste de l'espace disponible. Lors de l'installation de Windows, ce dernier m'a écrasé le [MBR][MBR] (comme d'hab ...) mais j'avais prévu le coup, ayant installé Grub dans le [PBR][VBR] (ou [VBR][VBR]) de ma partition. Malgré tout, Ubuntu refuse de démarrer (contrairement à Windows, lancé depuis un bootloader appelé [GAG][GAG] installé dans le [MBR][MBR]), une belle console de récupération Grub à l'écran ...

<!--more-->

Ce n'est qu'après coup que j'ai compris le soucis : après l'installation de Windows, l'ordre des partitions a changé et Grub essaye de charger le noyau Linux depuis une mauvaise partition. Pour régler ce problème, il suffit de lancer la commande `update-grub` pour mettre à jour la configuration de ce dernier. Seul soucis : comment lancer cette commande si on est pas déjà sur le système ? C'est là qu'on sort son bon vieux **Live CD/USB** !

Donc pour la manipulation (sur le Live CD/USB), en supposant que la partition du système GNU/Linux à récupérer soit `sdb1` :

	mount /dev/sdb1 /mnt
	mount --bind /dev /mnt/dev
	mount --bind /proc /mnt/proc
	mount --bind /sys /mnt/sys
	chroot /mnt
	update-grub

Logiquement, tout devrait bien se passer. Une fois la configuration de Grub mise à jour, vous pouvez redémarrer l'ordinateur et profiter de votre distribution fraîchement installée !

[MBR]: https://en.wikipedia.org/wiki/Master_boot_record
[VBR]: https://en.wikipedia.org/wiki/Volume_boot_record
[GAG]: http://gag.sourceforge.net/
