---
layout: post
title: "[OpenSSH] Too many authentication failures for root"
categories:
    - SysAdmin
tags:
    - OpenSSH
---
Si vous recevez le message "*Too many authentication failures for root*" lors de l'établissement d'une connexion SSH, c'est généralement dû à un trop grand nombre de tentatives de connexion par clé publique. En effet, si le serveur autorise les connexions par clé et que celle destinée à ce serveur n'est pas spécifiée au client SSH, ce dernier va tester toutes les clés disponibles au moment de la connexion.

Pour palier ce problème, trois solutions s'offrent à nous :

* Soit forcer l'utilisation du mot de passe de la façon suivante :

        ssh -o "PubkeyAuthentication no" user@host

* Soit forcer l'utilisation d'une clé à l'aide de l'option `-i` :

        ssh -i <chemin/vers/la/clé> user@host

* Soit spécifier la clé à utiliser dans le fichier de configuration du client SSH (`/etc/ssh/ssh_config`) :

        Host <host>
        IdentityFile <chemin/vers/la/clé>
        IdentitiesOnly yes
