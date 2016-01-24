---
layout: post
title: "Problème d'utilisation de Droidwall depuis la version 4 d'Android"
categories:
    - SysAdmin
    - Logiciel
tags:
    - Android
    - Netfilter
---
Edit : Depuis Jelly Bean (version 4.1.2 dans mon cas), la variable `$IPTABLES` fournit par Droidwall n'est plus valide. Une petite mise à jour du script s'impose :

{% highlight bash linenos %}
## Netfilter Script by Skyper - http://blog.skyplabs.net ##

# Permet de corriger un problème d'exploitation de Droidwall depuis ICS.

IPTABLES=/system/bin/iptables

$IPTABLES -D OUTPUT -j droidwall
$IPTABLES -I OUTPUT 2 -j droidwall
{% endhighlight %}

* * *

Droidwall est une application Android permettant d'autoriser ou non l'accès au réseau à une application installée sur le système en question. Pour ce faire, elle rajoute une série de règles **Netfilter** (via l'utilitaire userland **iptables**) selon la configuration donnée par l'utilisateur.

Mais depuis la version 4 d'Android (nommée **Ice Cream Sandwich**), Google a intégré à son système la possibilité de visualiser la consommation data réalisée par l'ensemble des applications qui y sont installées. Cela se traduit par l'ajout de nouvelles règles Netfilter dans les chaînes `INPUT` et `OUTPUT`. Le soucis est que ces nouvelles règles viennent perturber le bon fonctionnement de Droidwall. Voyez par vous même :

![Screenshot netfilter Android - before](/images/probleme-droidwall-1.png)

La règle correspondante à Droiwall se situe après celle qui autorise l'ensemble du trafic à sortir. Pour corriger ce problème, j'ai écris un petit script de règles Netfilter que je fais exécuter par Droidwall (via une de ses options) pour modifier la position de la règle citée plus haut. Voici le script en question :

{% highlight bash linenos %}
## Netfilter Script by Skyper - http://blog.skyplabs.net ##

# Permet de corriger un problème d'exploitation de Droidwall depuis ICS.

$IPTABLES -D OUTPUT -j droidwall
$IPTABLES -I OUTPUT 2 -j droidwall
{% endhighlight %}

Après avoir copié ce petit script sur votre carte SD, il vous faut utiliser l'option [Set Custom Script][droidwall_custom_script] de Droidwall pour lui demander de l'exécuter à chacune de ses activations. Dans la zone de texte prévue à cet effet, il vous faut écrire :

    . /chemin/vers/le/script

Et voici le résultat en image :

![Screenshot netfilter Android - after](/images/probleme-droidwall-2.png)

Cette méthode permet de résoudre le problème mais je vais prendre le temps de contacter le développeur de l'application Droidwall pour le lui signaler et ainsi éviter toutes ces manipulations.

[droidwall_custom_script]: http://code.google.com/p/droidwall/wiki/CustomScripts "Set Custom Script"
