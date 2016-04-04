---
layout: post
title: "Montage de test pour le capteur de mouvements AMN31111"
categories:
    - Électronique
tags:
    - Capteur
---
La détection de présence possède une place très importante dans une installation domotique. En effet, c'est grâce à elle qu'il est possible de piloter automatiquement ses lumières, son chauffage, ou encore de détecter une présence non autorisée. C'est dans cet esprit que je vais vous présenter un montage de test pour le capteur de mouvements **AMN31111** de **Panasonic**.

Le principe du montage est simple : allumer une LED lorsque le capteur détecte la présence d'un individu. La liste des composants qui ont été utilisés est la suivante :

* Le capteur de mouvements [AMN31111][AMN31111_farnell]
* Un transistor MOSFET canal N ([IRF720PBF][IRF720PBF_farnell] dans mon cas)
* Une LED émettant un rayonnement dans le spectre visible
* Des résistances (valeurs calculées ci-dessous)

Tous les composants listés ci-dessus peuvent se commander chez [Farnell][farnell]. Les détails de la réalisation vont être présentés par étapes successives.

<!--more-->

## LED

Il est nécessaire de limiter le passage du courant qui circulera dans la LED à l'aide d'une résistance. J'ai utilisé une LED blanche possédant une tension de seuil \\(V_{seuil}\\) de 3,5 V et j'ai arbitrairement choisi de la faire fonctionner avec un courant \\(I_{LED}\\) de 20 mA. Le calcul de la résistance \\(R_{LED}\\) est donc le suivant :

$$R_{LED} = \frac{V_{dd} - V_{seuil}}{I_{LED}}$$

Avec un tension d'alimentation \\(V_{dd}\\) de 5V, le calcul donne \\(R_{LED} = 75 \Omega\\).

## Transistor MOSFET

Le transistor va nous permettre de déclencher l'allumage de la LED lorsque la tension \\(V_{GS}\\) sera supérieure à 4V (d'après [la datasheet du IRF720][IRF720_datasheet]). La tension \\(V_{GS}\\) correspond à la différence de potentiel entre la grille (notée G pour gate) et la source (notée S) :

![Schéma d'un transistor MOSFET canal N](/images/MOSFET-NPN.png)

Nous allons connecter la LED avec sa résistance en amont du transistor (sur le drain noté D) et la masse sur la source. Les connexions se font de la manière suivante :

![Schéma de connexion d'un transistor utilisant un boîtier TO-220AB](/images/TO-220AB.jpg)

## Capteur de mouvements

Le capteur de mouvements AMN31111 est un composant à trois broches. Deux servent à l'alimenter et la dernière renvoie une tension minimale de \\(V_{dd} - 0,5 V\\) lorsqu'il détecte un mouvement. Les connexions se font de la manière suivante :

![Schéma du AMN31111](/images/AMN31111.jpg)

J'ai alimenté ce circuit en +5V et il me retournait une tension de +5V également lors de la détection d'un mouvement.

## Montage final

Il ne reste plus qu'à assembler tous les éléments entre eux. Voici le schéma du circuit de test que j'ai utilisé :

![Schéma du circuit de test du capteur AMN31111](/images/schema_circuit_test_AMN31111.png)

Et en montage réel :

![Montage de test pour le capteur de mouvements AMN31111](/images/AMN31111_montage_final.jpg)

La résistance de \\(10k\Omega\\) est utilisée comme résistance de pull-down pour que la tension \\(V_{GS}\\) repasse bien à zéro lorsque le capteur de mouvements ne détecte rien et que par conséquent, sa sortie ne renvoie aucun courant (cf : [résistance de rappel][resistance_de_rappel]).

Pour terminer, voici une petite vidéo qui vous permettra de constater la réactivité du capteur :

<iframe width="560" height="315" src="//www.youtube.com/embed/cRzz8S9y61k" frameborder="0" allowfullscreen></iframe>

[AMN31111_farnell]: http://fr.farnell.com/panasonic-ew/amn31111/capteur-motion-5m-100-82-noir/dp/1373710 "AMN31111"
[IRF720PBF_farnell]: http://fr.farnell.com/vishay-formerly-i-r/irf720pbf/trans-mosfet-canal-n-to-220-400v/dp/8648425 "IRF720PBF"
[farnell]: http://fr.farnell.com/ "Farnell"
[IRF720_datasheet]: http://www.irf.com/product-info/datasheets/data/irf720.pdf "Datasheet du IRF720"
[resistance_de_rappel]: http://fr.wikipedia.org/wiki/R%C3%A9sistance_de_rappel "Résistance de rappel"
