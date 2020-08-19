---
layout: post
title: "[ndh2k16] Hello Friend"
categories:
    - Hacking et Sécurité
    - Stéganographie
tags:
    - ndh2k16
    - Wargame
    - Write-up
---
Une des épreuves du wargame de la nuit du hack 2016 était de retrouver un code de validation à partir de cette image :

![Fichier JPEG utilisé pour le challenge "hello friend" lors de la nuit du hack 2016][hello friend]

<!--more-->

En utilisant l'outil `strings` sur l'image, nous obtenons les lignes suivantes :

    $ strings hellofriend.jpg
    ...
    WhoAmI.png
    Hello_friend/
    Hello_friend/0/
    Hello_friend/0/64.png
    Hello_friend/1/
    Hello_friend/1/61.png
    Hello_friend/2/
    Hello_friend/2/72.png
    Hello_friend/3/
    Hello_friend/3/6b.png
    Hello_friend/4/
    Hello_friend/4/63.png
    Hello_friend/5/
    Hello_friend/5/30.png
    Hello_friend/6/
    Hello_friend/6/64.png
    Hello_friend/7/
    Hello_friend/7/65.png
    Hello_friend/8/
    Hello_friend/8/IsItReal.jpg
    Hello_friend/9/
    HaVft
    Hello_friend/9/3xploits.jpg

Nous en déduisons qu'une archive ZIP est cachée dans le même fichier. L'outil `binwalk` peut nous en convaincre :

    $ binwalk hellofriend.jpg

    DECIMAL       HEXADECIMAL     DESCRIPTION
    --------------------------------------------------------------------------------
    0             0x0             JPEG image data, JFIF standard  1.01
    382           0x17E           Copyright string: " (c) 1998 Hewlett-Packard Companyny"
    3192          0xC78           TIFF image data, big-endian
    116141        0x1C5AD         Zip archive data, at least v2.0 to extract, compressed size: 6264,  uncompressed size: 6376, name: "WhoAmI.png"
    122445        0x1DE4D         Zip archive data, at least v1.0 to extract, name: "Hello_friend/"
    122488        0x1DE78         Zip archive data, at least v1.0 to extract, name: "Hello_friend/0/"
    122533        0x1DEA5         Zip encrypted archive data, at least v2.0 to extract, compressed size: 4381,  uncompressed size: 4882, name: "Hello_friend/0/64.png"
    126981        0x1F005         Zip archive data, at least v1.0 to extract, name: "Hello_friend/1/"
    127026        0x1F032         Zip encrypted archive data, at least v2.0 to extract, compressed size: 4381,  uncompressed size: 4882, name: "Hello_friend/1/61.png"
    131474        0x20192         Zip archive data, at least v1.0 to extract, name: "Hello_friend/2/"
    131519        0x201BF         Zip encrypted archive data, at least v2.0 to extract, compressed size: 4381,  uncompressed size: 4882, name: "Hello_friend/2/72.png"
    135967        0x2131F         Zip archive data, at least v1.0 to extract, name: "Hello_friend/3/"
    136012        0x2134C         Zip encrypted archive data, at least v2.0 to extract, compressed size: 4381,  uncompressed size: 4882, name: "Hello_friend/3/6b.png"
    140460        0x224AC         Zip archive data, at least v1.0 to extract, name: "Hello_friend/4/"
    140505        0x224D9         Zip encrypted archive data, at least v2.0 to extract, compressed size: 4381,  uncompressed size: 4882, name: "Hello_friend/4/63.png"
    144953        0x23639         Zip archive data, at least v1.0 to extract, name: "Hello_friend/5/"
    144998        0x23666         Zip encrypted archive data, at least v2.0 to extract, compressed size: 4381,  uncompressed size: 4882, name: "Hello_friend/5/30.png"
    149446        0x247C6         Zip archive data, at least v1.0 to extract, name: "Hello_friend/6/"
    149491        0x247F3         Zip encrypted archive data, at least v2.0 to extract, compressed size: 4381,  uncompressed size: 4882, name: "Hello_friend/6/64.png"
    153939        0x25953         Zip archive data, at least v1.0 to extract, name: "Hello_friend/7/"
    153984        0x25980         Zip encrypted archive data, at least v2.0 to extract, compressed size: 4381,  uncompressed size: 4882, name: "Hello_friend/7/65.png"
    158432        0x26AE0         Zip archive data, at least v1.0 to extract, name: "Hello_friend/8/"
    158477        0x26B0D         Zip encrypted archive data, at least v2.0 to extract, compressed size: 101679,  uncompressed size: 133658, name: "Hello_friend/8/IsItReal.jpg"
    260229        0x3F885         Zip archive data, at least v1.0 to extract, name: "Hello_friend/9/"
    260274        0x3F8B2         Zip encrypted archive data, at least v2.0 to extract, compressed size: 286495,  uncompressed size: 298687, name: "Hello_friend/9/3xploits.jpg"
    549041        0x860B1         End of Zip archive

