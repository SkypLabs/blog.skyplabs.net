Je ne sais pas pour vous, mais moi j'ai toujours eu horreur de devoir jongler avec plusieurs télécommandes alors que je ne cherchais qu'à réaliser des tâches plutôt triviales. Une télécommande pour allumer la télévision, une autre pour allumer le home cinema ... et plus on multiplie les appareils électroniques dans son salon, plus on collectionne de télécommandes !

Dans le but de me simplifier la vie, j'ai donc décidé de réaliser un montage électronique pour pouvoir piloter mes appareils à infrarouge depuis un système informatique classique, en particulier depuis mon téléphone portable. Je vais donc détailler dans cet article les différentes étapes de la réalisation ainsi que les différents éléments permettant de reproduire à l'identique le système que j'ai développé.

Pour commencer, un petit aperçu de la réalisation s'impose. Les principaux appareils que je désirais pouvoir contrôler à distance depuis mon smartphone sont ma télévision et mon home cinema. Le principal obstacle à cela est qu'aucun téléphone récent ne possède d'interface **infrarouge**. Il est donc impossible de faire communiquer le téléphone directement avec mon installation multimédia, d'où la réalisation d'un montage électronique qui servira d'intermédiaire. En effet, ce petit montage va jouer le rôle de "proxy", l'échange entre le téléphone et ce dernier se faisant en **bluetooth**. Ce choix m'est apparu évident pour deux raisons simples. Premièrement, le bluetooth est une technologie omniprésente qui est embarquée dans tous les smartphones qui se respectent. Deuxièmement, un ami m'avait récemment offert un module bluetooth et je ne m'en étais pas encore servi :)

Voici donc la liste des éléments utilisés pour la réalisation complète :

*   Un smartphone (Nexus S sous Android)
*   Une carte Arduino (Uno)
*   Un module bluetooth (Sparkfun Bluetooth Mate Gold)
*   Une diode à infrarouge émettrice (CQY 89)
*   Une carte électronique conçue spécifiquement pour relier les différents éléments entre eux

<!--more-->

# À la découverte du protocole NEC

Le protocole de communication infrarouge utilisé par ma télévision et par mon home cinema (tous deux de la marque Samsung) est celui développé par NEC. Il utilise des trames simples, composées d'une adresse codée sur 8 ou 16 bits selon la version du protocole ainsi que la commande à transmettre codée sur 8 bits. Le nombre maximum de commandes distinctes est donc de 256 par appareil. Pour coder les 1 et les 0 logiques, il utilise une impulsion haute de 560 µs suivie par une impulsion basse d'une durée qui dépend du bit à transmettre. 560 µs pour un 0 logique ou 1.70 ms environ pour un 1 logique. Pour plus de détails, vous pouvez vous rendre sur [cette page][1].

Pour mener à bien mon projet, j'avais besoin de récupérer l'adresse de mes différents appareils ainsi que le code des commandes à transmettre pour pouvoir les reproduire depuis mon montage électronique. Heuresement, j'ai la chance de posséder un récepteur infrarouge sur mon ordinateur portable. J'ai donc utilisé l'utilitaire **mode2** du projet [LIRC][2] pour récupérer la durée des impulsions générées par mes télécommandes et ainsi interpréter leur signification. Pour accélérer ce travail rébarbatif, j'ai écrit très rapidement un petit script bash qui me retourne la valeur décimale de la commande contenue dans la trame :

    #!/bin/bash
    
    # Retourne la valeur décimale de la commande contenue dans les trames
    # infrarouges utilisant le protocole NEC.
    #
    # Utiliser le sortie de l'exécutable mode2 du projet LIRC comme entrée du script.
    #
    # by Skyper - http://blog.skyplabs.net
    
    if [ -z $1 ]
    then
        echo "Usage: $0 <LIRC decode file>"
        exit 0
    fi
    
    if [ ! -d $1 ]
    then
        echo "Error: $1 doesn't exist"
        exit 1
    fi
    
    obc_code=0
    
    space_up=1650
    space_up2=1700
    
    bit1=$(/bin/cat $1 | /bin/awk 'NR==37 {print $2}')
    bit2=$(/bin/cat $1 | /bin/awk 'NR==39 {print $2}')
    bit3=$(/bin/cat $1 | /bin/awk 'NR==41 {print $2}')
    bit4=$(/bin/cat $1 | /bin/awk 'NR==43 {print $2}')
    bit5=$(/bin/cat $1 | /bin/awk 'NR==45 {print $2}')
    bit6=$(/bin/cat $1 | /bin/awk 'NR==47 {print $2}')
    bit7=$(/bin/cat $1 | /bin/awk 'NR==49 {print $2}')
    bit8=$(/bin/cat $1 | /bin/awk 'NR==51 {print $2}')
    
    if [ "$bit1" == "$space_up" ] || [ "$bit1" == "$space_up2" ]
    then
        obc_code=$(expr $obc_code + 1)
    fi
    
    if [ "$bit2" == "$space_up" ] || [ "$bit2" == "$space_up2" ]
    then
        obc_code=$(expr $obc_code + 2)
    fi
    
    if [ "$bit3" == "$space_up" ] || [ "$bit3" == "$space_up2" ]
    then
        obc_code=$(expr $obc_code + 4)
    fi
    
    if [ "$bit4" == "$space_up" ] || [ "$bit4" == "$space_up2" ]
    then
        obc_code=$(expr $obc_code + 8)
    fi
    
    if [ "$bit5" == "$space_up" ] || [ "$bit5" == "$space_up2" ]
    then
        obc_code=$(expr $obc_code + 16)
    fi
    
    if [ "$bit6" == "$space_up" ] || [ "$bit6" == "$space_up2" ]
    then
        obc_code=$(expr $obc_code + 32)
    fi
    
    if [ "$bit7" == "$space_up" ] || [ "$bit7" == "$space_up2" ]
    then
        obc_code=$(expr $obc_code + 64)
    fi
    
    if [ "$bit8" == "$space_up" ] || [ "$bit8" == "$space_up2" ]
    then
        obc_code=$(expr $obc_code + 128)
    fi
    
    echo $obc_code

