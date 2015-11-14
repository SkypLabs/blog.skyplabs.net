**edit** : Une autre solution beaucoup plus propre m'a été proposée (voir les commentaires) pour réaliser exactement la même chose :

    export HISTFILE=/dev/null

Après ceci, l'écriture de l'historique des commandes par Bash aura lieu dans **/dev/null**, ce qui revient à écrire dans le vide.

* * *

Comme vous devez le savoir, le shell Bash conserve un historique des dernières commandes que l'utilisateur a entré dans son terminal. Cela permet de garder une trace de ce qui a été fait, chose particulièrement importante sur un serveur, surtout si plusieurs personnes travaillent sur la même machine avec le même compte. La liste des commandes est stockée par défaut dans le fichier **~/.bash_history** et il est possible d'afficher cette liste avec la commande **history**.

Cependant, il peut arriver de ne pas vouloir que Bash enregistre les dernières commandes tapées dans l'historique, par exemple dans le cas où l'on a entré son mot de passe en clair sans prendre garde à ce que l'on faisait. Étant donné que Bash ne met à jour le fichier bash_history qu'au moment de sa fermeture, la solution est de forcer l'arrêt de son processus avant qu'il ne puisse le faire :

    kill -9 $$

**$$** est un alias pour le **PID** du processus courant, à savoir Bash. Cette commande va donc envoyer un signal **SIGKILL** au processus courant de Bash, l'empêchant de mettre à jour l'historique des commandes. Cependant, il ne faut pas faire appel à la commande history entre temps car elle met à jour le fichier ~/.bash_history avant de l'afficher.

Attention bien sûr à ne pas abuser de cette méthode. Seuls certains cas précis justifient son utilisation.
