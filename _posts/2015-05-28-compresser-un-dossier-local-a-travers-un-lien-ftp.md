---
layout: post
title: "Compresser un dossier local à travers un lien FTP"
categories:
    - SysAdmin
tags:
    - FTP
    - Backup
---
J'ai récemment dû faire une sauvegarde d'un dossier se trouvant sur un serveur distant afin de l'envoyer sur un serveur FTP. Cependant, il m'a été impossible de créer une archive compressée de ce dossier sur le serveur distant car pas assez d'espace libre. La solution a été de ne pas stocker le résultat de la compression en local sur le serveur sur lequel se trouve le dossier à sauvegarder, mais de l'envoyer directement sur le FTP.

Pour ce faire, une fois connecté au serveur FTP depuis le serveur distant en utilisant l'outil `ftp` :

    ftp> put "| tar cvf - folder/ | gzip " folder.tar.gz

*folder* correspond donc au dossier local à sauvegarder et *folder.tar.gz* au nom de l'archive compressée qui résultera de ce procédé (placée sur le FTP donc).