Avec ce script, j'ai balayé l'ensemble des commandes utilisées par ma télévision et mon home cinema. Par exemple, pour allumer ma télévision, la commande en décimale est 153. À vous de faire pareil avec vos appareils !

# Faire le lien entre le bluetooth et l'infrarouge grâce à l'Arduino

Maintenant que l'on connait comment le protocole NEC fonctionne, on peut l'implémenter dans la carte Arduino pour transmettre les commandes infrarouges. La réception bluetooth se fait via une liaison série entre le module bluetooth et la carte Arduino. Pour envoyer une commande via ce montage vers un appareil distant utilisant l'infrarouge, il faut en premier lieu envoyer l'adresse du destinataire puis la commande à proprement parler. Toutes ces informations doivent être transmises en décimale octet par octet sous forme d'une chaîne de caractères. Un octet est représenté par 3 caractères.

Par exemple, pour allumer ma télévision, je dois envoyer la chaîne "007007153". Ces 9 caractères représentent donc 3 octets. "007007" correspond aux 2 octets constituant l'adresse de ma télévision et "153" à la commande d'allumage.

Voici le code développé pour la carte Arduino (à compiler avec le SDK officiel) :

    // Original code by Lucas Eckels
    // http://lucaseckels.com
    
    // Edited by Skyper
    // http://blog.skyplabs.net
    
    // IR remote control emitter for NEC protocol remote, as described at
    // http://www.sbprojects.com/knowledge/ir/nec.htm
    // Tested on a Samsung LCD TV.
    
    #include <util/delay.h>
    
    #define IR_PIN 13
    
    // With CONTINOUS defined, the first command is repeated continuously until
    // you reset the Arduino.  Otherwise, it sends the code once, then waits for
    // another command.
    //#define CONTINUOUS
    
    // Times are in microseconds
    #define ON_START_TIME 4500
    #define OFF_START_TIME 4500
    #define ON_TIME 580
    #define OFF_TIME_ONE 1670
    #define OFF_TIME_ZERO 540
    
    void setup()
    {
        pinMode(IR_PIN, OUTPUT);
        digitalWrite(IR_PIN, LOW);
        Serial.begin(9600);
        delay(1000);
        Serial.println("SkypLabs - TV Remote Control");
    }
    
    byte command = 0;
    byte address_1 = 0;
    byte address_2 = 0;
    
    int commandCount = 0;
    int addressCount_1 = 0;
    int addressCount_2 = 0;
    
    bool commandReady = false;
    
    void loop()
    {
        if (commandReady)
        {
            Serial.println("Command OK");
    
            writeStart();
            // Writing device code
            writeByte(address_1);
            writeByte(address_2);
    
            // Writing command code
            writeByte(command);
            writeByte(~command);
            writeEnd();
            delay(100);
    
    #ifndef CONTINUOUS
            commandReady = false;
            command = 0;
            address_1 = 0;
            address_2 = 0;
            commandCount = 0;
            addressCount_1 = 0;
            addressCount_2 = 0;
    #endif
            return;
        }
    
        if (Serial.available() > 0)
        {
            byte incoming = Serial.read();
    
            if (incoming <= '9' || incoming >= '0')
            {
                if (addressCount_1 != 3)
                {
                    address_1 *= 10;
                    address_1 += incoming - '0';
                    ++addressCount_1;
                }
                else if (addressCount_2 != 3)
                {
                    address_2 *= 10;
                    address_2 += incoming - '0';
                    ++addressCount_2;
                }
                else if (commandCount != 3)
                {
                    command *= 10;
                    command += incoming - '0';
                    ++commandCount;
                }
    
                if (commandCount == 3)
                    commandReady = true;
            }
        }
    }
    
    void writeStart()
    {
        modulate(ON_START_TIME);
        delayMicroseconds(OFF_START_TIME);
    }
    
    void writeEnd()
    {
        modulate(ON_TIME);
    }
    
    void writeByte(byte val)
    {
        // Starting with the LSB, write out the 
        for (int i = 0x01; i & 0xFF; i <<= 1)
        {
            modulate(ON_TIME);
    
            if (val & i)
                delayMicroseconds(OFF_TIME_ONE);
            else
                delayMicroseconds(OFF_TIME_ZERO);
        }
    }
    
    void modulate(int time)
    {
        int count = time / 26;
        byte portb = PORTB;
        byte portbHigh = portb | 0x20; // Pin 13 is controlled by 0x20 on PORTB.
        byte portbLow = portb & ~0x20;
    
        for (int i = 0; i <= count; i++)
        {
            // The ideal version of this loop would be:
            // digitalWrite(IR_PIN, HIGH);
            // delayMicroseconds(13);
            // digitalWrite(IR_PIN, LOW);
            // delayMicroseconds(13);
            // But I had a hard time getting the timing to work right.  This approach was found
            // through experimentation.
            PORTB = portbHigh;
            _delay_loop_1(64);
            PORTB = portbLow;
            _delay_loop_1(64);
        }
    
        PORTB = portb;
    }

