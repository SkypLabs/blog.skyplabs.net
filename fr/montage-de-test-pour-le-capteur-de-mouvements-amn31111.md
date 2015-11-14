La détection de présence possède une place très importante dans une installation domotique. En effet, c'est grâce à elle qu'il est possible de piloter automatiquement ses lumières, son chauffage, ou encore de détecter une présence non autorisée. C'est dans cet esprit que je vais vous présenter un montage de test pour le capteur de mouvements **AMN31111** de **Panasonic**.

Le principe du montage est simple : allumer une LED lorsque le capteur détecte la présence d'un individu. La liste des composants qui ont été utilisés est la suivante :

*   Le capteur de mouvements [AMN31111][1]
*   Un transistor MOSFET canal N ([IRF720PBF][2] dans mon cas)
*   Une LED émettant un rayonnement dans le spectre visible
*   Des résistances (valeurs calculées ci-dessous)

Tous les composants listés ci-dessus peuvent se commander chez [Farnell][3]. Les détails de la réalisation vont être présentés par étapes successives.

<!--more-->

# LED

Il est nécessaire de limiter le passage du courant qui circulera dans la LED à l'aide d'une résistance. J'ai utilisé une LED blanche possédant une tension de seuil [latex]V_{seuil}[/latex] de 3,5 V et j'ai arbitrairement choisi de la faire fonctionner avec un courant [latex]I_{LED}[/latex] de 20 mA. Le calcul de la résistance [latex]R_{LED}[/latex] est donc le suivant :

$$R_{LED} = \frac{V_{dd} - V_{seuil}}{I_{LED}}$$

Avec un tension d'alimentation [latex]V_{dd}[/latex] de 5V, le calcul donne [latex]R_{LED} = 75 \Omega[/latex].

# Transistor MOSFET

Le transistor va nous permettre de déclencher l'allumage de la LED lorsque la tension [latex]V_{GS}[/latex] sera supérieure à 4V (d'après [la datasheet du IRF720][4]). La tension [latex]V_{GS}[/latex] correspond à la différence de potentiel entre la grille (notée G pour gate) et la source (notée S) :

![Schéma d'un transistor MOSFET canal N][5]

Nous allons connecter la LED avec sa résistance en amont du transistor (sur le drain noté D) et la masse sur la source. Les connexions se font de la manière suivante :

![Schéma de connexion d'un transistor utilisant un boîtier TO-220AB][6]

# Capteur de mouvements

Le capteur de mouvements AMN31111 est un composant à trois broches. Deux servent à l'alimenter et la dernière renvoie une tension minimale de [latex]V_{dd} - 0,5 V[/latex] lorsqu'il détecte un mouvement. Les connexions se font de la manière suivante :

![Schéma du AMN31111][7]

J'ai alimenté ce circuit en +5V et il me retournait une tension de +5V également lors de la détection d'un mouvement.

# Montage final

Il ne reste plus qu'à assembler tous les éléments entre eux. Voici le schéma du circuit de test que j'ai utilisé :

![Schéma du circuit de test du capteur AMN31111][8]

Et en montage réel :

![Montage de test pour le capteur de mouvements AMN31111][9]

La résistance de [latex]10k\Omega[/latex] est utilisée comme résistance de pull-down pour que la tension [latex]V_{GS}[/latex] repasse bien à zéro lorsque le capteur de mouvements ne détecte rien et que par conséquent, sa sortie ne renvoie aucun courant (cf : [résistance de rappel][10]).

Pour terminer, voici une petite vidéo qui vous permettra de constater la réactivité du capteur :

<iframe width="560" height="315" src="//www.youtube.com/embed/cRzz8S9y61k" frameborder="0" allowfullscreen></iframe>

 [1]: http://fr.farnell.com/panasonic-ew/amn31111/capteur-motion-5m-100-82-noir/dp/1373710 "AMN31111"
 [2]: http://fr.farnell.com/vishay-formerly-i-r/irf720pbf/trans-mosfet-canal-n-to-220-400v/dp/8648425 "IRF720PBF"
 [3]: http://fr.farnell.com/ "Farnell"
 [4]: http://www.irf.com/product-info/datasheets/data/irf720.pdf "Datasheet du IRF720"
 [5]: http://blog.skyplabs.net/wp-content/uploads/2014/05/MOSFET-NPN.png "Schéma d'un transistor MOSFET canal N"
 [6]: http://blog.skyplabs.net/wp-content/uploads/2014/05/TO-220AB.jpg "Schéma de connexion d'un transistor utilisant un boîtier TO-220AB"
 [7]: http://blog.skyplabs.net/wp-content/uploads/2014/05/AMN31111.jpg "Schéma du AMN31111"
 [8]: http://blog.skyplabs.net/wp-content/uploads/2014/05/Schéma-circuit-test-AMN31111.png "Schéma du circuit de test du capteur AMN31111"
 [9]: http://blog.skyplabs.net/wp-content/uploads/2014/05/wpid-wp-1400409039617.jpeg "Montage de test pour le capteur de mouvements AMN31111"
 [10]: http://fr.wikipedia.org/wiki/R%C3%A9sistance_de_rappel "Résistance de rappel"
