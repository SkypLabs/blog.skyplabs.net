---
layout: post
title: "Télécommander sa télévision et ses autres appareils à infrarouge depuis son smartphone"
categories:
    - Électronique
    - Développement
tags:
    - Android
    - Infrarouge
---
Je ne sais pas pour vous, mais moi j'ai toujours eu horreur de devoir jongler avec plusieurs télécommandes alors que je ne cherchais qu'à réaliser des tâches plutôt triviales. Une télécommande pour allumer la télévision, une autre pour allumer le home cinema ... et plus on multiplie les appareils électroniques dans son salon, plus on collectionne de télécommandes !

Dans le but de me simplifier la vie, j'ai donc décidé de réaliser un montage électronique pour pouvoir piloter mes appareils à infrarouge depuis un système informatique classique, en particulier depuis mon téléphone portable. Je vais donc détailler dans cet article les différentes étapes de la réalisation ainsi que les différents éléments permettant de reproduire à l'identique le système que j'ai développé.

<!--more-->

Pour commencer, un petit aperçu de la réalisation s'impose. Les principaux appareils que je désirais pouvoir contrôler à distance depuis mon smartphone sont ma télévision et mon home cinema. Le principal obstacle à cela est qu'aucun téléphone récent ne possède d'interface **infrarouge**. Il est donc impossible de faire communiquer le téléphone directement avec mon installation multimédia, d'où la réalisation d'un montage électronique qui servira d'intermédiaire. En effet, ce petit montage va jouer le rôle de "proxy", l'échange entre le téléphone et ce dernier se faisant en **bluetooth**. Ce choix m'est apparu évident pour deux raisons simples. Premièrement, le bluetooth est une technologie omniprésente qui est embarquée dans tous les smartphones qui se respectent. Deuxièmement, un ami m'avait récemment offert un module bluetooth et je ne m'en étais pas encore servi :)

Voici donc la liste des éléments utilisés pour la réalisation complète :

* Un smartphone (Nexus S sous Android)
* Une carte Arduino (Uno)
* Un module bluetooth (Sparkfun Bluetooth Mate Gold)
* Une diode à infrarouge émettrice (CQY 89)
* Une carte électronique conçue spécifiquement pour relier les différents éléments entre eux

## À la découverte du protocole NEC

Le protocole de communication infrarouge utilisé par ma télévision et par mon home cinema (tous deux de la marque Samsung) est celui développé par NEC. Il utilise des trames simples, composées d'une adresse codée sur 8 ou 16 bits selon la version du protocole ainsi que la commande à transmettre codée sur 8 bits. Le nombre maximum de commandes distinctes est donc de 256 par appareil. Pour coder les 1 et les 0 logiques, il utilise une impulsion haute de 560 µs suivie par une impulsion basse d'une durée qui dépend du bit à transmettre. 560 µs pour un 0 logique ou 1.70 ms environ pour un 1 logique. Pour plus de détails, vous pouvez vous rendre sur [cette page][protocole_nec].

Pour mener à bien mon projet, j'avais besoin de récupérer l'adresse de mes différents appareils ainsi que le code des commandes à transmettre pour pouvoir les reproduire depuis mon montage électronique. Heureusement, j'ai la chance de posséder un récepteur infrarouge sur mon ordinateur portable. J'ai donc utilisé l'utilitaire **mode2** du projet [LIRC][lirc] pour récupérer la durée des impulsions générées par mes télécommandes et ainsi interpréter leur signification. Pour accélérer ce travail rébarbatif, j'ai écrit très rapidement un petit script bash qui me retourne la valeur décimale de la commande contenue dans la trame :

{% gist SkypLabs/d7bf68a44300b3432798ce8177b63629 nec_decoder.sh %}

Avec ce script, j'ai balayé l'ensemble des commandes utilisées par ma télévision et mon home cinema. Par exemple, pour allumer ma télévision, la commande en décimale est 153. À vous de faire pareil avec vos appareils !

## Faire le lien entre le bluetooth et l'infrarouge grâce à l'Arduino

Maintenant que l'on connait comment le protocole NEC fonctionne, on peut l'implémenter dans la carte Arduino pour transmettre les commandes infrarouges. La réception bluetooth se fait via une liaison série entre le module bluetooth et la carte Arduino. Pour envoyer une commande via ce montage vers un appareil distant utilisant l'infrarouge, il faut en premier lieu envoyer l'adresse du destinataire puis la commande à proprement parler. Toutes ces informations doivent être transmises en décimale octet par octet sous forme d'une chaîne de caractères. Un octet est représenté par 3 caractères.

Par exemple, pour allumer ma télévision, je dois envoyer la chaîne `007007153`. Ces 9 caractères représentent donc 3 octets. `007007` correspond aux 2 octets constituant l'adresse de ma télévision et `153` à la commande d'allumage.

Voici le code développé pour la carte Arduino (à compiler avec le SDK officiel) :

{% gist SkypLabs/d7bf68a44300b3432798ce8177b63629 nec_ir_rc.ino %}

## Le montage final

Pour relier les différentes parties du montage final entre elles, j'ai réalisé un shield Arduino grâce au logiciel de CAO **EAGLE PCB Software**. Le gros avantage de cette solution est qu'il devient très facile de monter/démonter les différents composants de la réalisation étant donné que j'utilise des supports pour toutes les connexions. Cela procure une certaine propreté du montage. En voici une photo :

![TV_RC Project - Montage final](/assets/images/tv_rc_montage_final.jpg)

Vous trouverez l'archive ZIP contenant le PCB du sheild Arduino au format EPS à [cette adresse][pcb_zip_file].

## L'application Android

Pour terminer ma réalisation, j'ai développé une application Android pour pouvoir piloter le tout depuis mon smartphone et/ou ma tablette. Ce programme nécessite un certain nombre d'améliorations (il s'agit principalement d'un PoC et non pas d'un logiciel achevé) mais est parfaitement fonctionnel. Il a été testé sur mon Nexus S et sur le Nexus One de ma copine.

Vous trouverez l'apk et le code source de l'application à [cette adresse][tv_remote_control]. Bien que développée pour n'être utilisée que pour ma propre installation, vous pourrez vous en inspirer pour l'adapter à votre matériel.

## Conclusion

La réalisation de ce projet m'a permis de m'investir un peu plus dans le domaine de la domotique. En effet, l'intérêt premier n'est pas seulement de pouvoir piloter mes appareils à infrarouge depuis mon smartphone, mais depuis n'importe quel système informatique. En pratique, il est donc possible de perfectionner la réalisation en y rajoutant de la reconnaissance vocale, des tags RFID bien placés dans l'appartement (mon Nexus S possède un lecteur NFC), etc.

Affaire à suivre ...

[protocole_nec]: https://www.sbprojects.com/knowledge/ir/nec.php "NEC protocol"
[lirc]: http://www.lirc.org/ "LIRC"
[pcb_zip_file]: https://keybase.pub/skyplabs/Blog/Downloads/TV_RC_ARDUINO_SHIELD_PCB_V1.zip "TV_RC_ARDUINO_SHIELD_PCB_V1.zip"
[tv_remote_control]: https://keybase.pub/skyplabs/Blog/Downloads/tv_rc_android_v0.1.apk "TV Remote Control Project"
