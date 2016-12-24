---
layout: post
title: "Calcul des angles d'Euler avec un accéléromètre"
categories:
    - Physique
tags:
    - Accéléromètre
    - Euler
---
Les angles d'Euler sont 3 angles qui permettent de décrire l'orientation d'un objet dans un espace tridimensionnel.

Si nous prenons par exemple un objet quelconque, le centre de masse \\(m\\) de cet objet est une coordonnée dans notre espace à 3 dimensions. Tout point dans un espace à \\(n\\) dimensions peut être atteint par \\(n\\) translations. Ainsi, le point \\(m\\) est atteint par 3 translations, quelque soit l'origine du repère.

De façon semblable à une coordonnée, une orientation dans cet espace tridimensionnel est obtenue par trois rotations. Ces rotations sont effectuées successivement dans un ordre arbitraire, chacune autour d'un des trois axes du repère. Cela revient à effectuer une rotation dans le plan formé par deux axes autour d'un troisième, et cela trois fois de suite.

Nous allons ici chercher à démontrer qu'il est possible de calculer les angles d'Euler (et donc l'orientation de l'objet) en utilisant uniquement un accéléromètre triaxial (c'est à dire 3 accéléromètres 1 axe montés orthogonalement). Pour rappel, un accéléromètre permet de mesurer l'accélération linéaire que subit un corps auquel ce capteur serait attaché.

La sortie de l'accéléromètre peut être modélisée de la façon suivante :

$$\vec{a_{S}} =
\left( \begin{array}{c} a_{Sx} \\ a_{Sy} \\ a_{Sz} \end{array} \right) =
\vec{a_{B}} + R_{I}^{B} \vec{g}$$

<!--more-->

\\(\vec{a_{S}}\\) correspond à la sortie de l'accéléromètre. Elle est représentée par la somme de \\(\vec{a_{B}}\\), l'accélération subie par le corps en mouvement sur lequel est accroché l'accéléromètre, et \\(\vec{g}\\), la gravité terrestre. \\(R_{I}^{B}\\) est la matrice de rotation qui permet de projeter \\(\vec{g}\\) du référentiel inertiel terrestre au référentiel du corps en mouvement.

Lorsque \\(\vec{a_{B}} = \vec{0}\\) :

$$\vec{a_{S}} =
\left( \begin{array}{c} a_{Sx} \\ a_{Sy} \\ a_{Sz} \end{array} \right) =
R_{I}^{B} \vec{g} =
R_{I}^{B} \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right)$$

Cela correspond à la situation dans laquelle le corps est au repos, c'est à dire qu'il ne subit aucune accélération et qu'il se trouve dans une position que l'on définit comme initiale. Dans le cas d'un drone par exemple, cela reviendrait à le poser à plat sur le sol.

Nous allons maintenant chercher à résoudre cette équation. Regardons tout d'abord l'expression des [matrices de rotation][Rotation Matrix] :

$$R_{x}(\phi) =
\left( \begin{array}{ccc} 1 & 0 & 0 \\ 0 & \cos(\phi) & sin(\phi) \\ 0 & -\sin(\phi) & \cos(\phi) \end{array} \right)$$

$$R_{y}(\theta) =
\left( \begin{array}{ccc} \cos(\theta) & 0 & -\sin(\theta) \\ 0 & 1 & 0 \\ \sin(\theta) & 0 & \cos(\theta) \end{array} \right)$$

$$R_{z}(\psi) =
\left( \begin{array}{ccc} \cos(\psi) & \sin(\psi) & 0 \\ -\sin(\psi) & \cos(\psi) & 0 \\ 0 & 0 & 1 \end{array} \right)$$

Chacune de ces matrices correspond à une rotation autour d'un des axes du repère. Étant donné que nous voulons effectuer les trois rotations successivement, nous devons multiplier les matrices entre elles. Or, la multiplication de matrices n'est pas commutative. Nous devons choisir un ordre arbitraire à ces multiplications.

Voici le détail des calculs pour \\(R_{I}^{B} = R_{xyz}\\) :

$$\begin{eqnarray*}
\vec{a_{S}} & = &
\left( \begin{array}{c} a_{Sx} \\ a_{Sy} \\ a_{Sz} \end{array} \right) =
R_{xyz}\left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right) =
R_{x}(\phi)R_{y}(\theta)R_{z}(\psi) \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right) \\ & = &
\left( \begin{array}{ccc} 1 & 0 & 0 \\ 0 & \cos(\phi) & \sin(\phi) \\ 0 & -\sin(\phi) & \cos(\phi) \end{array} \right) \left( \begin{array}{ccc} \cos(\theta) & 0 & -\sin(\theta) \\ 0 & 1 & 0 \\ \sin(\theta) & 0 & \cos(\theta) \end{array} \right) \left( \begin{array}{ccc} \cos(\psi) & \sin(\psi) & 0 \\ -\sin(\psi) & \cos(\psi) & 0 \\ 0 & 0 & 1 \end{array} \right) \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right) \\ & = &
\left( \begin{array}{ccc} \cos(\theta) & 0 & -\sin(\theta) \\ \sin(\phi)\sin(\theta) & \cos(\phi) & \sin(\phi)\cos(\theta) \\ \cos(\phi)\sin(\theta) & -\sin(\phi) & \cos(\phi)\cos(\theta) \end{array} \right) \left( \begin{array}{ccc} \cos(\psi) & \sin(\psi) & 0 \\ -\sin(\psi) & \cos(\psi) & 0 \\ 0 & 0 & 1 \end{array} \right) \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right) \\ & = &
\left( \begin{array}{c} \cos(\theta)\cos(\psi) & \cos(\theta)\sin(\psi) & -\sin(\theta) \\ \sin(\phi)\sin(\theta)\cos(\psi)-\cos(\phi)\sin(\psi) & \sin(\phi)\sin(\theta)\sin(\psi)+\cos(\phi)\cos(\psi) & \sin(\phi)\cos(\theta) \\ \cos(\phi)\sin(\theta)\cos(\psi)+\sin(\phi)\sin(\psi) & \cos(\phi)\sin(\theta)\sin(\psi)-\sin(\phi)\cos(\psi) & \cos(\phi)\cos(\theta) \end{array} \right) \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right) \\ & = &
\left( \begin{array}{c} -\sin(\theta) \\ \sin(\phi)\cos(\theta) \\ \cos(\phi)\cos(\theta) \end{array} \right)
\end{eqnarray*}$$

