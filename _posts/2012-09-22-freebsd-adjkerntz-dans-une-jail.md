---
layout: post
title: "[FreeBSD] adjkerntz dans une jail"
categories:
    - SysAdmin
tags:
    - FreeBSD
    - NTP
---
Le programme adjkerntz (installé par défaut sous FreeBSD) permet de maintenir une relation cohérente entre l'horloge du noyau, qui est toujours configurée à l'heure UTC, et l'horloge locale CMOS, qui peut être configurée au fuseau local.

Cependant, au sein d'une jail, seul le fuseau horaire peut être modifié. La jail utilise donc la même heure que celle configurée sur le système hôte. L'utilisation de la commande adjkerntz va donc provoquer une erreur :

    Sep 22 05:31:00 www adjkerntz[23948]: sysctl(set: "machdep.wall_cmos_clock"): Operation not permitted

Si vous rencontrez des messages similaires dans vos logs, c'est tout simplement parce que la commande adjkerntz est invoquée régulièrement par **cron**. Pour résoudre ce problème, il suffit de commenter la ligne suivante dans le fichier `/etc/crontab` de vos jails :

    # Adjust the time zone if the CMOS clock keeps local time, as opposed to
    # UTC time.  See adjkerntz(8) for details.
    #1,31   0-5     *       *       *       root    adjkerntz -a

Vos logs seront plus propres désormais.