L'outil `unzip` est capable de décompresser une archive ZIP même quand cette dernière est enfouie au sein d'un autre fichier. La preuve :

    $ unzip hellofriend.jpg
	Archive:  hellofriend.jpg
	warning [hellofriend.jpg]:  116141 extra bytes at beginning or within zipfile
	  (attempting to process anyway)
	  inflating: WhoAmI.png
	   creating: Hello_friend/
	   creating: Hello_friend/0/
	[hellofriend.jpg] Hello_friend/0/64.png password:

Pour trouver ce premier mot de passe, il faut commencer par comprendre d'où vient le message "Hello Friend". En effet, le nom de l'épreuve lui-même est un indice. Après une recherche sur internet, nous découvrons que cela correspond au titre du premier épisode de la série TV "Mr. Robot". Sur Wikipédia, nous pouvons lire :

> « Hello Friend » est aussi le premier message par lequel Elliot est contacté par Fsociety.

Et ainsi, nous découvrons ce premier mot de passe : `fsociety`.

Après décompression, nous obtenons l'arborescence suivante :

    Hello_friend/
    ├── 0
    │   └── 64.png
    ├── 1
    │   └── 61.png
    ├── 2
    │   └── 72.png
    ├── 3
    │   └── 6b.png
    ├── 4
    │   └── 63.png
    ├── 5
    │   └── 30.png
    ├── 6
    │   └── 64.png
    ├── 7
    │   └── 65.png
    ├── 8
    │   └── IsItReal.jpg
    └── 9
        └── 3xploits.jpg

    10 directories, 10 files

Les dossiers de 0 à 7 contiennent la même image mais avec un nom différent à chaque fois. L'image du dossier 8 n'apporte rien de particulier contrairement à celle du dossier 9 qui renferme là encore une archive ZIP demandant un mot de passe :

    $ unzip 9/3xploits.jpg
    Archive:  9/3xploits.jpg
    warning [9/3xploits.jpg]:  186158 extra bytes at beginning or within zipfile
      (attempting to process anyway)
    [9/3xploits.jpg] d3bug.png password:

Nous devons donc trouver à nouveau un mot de passe. Les noms des 8 premières images font penser à de l'hexadécimal. Après conversion en ASCII, voilà ce que l'on obtient :

    $ echo '6461726b63306465' | xxd -r -p
    darkc0de

Malheureusement, ce n'est pas le mot de passe que nous recherchons. Après investigation, nous découvrons que *darkc0de* fait référence à un [dictionnaire de mots de passe][darkc0de]. Nous comprenons que le mot de passe doit se trouver dans ce dictionnaire.

`fcrackzip` permet d'effectuer des attaques par dictionnaire sur des fichiers ZIP. Cependant, contrairement à `unzip`, il n'est pas capable de trouver le fichier ZIP contenu dans l'image par lui-même :

    $ fcrackzip -uDv -p ~/Downloads/darkc0de.lst 3xploits.jpg
    found id dbffd8ff, '3xploits.jpg' is not a zipfile ver 2.xx, skipping
    no usable files found

Grâce à `unzip`, nous savons que 186158 octets sont présents avant le début du fichier ZIP :

    $ unzip -l 3xploits.jpg
    Archive:  3xploits.jpg
    warning [3xploits.jpg]:  186158 extra bytes at beginning or within zipfile
      (attempting to process anyway)
      Length      Date    Time    Name
    ---------  ---------- -----   ----
       302979  05-05-2016 23:49   d3bug.png
    ---------                     -------
       302979                     1 file

Pour supprimer ces octets superflus, nous pouvons utiliser l'outil `dd` :

    $ file 3xploits.jpg
    3xploits.jpg: JPEG image data, baseline, precision 8, 640x640, frames 3
    $ dd if=3xploits.jpg of=3xploits.zip skip=1 bs=186158
    0+1 records in
    0+1 records out
    112529 bytes (113 kB) copied, 0,000613072 s, 184 MB/s
    $ file 3xploits.zip
    3xploits.zip: Zip archive data, at least v2.0 to extract

Maintenant, il est temps de lancer notre attaque par dictionnaire :

    $ fcrackzip -uDv -p ~/Downloads/darkc0de.lst 3xploits.zip
    found file 'd3bug.png', (size cp/uc 112361/302979, flags 9, chk be20)
    PASSWORD FOUND!!!!: pw == How do you like me now?

Le mot de passe était donc `How do you like me now?`.

Et voici l'image contenue dans l'archive ZIP avec le code de validation inscrit dessus :

![Image contenant le code de validation][d3bug]

[hello friend]: https://skyplabs.keybase.pub/Blog/Downloads/hellofriend.jpg
[darkc0de]: https://github.com/empijei/useful-commands/blob/master/exploiting/wifi/darkc0de.lst
[d3bug]: /assets/images/ndh2k16_hello_friend_d3bug.png
