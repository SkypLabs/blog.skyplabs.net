Le première chose à faire avant de chercher à envoyer le nouveau firmware sur l'équipement est de vérifier l'espace disponible dans la mémoire flash interne :

    dir flash:

La dernière ligne retournée sera quelque chose ressemblant à ceci :

    7741440 bytes total (2983424 bytes free)

Dans le cas éventuel où vous devez libérer de la place :

    delete flash:<file to delete>

Maintenant passons aux choses sérieuses. Pour envoyer le nouveau firmware en utilisant le câble console, nous allons utiliser le protocole [xmodem][1]. Pour cela, assurez-vous que le programme **sx** est installé sur votre machine.

Dans un premier temps, nous allons accéder au terminal d'administration de l'équipement à l'aide du programme **screen** :

    screen /dev/ttyUSB0 <speed>

Une fois connecté et authentifié avec un utilisateur privilégié, nous pouvons lancer la copie :

    copy xmodem: flash:

Il vous sera alors demandé de spécifier le nom du fichier source. Après cela, le message suivant devrait apparaitre :

    Begin the Xmodem or Xmodem-1K transfer now...

Il est maintenant temps d'utiliser "sx" pour envoyer le firmware. Après avoir affiché le prompt intégré à "screen" (**CTRL+a** puis **:**) :

    exec !! sx <file name>

Une fois le transfert terminé (ce qui va prendre un certain temps ...), il ne nous reste plus qu'à sélectionner le nouveau firmware comme image à utiliser au prochain démarrage de la machine et à redémarrer cette dernière :

    conf t
    no boot system
    boot system flash:<file name>
    exit
    reload

Votre équipement va maintenant redémarrer sur le nouveau firmware.

 [1]: http://fr.wikipedia.org/wiki/Xmodem "Wikipédia : xmodem"
