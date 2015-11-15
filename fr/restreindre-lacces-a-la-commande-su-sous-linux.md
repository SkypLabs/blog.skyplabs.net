# Restreindre l'accès à la commande "su" sous Linux

**edit**: Sur certaines distributions, comme par exemple Fedora, RHEL et CentOS, la restriction de la commande "su" est déjà intégrée. Il est seulement nécessaire de l'activer en décommentant la ligne suivante dans le fichier */etc/pam.d/su* :

    # Uncomment the following line to implicitly trust users in the "wheel" group.
    auth           sufficient      pam_wheel.so trust use_uid

* * *

La commande **su** permet de changer temporairement son identité pour celle d'un autre utilisateur lorsque l'on est déjà connecté sur une machine UNIX. D'ailleurs, "su" veut dire "Substitute User".

Il peut être très intéressant de restreindre l'accès à cette commande dans le but de renforcer la sécurité de sa machine. On va donc autoriser son exécution seulement aux utilisateurs qui en ont vraiment besoin.

Pour ce faire, je vais utiliser la même méthode que celle utilisée sur FreeBSD, à savoir restreindre l'accès à la commande "su" seulement aux membres du groupe **wheel**. Voici les différentes étapes :

* Création du groupe "wheel" :

        groupadd --system wheel

* Modification du groupe de la commande "su" :

        chown root:wheel /bin/su

* Modification des droits de la commande "su" :

        chmod 4750 /bin/su

* Rajout des utilisateurs autorisés au groupe "wheel" :

        usermod -G wheel -a <user>

Une fois ces manipulations effectuées, il ne vous reste plus qu'à vous reconnecter et à tester le tout.
