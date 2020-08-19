---
layout: post
title: "[Linux] Mettre à jour l'heure de son système par internet sans NTP"
categories:
    - SysAdmin
tags:
    - Linux
    - NTP
---
Voici une astuce trouvée sur un [forum][topic_forum] permettant de mettre à jour l'heure d'un système sous Linux par internet mais sans utiliser NTP :

    date -s "$(wget -S  "https://www.google.com/" 2>&1 | grep -E '^[[:space:]]*[dD]ate:' | sed 's/^[[:space:]]*[dD]ate:[[:space:]]*//' | head -1l | awk '{print $1, $3, $2,  $5 ,"GMT", $4 }' | sed 's/,//')"

Le principe est d'utiliser le champ `Date` se trouvant dans les en-têtes **HTTP** de la réponse d'un serveur web lors d'une requête vers celui-ci. Il faut cependant s'assurer que le serveur web contacté soit à l'heure, lui ! Le choix du moteur de recherche Google est donc une bonne idée.

L'utilisation de cette méthode se justifie lorsque l'on veut mettre à jour l'heure d'une machine se trouvant derrière un proxy.

[topic_forum]: https://superuser.com/questions/307158/how-to-use-ntpdate-behind-a-proxy/465838#465838 "How to use ntpdate behind a proxy"
