# [GNOME 3] Désactiver le bluetooth au démarrage

Pour modifier l'état de l'interface bluetooth de votre ordinateur, nous allons utiliser le programme **rfkill**. Assurez-vous qu'il soit bien installé sur votre machine :

    yum install rfkill

Voici les commandes de base de l'outil :

* Pour afficher l'état actuel de votre interface bluetooth :

        rfkill list bluetooth

* Pour activer l'interface bluetooth :

        rfkill unblock bluetooth

* Pour désactiver l'interface bluetooth :

        rfkill block bluetooth

Ainsi, pour désactiver l'interface bluetooth au démarrage, il faut exécuter la commande ci-dessus au lancement de GNOME 3. Pour ce faire, faites **Alt + F2** puis tapez "**gnome-session-properties**". Dans l'onglet "Startup Programs", utilisez le bouton "Add" afin d'ajouter un programme à exécuter au démarrage. Enfin, dans la boîte de dialogue qui vient de s'ouvrir, entrez les informations suivantes :

* Name : Un nom arbitraire désignant la fonction du programme. Par exemple "Disable bluetooth".
* Command : Le chemin absolu de la commande à exécuter afin que les paramètres additionnels. Ici "/usr/sbin/rfkill block bluetooth".
* Comment : Une description optionnelle comme "Turn off bluetooth by default".

Il ne vous reste plus qu'à valider et à redémarrer votre machine afin de tester le bon fonctionnement de votre nouvelle configuration.