Sautons directement au résultat des cinq autres possibilités :

$$R_{y}(\theta)R_{x}(\phi)R_{z}(\psi) \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right) =
\left( \begin{array}{c} -\sin(\theta)\cos(\phi) \\ \sin(\phi) \\ \cos(\theta)\cos(\phi) \end{array} \right)$$

$$R_{x}(\phi)R_{z}(\psi)R_{y}(\theta) \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right) =
\left( \begin{array}{c} -\cos(\psi)\sin(\theta) \\ \cos(\theta)\sin(\phi)+\cos(\phi)\sin(\psi)\sin(\theta) \\ \cos(\phi)\cos(\theta)-\sin(\theta)\sin(\phi)\sin(\psi) \end{array} \right)$$

$$R_{y}(\theta)R_{z}(\psi)R_{x}(\phi) \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right) =
\left( \begin{array}{ccc} \cos(\theta)\sin(\phi)\sin(\psi)-\cos(\phi)\sin(\theta) \\ \cos(\psi)\sin(\phi) \\ \cos(\theta)\cos(\phi)+\sin(\theta)\sin(\phi)\sin(\psi) \end{array} \right)$$

$$R_{z}(\psi)R_{x}(\phi)R_{y}(\theta) \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right) =
\left( \begin{array}{ccc} \cos(\theta)\sin(\phi)\sin(\psi)-\cos(\psi)\sin(\theta) \\ \cos(\psi)\cos(\theta)\sin(\phi)+\sin(\theta)\sin(\psi) \\ \cos(\theta)\cos(\phi) \end{array} \right)$$

$$R_{z}(\psi)R_{y}(\theta)R_{x}(\phi) \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right) =
\left( \begin{array}{ccc} \sin(\phi)\sin(\psi)-\cos(\phi)\cos(\psi)\sin(\theta) \\ \cos(\psi)\sin(\phi)+\cos(\phi)\sin(\psi)\sin(\theta) \\ \cos(\theta)\cos(\phi) \end{array} \right)$$

En comparant les résultats, nous pouvons remarquer que dans les cas de \\(R_{xyz}\\) et de \\(R_{yxz}\\), les résultats ne dépendent que de \\(\phi\\) et \\(\theta\\), ce qui va nous permettre de résoudre l'équation. En effet, les autres solutions ne sont pas exploitables.

Nous allons faire le choix arbitraire de  \\(R_{I}^{B} = R_{xyz}\\) pour la suite :

$$\vec{a_{S}} =
\left( \begin{array}{c} a_{Sx} \\ a_{Sy} \\ a_{Sz} \end{array} \right) =
\left( \begin{array}{c} -\sin(\theta) \\ \sin(\phi)\cos(\theta) \\ \cos(\phi)\cos(\theta) \end{array} \right)$$

Ainsi, nous avons \\(a_{Sx} = -\sin(\theta)\\), \\(a_{Sy} = \sin(\phi)\cos(\theta)\\) et \\(a_{Sz} = \cos(\phi)\cos(\theta)\\). Cela nous permet d'obtenir les expressions suivants :

$$\frac{a_{Sy}}{a_{Sz}} =
\frac{\sin(\phi)\cos(\theta)}{\cos(\phi)\cos(\theta)} =
\tan(\phi) \Rightarrow \phi =
\tan^{-1} \left( \frac{a_{Sy}}{a_{Sz}} \right)$$

$$a_{Sx} =
-\sin(\theta) \Rightarrow \sin(\theta) =
-a_{Sx}$$

$$a_{Sy}^{2} + a_{Sz}^{2} =
\cos^{2}(\theta) \; (\sin^{2}(\phi) + \cos^{2}(\phi)) =
\cos^{2}(\theta) \Rightarrow \cos(\theta) =
\sqrt{a_{Sy}^{2} + a_{Sz}^{2}}$$

$$\tan(\theta) =
\frac{\sin(\theta)}{\cos(\theta)} =
\frac{-a_{Sx}}{\sqrt{a_{Sy}^{2} + a_{Sz}^{2}}} \Rightarrow \theta =
\tan^{-1} \left( \frac{-a_{Sx}}{\sqrt{a_{Sy}^{2} + a_{Sz}^{2}}} \right)$$

Nous sommes donc maintenant capable d'obtenir l'orientation de notre objet selon deux degrés de liberté uniquement en regardant la sortie de son accéléromètre embarqué.

[Rotation Matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
