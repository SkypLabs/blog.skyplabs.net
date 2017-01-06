---
layout: post
title: "Afficher les erreurs SQL de PHP seulement aux personnes concernées"
categories:
    - Développement
    - Hacking et Sécurité
tags:
    - PHP
    - SQL
---
Il est très fortement conseillé de désactiver l'affichage des erreurs PHP (directive `display_errors` du `php.ini`) de vos applications web pour ne pas révéler des informations pouvant compromettre la sécurité de votre serveur (dans le cas d'un serveur en production).

Seulement voilà, cacher ces erreurs peut gêner l'administrateur à traquer les bugs ainsi que les problèmes liés à la base de données. En effet, c'est beaucoup plus facile de repérer une erreur si elle est affichée lors de l'exécution de la page plutôt que de passer son temps à analyser les logs du service.

<!--more-->

Concernant les erreurs liées à la base de données, j'utilise une astuce maison dans le cadre d'une application avec authentification. En effet, j'affiche les erreurs SQL seulement si l'utilisateur connecté est administrateur. À supposer que la variable `$_SESSION['status']` contient le niveau de permissions de l'utilisateur connecté, voici un exemple pour la connexion et l'exploitation d'une base de données en PHP (avec [PDO][PDO]) :

{% gist SkypLabs/dd1fa68b9c8e4e76366206513da2f32c db.php %}

Et lors d'une requête SQL :

{% gist SkypLabs/dd1fa68b9c8e4e76366206513da2f32c example.php %}

Il est bien sûr possible d'adapter cette astuce pour d'autres utilisations que le SQL.

L'intérêt est d'apporter un confort supplémentaire à l'administrateur (à supposer qu'il se sert des applications qu'il développe) mais aussi aux utilisateurs finaux avec des messages d'erreur "propres", correspondant à leur profile.

[PDO]: https://en.wikipedia.org/wiki/PHP_Data_Objects
