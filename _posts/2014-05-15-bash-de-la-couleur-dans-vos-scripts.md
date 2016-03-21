---
layout: post
title: "[Bash] De la couleur dans vos scripts"
categories:
    - Développement
tags:
    - Bash
---
Voici quelques fonctions bien utiles permettant d'écrire des messages dans un terminal avec un code couleur correspondant au type de l'information à afficher :

{% highlight bash %}
# Vert
function echo_OK {
	echo -e "\033[32m[OK]\033[0m $@"
}

# Rouge (avec affichage dans strerr)
function echo_ERR {
	echo -e "\033[31m[ERROR]\033[0m $@" 1>&2
}

# Orange
function echo_WAR {
	echo -e "\033[33m[WARNING]\033[0m $@"
}

# Bleu
function echo_INFO {
	echo -e "\033[34m[INFO]\033[0m $@"
}
{% endhighlight %}
