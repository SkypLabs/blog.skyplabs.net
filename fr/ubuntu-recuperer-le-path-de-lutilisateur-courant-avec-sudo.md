# [Ubuntu] Récupérer le PATH de l'utilisateur courant avec sudo

Pour ceux qui se servent de la commande **sudo** sous **Ubuntu**, vous avez surement remarqué que le **PATH** de l'utilisateur courant n'est pas conservé lors de son utilisation. Ça peut être très énervant à la longue.

La raison est simple : sous Ubuntu, la commande sudo a été compilée avec l'option **--with-secure-path** qui permet de définir un PATH différent de celui de l'utilisateur courant pour des raisons de sécurité.

Pour passer outre cette restriction, il suffit de rajouter cet **alias** dans votre **.bashrc** par exemple :

    alias sudo='sudo env PATH=$PATH'

En effet, la commande **env** permet de lancer un processus en positionnant des valeurs d’environnement.

Pour plus d'informations sur les options de compilation de sudo : <http://www.gratisoft.us/sudo/install.html>
