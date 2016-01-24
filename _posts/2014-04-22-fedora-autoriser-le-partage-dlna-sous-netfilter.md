---
layout: post
title: "[Fedora] Autoriser le partage DLNA sous Netfilter"
categories:
    - SysAdmin
tags:
    - Fedora
    - DLNA
    - Netfilter
    - GNOME 3
---
GNOME 3 intègre dans le panel des options une rubrique de partage permettant entre autres de diffuser du contenu multimédia en DLNA. Le serveur sous-jacent utilisé se nomme **rygel** et ce dernier utilise un port d'écoute TCP dynamique.

Seulement voila, **Netfilter** n'est pas configuré par défaut pour laisser passer le trafic DLNA, et encore moins pour détecter quel port d'écoute est utilisé par rygel. Il est donc nécessaire d'entreprendre quelques actions pour rectifier la situation :

1. Modifier le port d'écoute de rygel. Pour cela, il faut modifier la ligne `port=0` (dynamique) par `port=65530` dans le fichier de configuration `/etc/rygel.conf`. Bien entendu, le choix du numéro du port est complètement arbitraire.
2. Autoriser le port **TCP 65530** et le port **UDP 1900** en entrée dans la configuration de Netfilter. On pourra utiliser l'outil graphique "firewall" par exemple pour réaliser cette tâche.
3. Redémarrer rygel.

Il ne vous reste plus qu'à tester le bon fonctionnement de votre modification en utilisant un client DLNA sur un autre appareil pour lancer la lecture d'un film par exemple :)
