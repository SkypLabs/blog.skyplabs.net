---
layout: post
title: "Calcul des angles d'Euler avec un accéléromètre"
categories: Physique
tags: Accéléromètre, Euler
---
Les angles d'Euler permettent de décrire l'orientation d'un objet dans un espace à \\(n\\) dimensions. Ici, nous considérons un espace à 3 dimensions.

Si nous prenons par exemple un objet quelconque, le centre de masse \\(m\\) de cet objet est une coordonnée dans notre espace à 3 dimensions. Tout point dans un espace à \\(n\\) dimensions peut être atteint par \\(n\\) translations. Ainsi, le point \\(m\\) est atteint par 3 translations, quelque soit l'origine du repère.

De façon semblable à une coordonnée, une orientation dans cet espace tridimensionnel est obtenue par trois rotations. Ces rotations sont effectuées successivement dans un ordre arbitraire, chacune autour d'un des trois axes du repère. Cela revient à effectuer une rotation dans le plan formé par deux axes autour d'un troisième, et cela trois fois de suite.

Nous cherchons maintenant à démontrer qu'il est possible de calculer les angles d'Euler (et donc l'orientation de l'objet) en utilisant uniquement un accéléromètre.

Considérons l'expression suivante :

$$G_{P} =
\left( \begin{array}{c} G_{Px} \\ G_{Py} \\ G_{Pz} \end{array} \right) =
R \; (\vec{g}-\vec{a_{r}})$$

\\(G_{P}\\) correspond à la sortie de l'accéléromètre. Elle se décompose en trois composantes réunies au sein d'un vecteur. Chacune de ces composantes correspond à une dimension de notre espace tridimensionnel. \\(R\\) est la matrice de rotation qui vient décrire l'orientation de notre objet dans cet espace. \\(\vec{g}\\) est un vecteur représentant le champ gravitationnel terrestre et \\(\vec{a}_{r}\\) l'accélération linéaire mesurée dans le référentiel terrestre \\(r\\).

Lorsque \\(\vec{a_{r}} = \vec{0}\\) :

$$G_{P} =
\left( \begin{array}{c} G_{Px} \\ G_{Py} \\ G_{Pz} \end{array} \right) =
R \vec{g} =
R \left( \begin{array}{c} 0 \\ 0 \\ 1 \end{array} \right)$$

Cela correspond à la situation dans laquelle notre mobile est au repos, c'est à dire qu'il ne subit aucune accélération et qu'il se trouve dans une position que l'on définit comme initiale. Dans le cas d'un drone par exemple, cela reviendrait à le poser à plat sur le sol.

Nous cherchons maintenant à résoudre cette équation. Regardons tout d'abord l'expression des [matrices de rotation][Rotation Matrix] :

$$R_{x}(\phi) =
\left( \begin{array}{ccc} 1 & 0 & 0 \\ 0 & \cos(\phi) & sin(\phi) \\ 0 & -\sin(\phi) & \cos(\phi) \end{array} \right)$$

$$R_{y}(\theta) =
\left( \begin{array}{ccc} \cos(\theta) & 0 & -\sin(\theta) \\ 0 & 1 & 0 \\ \sin(\theta) & 0 & \cos(\theta) \end{array} \right)$$

$$R_{z}(\psi) =
\left( \begin{array}{ccc} \cos(\psi) & \sin(\psi) & 0 \\ -\sin(\psi) & \cos(\psi) & 0 \\ 0 & 0 & 1 \end{array} \right)$$

Chacune de ces matrices correspond à une rotation autour d'un des axes du repère. Étant donné que nous voulons effectuer les trois rotations successivement, nous devons multiplier les matrices entre elles. Or, la multiplication de matrices n'est pas commutative. Nous devons choisir un ordre arbitraire à ces multiplications.

Voici le détail des calculs pour \\(R_{xyz}\\) :

$$\begin{eqnarray*}
G_{P} & = &
\left( \begin{array}{c} G_{Px} \\ G_{Py} \\ G_{Pz} \end{array} \right) =
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

Nous choisissons arbitrairement le cas de \\(R_{xyz}\\) pour la suite :

$$G_{P} =
\left(  \begin{array}{c} G_{Px}  \\ G_{Py} \\ G_{Pz} \end{array} \right) =
\left( \begin{array}{c} -\sin(\theta) \\ \sin(\phi)\cos(\theta) \\ \cos(\phi)\cos(\theta) \end{array} \right)$$

Ainsi, nous avons \\(G_{Px} = -\sin(\theta)\\), \\(G_{Py} = \sin(\phi)\cos(\theta)\\) et \\(G_{Pz} = \cos(\phi)\cos(\theta)\\). Cela nous permet d'obtenir les expressions suivants :

$$\frac{G_{Py}}{G_{Pz}} =
\frac{\sin(\phi)\cos(\theta)}{\cos(\phi)\cos(\theta)} =
\tan(\phi) \Rightarrow \phi =
\tan^{-1} \left( \frac{G_{Py}}{G_{Pz}} \right)$$

$$G_{Px} =
-\sin(\theta) \Rightarrow \sin(\theta) =
-G_{Px}$$

$$G_{Py}^{2} + G_{Pz}^{2} =
\cos^{2}(\theta) \; (\sin^{2}(\phi) + \cos^{2}(\phi)) =
\cos^{2}(\theta) \Rightarrow \cos(\theta) =
\sqrt{G_{Py}^{2} + G_{Pz}^{2}}$$

$$\tan(\theta) =
\frac{\sin(\theta)}{\cos(\theta)} =
\frac{-G_{Px}}{\sqrt{G_{Py}^{2} + G_{Pz}^{2}}} \Rightarrow \theta =
\tan^{-1} \left( \frac{-G_{Px}}{\sqrt{G_{Py}^{2} + G_{Pz}^{2}}} \right)$$

Nous sommes donc maintenant capable d'obtenir l'orientation de notre objet selon deux degrés de liberté uniquement en regardant la sortie de son accéléromètre embarqué.

[Rotation Matrix]: https://en.wikipedia.org/wiki/Rotation_matrix
