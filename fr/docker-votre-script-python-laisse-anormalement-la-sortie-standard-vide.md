Lors de l'utilisation de l'[image Docker officielle][1] pour les programmes écrits en Python, il arrive régulièrement que la sortie standard reste anormalement vide :

    $ docker logs my-app
    $

La raison est généralement que par défaut, l'interpréteur Python utilise une mémoire tampon pour les écritures vers *stdout*. Les écritures sont donc différées et cela peut prendre un moment avant de voir apparaitre la moindre ligne d'écriture (selon la verbosité de votre programme).

Une solution est d'utiliser l'option *-u* lors de l'appel à l'interpréteur Python. Votre *Dockerfile* devra contenir une ligne ressemblant à ceci :

    CMD ["python3", "-u", "my-app.py"]

Et ainsi :

    $ docker logs my-app
    It works !
    $

 [1]: https://hub.docker.com/_/python/
