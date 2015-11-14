La fonction ci-dessous permet de tester une adresse IPv4 pour vérifier qu'elle est bien formée :

    function is_ipv4
    {
        echo $1 | grep -Eq '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b'
    
        return $?
    }

Et voici un exemple d'utilisation :

    is_ipv4 $ip
    
    if [ "$?" -ne 0 ]
    then
        echo "[x] $ip is not an IPv4"
        exit 1
    fi
