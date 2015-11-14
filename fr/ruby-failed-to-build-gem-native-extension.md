Si vous obtenez ce message d'erreur lors de la première utilisation de l'outil **gem**, c'est qu'il vous manque certaines dépendances nécessaires à la création de la "gem native extension".

Pour les installer sous Fedora :

    sudo yum install -y gcc ruby-devel libxml2 libxml2-devel libxslt libxslt-devel

Après cela, vous pouvez relancer l'installation de votre gem en utilisant l'option **--use-system-libraries** permettant d'utiliser les bibliothèques du système (ici, *libxml2* et *libxslt*).

Par exemple, pour installer la gem **gollum** :

    gem install gollum -- --use-system-libraries
