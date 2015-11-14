Le projet Metasploit utilise des dépôts **Subversion** pour la mise à jour de l'ensemble de ses composants. Traditionnellement, il faut utiliser le script **msfupdate** pour effectuer cette tâche.

Seulement voilà, la dernière fois que j'ai voulu le mettre à jour, j'ai eu droit à l'erreur suivante :

    svn: Working copy '.' locked
    svn: run 'svn cleanup' to remove locks (type 'svn help cleanup' for details)

Cette erreur peut survenir lorsque le programme **svn** a été interrompu pendant une opération sur votre copie locale (pour plus de détails, [cliquez ici][1]).

Pour résoudre ce problème, il faut utiliser l'option **cleanup** de svn, comme mentionné dans le message d'erreur. La seule difficulté est qu'il faut appliquer cette commande à l'ensemble des dépôts locaux des différents composants du projet (car dans mon cas, ce problème ne provenait pas que d'un seul dépôt). Voici comment faire :

    find /opt/framework-3.7.1 -name ".svn" | sed  "s/\/.svn/ /" | xargs svn cleanup

Il faut bien entendu remplacer "/opt/framework-3.7.1" par le chemin correspondant à votre installation du Metasploit.

Une fois l'exécution terminée, l'utilisation du script "msfupdate" ne devrait plus poser de problèmes.

 [1]: http://svnbook.red-bean.com/en/1.5/svn.tour.cleanup.html