# Le montage final

Pour relier les différentes parties du montage final entre elles, j'ai réalisé un shield Arduino grâce au logiciel de CAO **EAGLE PCB Software**. Le gros avantage de cette solution est qu'il devient très facile de monter/démonter les différents composants de la réalisation étant donné que j'utilise des supports pour toutes les connexions. Cela procure une certaine propreté du montage. En voici une photo :

![TV_RC Project - Montage final][3]

Vous trouverez l'archive ZIP contenant le PCB du sheild Arduino au format EPS à [cette adresse][4].

# L'application Android

Pour terminer ma réalisation, j'ai développé une application Android pour pouvoir piloter le tout depuis mon smartphone et/ou ma tablette. Ce programme nécessite un certain nombre d'améliorations (il s'agit principalement d'un PoC et non pas d'un logiciel achevé) mais est parfaitement fonctionnel. Il a été testé sur mon Nexus S et sur le Nexus One de ma copine.

Vous trouverez l'apk et le code source de l'application à [cette adresse][5]. Bien que développée pour n'être utilisée que pour ma propre installation, vous pourrez vous en inspirer pour l'adapter à votre matériel.

# Conclusion

La réalisation de ce projet m'a permis de m'investir un peu plus dans le domaine de la domotique. En effet, l'intérêt premier n'est pas seulement de pouvoir piloter mes appareils à infrarouge depuis mon smartphone, mais depuis n'importe quel système informatique. En pratique, il est donc possible de perfectionner la réalisation en y rajoutant de la reconnaissance vocale, des tags RFID bien placés dans l'appartement (mon Nexus S possède un lecteur NFC), etc.

Affaire à suivre ...

 [1]: http://www.sbprojects.com/knowledge/ir/nec.php "NEC protocol"
 [2]: http://www.lirc.org/ "LIRC"
 [3]: http://blog.skyplabs.net/wp-content/uploads/2012/07/IMG_20120512_150151.jpg "TV_RC Project - Montage final"
 [4]: http://blog.skyplabs.net/wp-content/uploads/2012/07/TV_RC_ARDUINO_SHIELD_PCB_V1.zip "TV_RC_ARDUINO_SHIELD_PCB_V1.zip"
 [5]: http://code.google.com/p/tv-remote-control/ "TV Remote Control Project"
