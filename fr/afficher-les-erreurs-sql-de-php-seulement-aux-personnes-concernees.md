# Afficher les erreurs SQL de PHP seulement aux personnes concernées

Il est très fortement conseillé de désactiver l'affichage des erreurs PHP (directive **display_errors** du **php.ini**) de vos applications web pour ne pas révéler des informations pouvant compromettre la sécurité de votre serveur (dans le cas d'un serveur en production).

Seulement voilà, cacher ces erreurs peut gêner l'administrateur à traquer les bugs ainsi que les problèmes liés à la base de données. En effet, c'est beaucoup plus facile de repérer une erreur si elle est affichée lors de l'exécution de la page plutôt que de passer son temps à analyser les logs du service.

Concernant les erreurs liées à la base de données, j'utilise une astuce maison dans le cadre d'une application avec authentification. En effet, j'affiche les erreurs SQL seulement si l'utilisateur connecté est administrateur. À supposer que la variable **$_SESSION['status']** contient le niveau de permissions de l'utilisateur connecté, voici un exemple pour la connexion et l'exploitation d'une base de données en PHP (avec **PDO**) :

    // Déclaration des variables de connexion.
    $db_type = "";
    $db_host = "";
    $db_user = "";
    $db_password = "";
    $db_database = "";
    
    // On vérifie si la connexion à la DB a bien fonctionnée.
    try
    {
        $db = new PDO($db_type.":host=".$db_host.";dbname=".$db_database, $db_user, $db_password);
    }
    catch (Exception $e)
    {
        // Si l'utilisateur a le statut d'administrateur, on lui affiche
        // l'erreur dans son intégralité.
        if (isset($_SESSION['status']) && $_SESSION['status'] == 'admin')
        {
            die("Erreur : " . $e->getMessage());
        }
        // Sinon, on affiche un message d'erreur indiquant à l'utilisateur qu'il est
        // impossible de se connecter à la base de données sans précisions supplémentaires.
        else
        {
            die("Erreur : Veuillez nous excuser, une erreur SQL s'est produite (Impossible de se connecter à la Base de Données).");
        }
    }
    
    // Déclaration de la fonction qui gère l'afficher
    // des erreurs SQL.
    function mySqlError($db)
    {
        // Si l'utilisateur a le statut d'administrateur, on lui affiche
        // les erreurs SQL.
        if (isset($_SESSION['status']) && $_SESSION['status'] == 'admin')
        {
            print_r($db->errorInfo());
        }
        // Sinon, on affiche un message indiquant à l'utilisateur qu'il y a eu
        // une erreur SQL (sans précisions).
        else
        {
            echo "Erreur : Veuillez nous excuser, une erreur SQL s'est produite.";
        }
    }

Et lors d'une requête SQL :

    $exemple_of_query = $db->prepare("INSERT INTO table VALUES (:var1, :var2, :var3)");
    $exemple_of_query->execute(array('var1' => $var1, 'var2' => $var2, 'var3' => $var3))
    or die(mySqlError($db));

Il est bien sûr possible d'adapter cette astuce pour d'autres utilisations que le SQL.

L'intérêt est d'apporter un confort supplémentaire à l'administrateur (à supposer qu'il se sert des applications qu'il développe) mais aussi aux utilisateurs finaux avec des messages d'erreur "propres", correspondant à leur profile.
