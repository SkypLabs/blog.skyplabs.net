---
layout: post
title: "Quitter sa console sans stopper les processus en cours d'exécution"
categories:
    - SysAdmin
tags:
    - nohup
---
Ne vous est-il jamais arrivé de devoir quitter votre session actuelle alors qu'un programme en cours d'exécution n'a pas terminé son traitement ? Le contraire serait étonnant. Par exemple, vous avez lancé l'extraction d'une base de données par SSH pour en faire un backup et vous n'avez pas le temps d'attendre gentiment devant votre terminal que son exécution se termine.

Le fait est que lorsqu'on demande de fermer sa session (commande exit, ctl+D, ...), le processus faisant tourner le shell envoie un signal [SIGHUP][SIGHUP] à tous ses enfants pour demander leur arrêt. Des tâches comme l'extraction d'une base de données citée dans mon exemple prendront fin à l'instant où la session sera fermée.

<!--more-->

Pour modifier ce comportement, il existe une commande appelée `nohup` qui permet d'indiquer à un programme de ne pas réagir lors de la réception d'un signal [SIGHUP][SIGHUP] et donc de poursuivre son exécution même après la fermeture de la session ayant servi à le lancer. Concrètement, il faut passer en argument à la commande `nohup` la commande désirée à proprement parlé pour empêcher sa fermeture. Les canaux de sortie et d'erreur standards sont redirigés par défaut vers un fichier appelé `nohup.out`. On peut bien entendu préciser explicitement vers quel fichier on veut rediriger ces canaux.

Je précise qu'il est préférable de lancer la commande en tâche de fond pour pouvoir fermer sa session proprement comme dans l'exemple suivant :

	nohup mysqldump -u root -pmonsuperpassword --all-databases > mon_backup.db &
	exit

Lors de l'ouverture de la prochaine session, vous trouverez donc le résultat de la commande `mysqldump` dans le fichier `mon_backup.db`.

Aussi simple que ça !

[SIGHUP]: https://en.wikipedia.org/wiki/SIGHUP
