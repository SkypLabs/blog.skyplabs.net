Edit : Depuis Jelly Bean (version 4.1.2 dans mon cas), la variable $IPTABLES fournit par Droidwall n'est plus valide. Une petite mise à jour du script s'impose :

    ## Netfilter Script by Skyper - http://blog.skyplabs.net ##
    
    # Permet de corriger un problème d'exploitation de Droidwall depuis ICS.
    
    IPTABLES=/system/bin/iptables
    
    $IPTABLES -D OUTPUT -j droidwall
    $IPTABLES -I OUTPUT 2 -j droidwall

* * *

Droidwall est une application Android permettant d'autoriser ou non l'accès au réseau à une application installée sur le système en question. Pour ce faire, elle rajoute une série de règles **netfilter** (via l'utilitaire userland **iptables**) selon la configuration donnée par l'utilisateur.

Mais depuis la version 4 d'Android (nommée **Ice Cream Sandwich**), Google a intégré à son système la possibilité de visualiser la consommation data réalisée par l'ensemble des applications qui y sont installées. Cela se traduit par l'ajout de nouvelles règles netfilter dans les chaînes INPUT et OUTPUT. Le soucis est que ces nouvelles règles viennent perturber le bon fonctionnement de Droidwall. Voyez par vous même :

![Screenshot netfilter Android - before][1]

La règle correspondante à Droiwall se situe après celle qui autorise l'ensemble du trafic à sortir. Pour corriger ce problème, j'ai écris un petit script de règles netfilter que je fais exécuter par Droidwall (via une de ses options) pour modifier la position de la règle citée plus haut. Voici le script en question :

    ## Netfilter Script by Skyper - http://blog.skyplabs.net ##
    
    # Permet de corriger un problème d'exploitation de Droidwall depuis ICS.
    
    $IPTABLES -D OUTPUT -j droidwall
    $IPTABLES -I OUTPUT 2 -j droidwall

Après avoir copié ce petit script sur votre carte SD, il vous faut utiliser l'option [Set Custom Script][2] de Droidwall pour lui demander de l'exécuter à chacune de ses activations. Dans la zone de texte prévue à cet effet, il vous faut écrire :

    . /chemin/vers/le/script

Et voici le résultat en image :

![Screenshot netfilter Android - after][3]

Cette méthode permet de résoudre le problème mais je vais prendre le temps de contacter le développeur de l'application Droidwall pour le lui signaler et ainsi éviter toutes ces manipulations.

 [1]: http://blog.skyplabs.net/wp-content/uploads/2011/12/Screenshot-netfilter-Android-before.png "Screenshot netfilter Android - before"
 [2]: http://code.google.com/p/droidwall/wiki/CustomScripts "Set Custom Script"
 [3]: http://blog.skyplabs.net/wp-content/uploads/2011/12/Screenshot-netfilter-Android-after.png "Screenshot netfilter Android - after"
