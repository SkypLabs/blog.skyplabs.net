Je développe actuellement en C# pour les besoins de mon entreprise. Devant réécrire un code C++ contenant un grand nombre de defines en C#, voici comment j'ai automatisé la tâche :

    awk '{print "public const UInt16 " $2 " = " substr($0, index($0, $3)) ";"}' defines_c.txt

Le fichier *defines_c.txt* contient les defines à convertir. Et voici le résultat :

* Avant :

        #define TEST 2

* Après :

        public const UInt16 TEST = 2;
