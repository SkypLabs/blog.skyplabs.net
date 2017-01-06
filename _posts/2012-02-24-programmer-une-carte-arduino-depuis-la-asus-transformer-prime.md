---
layout: post
title: "Programmer une carte Arduino depuis la Asus Transformer Prime"
categories:
    - Développement
tags:
    - Arduino
    - Transformer Prime
---
Maintenant que nous disposons d'une Debian sur notre Transformer Prime (cf : [Allier Android en GUI et Debian en CLI sur la Asus Transformer Prime][previous_article]), il est grand temps de commencer à jouer avec. C'est dans cette optique que j'ai décidé de détailler dans cet article la marche à suivre pour programmer une carte Arduino (**Uno** dans mon cas).

Dans un premier temps, il nous faut préparer notre environnement de développement au sein de la Debian. Un petit coup d'aptitude (ou apt-get, selon vos préférences) et le tour est joué :

    aptitude update
    aptitude install gcc-avr avrdude avr-libc

Il va également nous falloir de quoi écrire notre code. Pour ma part, mon choix s'est tourné vers **vim**. De plus, l'utilisation d'un Makefile va grandement nous faciliter la vie. Prenez donc le temps d'installer **make** en plus du reste.

<!--more-->

Nous sommes enfin prêts à écrire notre code. Je vous propose donc un exemple de programme très simple à réaliser qui va tout simplement faire clignoter la LED située sur la carte :

{% gist SkypLabs/c32ce01c695620e033443d407544f21e blink.c %}

La dernière étape est de réaliser un Makefile qui va nous servir à automatiser la phase de compilation ainsi que l'envoi du programme dans la mémoire de la carte :

{% gist SkypLabs/c32ce01c695620e033443d407544f21e Makefile %}

Et maintenant, on test le tout (après avoir connecté votre carte Arduino au port USB du dock de la Transformer Prime) :

    make
    make upload

Normalement, avrdude devrait vous indiquer que le programme a bien été chargé dans la carte et la LED devrait clignoter en signe de réussite.

Si vous rencontrez des problèmes lors de l'application de cette procédure, n'hésitez pas à me laisser un message en commentaire de cet article.

[previous_article]: /2012/01/20/allier-android-en-gui-et-debian-en-cli-sur-la-asus-transformer-prime/ "Allier Android en GUI et Debian en CLI sur la Asus Transformer Prime"
