Traditionnellement, la configuration de PHP se définit dans le fichier **php.ini**. Par exemple, sur une Debian, le fichier de configuration de PHP pour une utilisation depuis Apache se trouve à cet emplacement : "/etc/php5/apache2/php.ini" (pour une installation depuis les dépôts).

Seulement voilà, on a parfois besoin d'appliquer une configuration PHP seulement à un **virtual host** en particulier et non aux autres. Par exemple, on peut souhaiter activer l'affichage des erreurs de PHP pour une application web encore en développement sans modifier la configuration des applications en production. Pour réaliser cette tâche, Apache met à notre disposition les instructions suivantes (valables uniquement pour le module PHP d'Apache) :

    php_value <directive> <valeur>
    php_admin_value <directive> <valeur>
    php_flag <directive> <on|off>
    php_admin_flag <directive> <on|off>

Pour pouvoir les utiliser au sein d'un **.htaccess**, il faut posséder les privilèges **AllowOverride Options** ou **AllowOverride All**.

Les instructions "php_value" et "php_admin_value" permettent de modifier la valeur de la directive précisée en paramètre. Exemple :

    php_admin_value open_basedir /var/www/vhosts/mysite

Les instructions "php_flag" et "php_admin_flag", quant à elles, permettent d'activer ou de désactiver l'option précisée en paramètre (à utiliser pour les directives booléennes). Exemple :

    php_admin_flag display_errors on

La différence entre les instructions avec et sans le mot clé "admin" réside dans le fait que celles avec ne peuvent pas être modifiées depuis un ".htaccess", ni avec la fonction [ini_set][1].

Grâce à ce système, vous allez pouvoir personnaliser la configuration PHP de vos virtual hosts.

 [1]: http://www.php.net/manual/fr/function.ini-set.php "Function ini set - PHP Manual"
