La version de WordPress apparaît par défaut dans les en-têtes HTML, ce qui n'est bien entendu pas une bonne chose d'un point de vue sécurité. Pour la supprimer, il faut rajouter ce bout de code à la fin du fichier **functions.php** de votre thème :

    // Pour retirer l'affichage de la version de WordPress dans les en-têtes HTML.
    remove_action('wp_head', 'wp_generator');

Pour ce faire, vous pouvez soit modifier le fichier "functions.php" de votre thème à la main (il se trouve normalement dans "wp-content/themes/<votre thème>/functions.php"), soit le modifier depuis l'interface d'édition de WordPress (Menu "Apparence" -> "Éditeur").

Pour plus d'informations sur la fonction **remove_action**, [cliquez ici][1].

Pensez également à supprimer le fichier **readme.html** présent à la racine de votre site. Ce dernier contient également le numéro de version de WordPress.

 [1]: http://codex.wordpress.org/Function_Reference/remove_action "codex.wordpress.org : Remove Action"
