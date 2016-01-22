---
layout: post
title: "[Bash] Remplacement de la forme key=value dans un fichier texte"
categories:
    - Développement
tags:
    - Bash
---
La regex ci-dessous utilisée avec le programme `sed` permet de remplacer l'ancienne valeur attribuée à "KEY" par la nouvelle valeur "VALUE" dans le fichier "file" :

    sed -i "s/\(KEY *= *\).*/\1VALUE/" <file>

Par exemple, pour remplacer le nom d'hôte d'un système CentOS par la valeur contenue dans `$host_name` :

    sed -i "s/\(HOSTNAME *= *\).*/\1$host_name/" /etc/sysconfig/network
