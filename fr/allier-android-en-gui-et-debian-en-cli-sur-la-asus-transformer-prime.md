# Allier Android en GUI et Debian en CLI sur la Asus Transformer Prime

Ça y est, j'ai enfin reçu ma tablette tactile, la Asus Transformer Prime !

Pour ceux qui ne la connaissent pas, c'est une tablette qui a la particularité d'être vendue avec un dock clavier (une station d'accueil) lui permettant de se transformer (d'où son nom) en petit ordinateur. Une fois montée sur le dock, on a réellement l'impression que c'est un netbook.

Le principal intérêt de cette tablette est donc son utilisation en tant qu'ordinateur. C'est pour cette raison que je trouvais dommage de devoir se limiter aux applications Android qui ne sont pas particulièrement adaptées à l'ensemble des usages qu'en ferait une personne expérimentée dans le domaine de l'informatique. Par exemple, comment compiler un programme développé en C sous Android ? Et comment implémenter ce dernier dans une carte microcontrôleur ? Ou comment scanner un réseau dans le but de faire un audit de sécurité ? C'est donc pour combler ces manques que je me suis décidé à installer une distribution Debian dans un environnement confiné au sein de l'arborescence du système Android afin de pouvoir récupérer facilement l'ensemble des outils dont j'ai besoin.

Les systèmes Android et Debian reposent tous les deux sur un noyau Linux, ce qui va nous permettre de les faire cohabiter. Dans un premier temps, il est nécessaire de récupérer le compte **root** de la machine, sans quoi aucune des manipulations qui vont suivre ne seront possibles. Étant donné que les constructeurs refusent de donner l'accès à ce compte aux utilisateurs et que le bootloader de la Asus Transformer Prime est verrouillé par défaut, le seul moyen restant est d'utiliser un **local exploit root**. Pour cela, je vous laisse trouver les informations et exploits nécessaires sur le web, en particulier sur le forum de [XDA Developers][1]. Une fois le compte root récupéré, je vous conseille d'utiliser l'application **OTA RootKeeper** (disponible sur l'Android Market) qui permet de faire une "sauvegarde du compte root" pour ne pas le perde après une mise à jour du firmware.

<!--more-->

Il est maintenant temps de passer aux choses sérieuses. Nous allons déployer l'arborescence d'une distribution Debian dans un dossier du file system d'Android pour ensuite pouvoir y accéder grâce à l'appel système **chroot**. Pour commencer, occupons nous de construire notre futur environnement Debian. Nous allons utiliser l'outil **debootstap** pour remplir cet objectif. Depuis un ordinateur classique :

    debootstrap --foreign --arch armel wheezy mydebian
    tar cf mydebian.tar mydebian

Pour la suite, il va nous falloir transférer l'archive de la Debian fraîchement crée sur la Transformer Prime. Pour cela, on peut soit monter la partition sdcard de la tablette sur l'ordinateur, soit utiliser l'utilitaire **adb** du SDK d'Android :

    adb push mydebian.tar /sdcard/mydebian.tar

Et maintenant, il ne reste plus qu'à tout extraire et à finaliser l'installation (sur la tablette, en utilisant les outils de busybox de préférence) :

    cd /data/local/tmp
    tar xf /sdcard/mydebian.tar
    MYDEB=/data/local/tmp/mydebian
    mount --bind /dev $MYDEB/dev
    mount --bind /proc $MYDEB/proc
    mount --bind /sys $MYDEB/sys
    mount --bind /dev/pts $MYDEB/dev/pts
    mount /data -o remount,dev
    export PATH=/bin:/sbin:/usr/bin:/usr/sbin
    /system/xbin/chroot $MYDEB /debootstrap/debootstrap --second-stage
    mount /data -o remount,nodev

Votre distribution Debian est maintenant complètement installée sur votre Transformer Prime ! Il faut maintenant procéder à quelques réglages de routine dont voici une liste non exhaustive :

* Changer le hostname :

        sysctl kernel.hostname=<nouveau_nom>

* Ajouter un DNS publique pour pouvoir y accéder de n'importe où (personnellement, j'utilise celui de Google, à savoir 8.8.8.8) :

        echo "nameserver 8.8.8.8" > /etc/resolv.conf

* Remplir le fichier /etc/apt/sources.list pour pouvoir utiliser **aptitude** ou **apt-get** :

        echo "deb http://ftp.fr.debian.org/debian/ sid main" > /etc/apt/sources.list
        echo "deb-src http://ftp.fr.debian.org/debian/ sid main" >> /etc/apt/sources.list

Et pour pouvoir revenir facilement dans l'environnement confiné de la Debian, j'utilise le script suivant (initialement écrit par mon ami **Peck** - [Une distribution GNU sur Android - Linux-attitude][2]) :

    ROOT=/data/local/tmp/mydebian
    BB=/system/xbin
    if ! ls $ROOT/proc/1 > /dev/null
    then
        $BB/mount --bind /dev $ROOT/dev
        $BB/mount --bind /proc $ROOT/proc
        $BB/mount --bind /sys $ROOT/sys
        $BB/mount --bind /dev/pts $ROOT/dev/pts
    fi
    export PATH=/bin:/sbin:/usr/bin:/usr/sbin
    $BB/chroot $ROOT /bin/su -c "/bin/bash"

Il ne reste plus qu'à automatiser notre passage de l'environnement Android vers notre nouvel environnement Debian. J'utilise pour ma part l'application Android **Terminal emulator** (disponible sur l'Android Market) comme console locale avec l'option **initial command** configurée de cette manière (le script go2deb.sh est celui affiché plus haut) :

    export PATH=/system/xbin:$PATH; cd /data/local/tmp; su -c "./go2deb.sh"

De cette façon, à chaque lancement d'un nouveau terminal, on arrivera directement dans la Debian.

Vous pouvez maintenant profiter pleinement de votre Transformer Prime, que ce soit en tablette sous Android ou en ordinateur sous Debian.

 [1]: http://forum.xda-developers.com/forumdisplay.php?f=1411 "Forum - XDA Developers"
 [2]: http://linux-attitude.fr/post/une-distribution-gnu-sur-android#more-1380 "Une distribution GNU sur Android - Linux Attitude"
