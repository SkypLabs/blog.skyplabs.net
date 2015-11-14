Avant toute chose, nous allons commencer par un petit rappel de vocabulaire autour des différents capteurs inertiels existants :

*   [**Gyroscope**][1] : Capteur indiquant la position angulaire.
*   [**Gyromètre**][2] : Capteur indiquant la vitesse angulaire.
*   [**Accéléromètre**][3] : Capteur indiquant l'accélération linéaire.
*   [**Centrale inertielle**][4] : Capteur embarquant un gyromètre à trois axes et un accéléromètre à trois axes et permettant de déterminer la position du mobile sur lequel il a été fixé à condition de connaître la position d'origine de ce dernier (technologie utilisée à bord des avions par exemple).

La carte de développement [**ATAVRSBIN1**][5] que nous allons tester au cours de cet article est équipée de deux de ces capteurs : elle embarque un **gyromètre** (ITG-3200) et un **accéléromètre** (BMA-150). Le ITG-3200 est pourtant vendu comme étant un gyroscope, mais en regardant sa datasheet, on s'aperçoit qu'il retourne une mesure en °/s. C'est une erreur très commune donc prenez garde la prochaine fois que vous sélectionnerez un produit de la sorte.

La ATAVRSBIN1 possède également une **boussole électronique** à effet de Hall (AK8975). Cette dernière ne repose donc pas sur le principe d'inertie et n'est par conséquent pas un capteur inertiel contrairement à l'intitulé du produit.

Une autre petite subtilité : les circuits ITG-3200 et BMA-150, en plus de faire office respectivement de gyromètre et d’accéléromètre, embarquent également un **capteur de température**.

Tous les circuits cités plus haut utilisent un bus [**I²C**][6] pour s'interconnecter avec d'autres systèmes électroniques.

Enfin, la carte est disponible chez [Farnell][7].

<!--more-->

## Montage de test

Pour ce test, j'ai utilisé une carte microcontrôleur Arduino Uno (rev3) afin de lire les valeurs renvoyées par les différents capteurs au moyen d'une liaison I²C. Le câblage est le suivant :

![Schéma du montage de test de la carte ATAVRSBIN1][8]

## Communication I²C avec les capteurs

La [datasheet][9] de la carte ATAVRSBIN1 nous donne les adresses I²C suivantes :

*   AK8975 : 0x0C
*   BMA-150 : 0x38
*   ITG-3200 : 0x68

Côté logiciel, j'ai utilisé la bibliothèque [Wire][10] du projet Arduino.

## Exemple avec le gyromètre ITG-3200

Plusieurs bibliothèques pour Arduino sont [disponibles][11] afin de communiquer avec les différents circuits de la carte ATAVRSBIN1. Je ne vais donc pas réinventer la roue mais plutôt donner un exemple à titre pédagogique sur comment établir la communication I²C afin de récupérer les valeurs qui nous intéressent. Pour cela, j'ai choisi de me concentrer sur le gyromètre ITG-3200.

Les registres internes contenant les valeurs retournées par les capteurs sont données dans la [datasheet][12] sous forme du tableau suivant :

![Tableau des registres du ITG-3200][13]

Chaque capteur retourne une valeur sur 16 bits codée en code complément à 2. Étant donné que la lecture se fait octet par octet sur un bus I²C, il sera nécessaire d'utiliser des décalages par 8 pour reconstituer nos valeurs sur 16 bits.

Nous allons récupérer l'ensemble de ces valeurs d'un seul coup en lisant 8 octets à partir de l'adresse du premier registre, à savoir 0x1B. La séquence de "burst read" utilisée pour lire plusieurs octets en une seule interrogation I²C est la suivante :

![Schéma d'une séquence de "burst read" pour le ITG-3200][14]

Une fois les valeurs récupérées, il sera nécessaire d'effectuer quelques opérations mathématiques afin d'obtenir des unités lisibles, à savoir des °C pour le capteur de température et des degrés par seconde pour les trois axes du gyromètre.

Enfin, voici le code utilisé pour cet exemple :

    #include <Wire.h>
    
    void setup()
    {
        Wire.begin();
        Serial.begin(9600);
    }
    
    const float gyro_factor = 14.375;
    
    byte reading[8];
    short temp_out = 0, x = 0, y = 0, z = 0;
    float gyro_x = 0, gyro_y = 0, gyro_z = 0, temp = 0;
    
    void loop()
    {
        int i = 0;
    
        Wire.beginTransmission(0x68);       // ITG_3200 address
        Wire.write(byte(0x1b));             // TEMP_OUT_H address
        Wire.endTransmission(false);
    
        Wire.requestFrom(0x68, 8);
    
        while (Wire.available())
        {
            reading[i] = Wire.read();
            i++;
        }
    
        temp_out = (reading[0] << 8) | reading[1];
        temp = 35 + (temp_out + 13200) / 280.0;
    
        x = (reading[2] << 8) | reading[3];
        gyro_x = x / gyro_factor;
        y = (reading[4] << 8) | reading[5];
        gyro_y = y / gyro_factor;
        z = (reading[6] << 8) | reading[7];
        gyro_z = z / gyro_factor;
    
        Serial.println(temp);
        Serial.println(gyro_x);
        Serial.println(gyro_y);
        Serial.println(gyro_z);
        Serial.println("------------");
    
        Wire.endTransmission();
        delay(1000);
    }

 [1]: http://fr.wikipedia.org/wiki/Gyroscope
 [2]: http://fr.wikipedia.org/wiki/Gyrom%C3%A8tre
 [3]: http://fr.wikipedia.org/wiki/Acc%C3%A9l%C3%A9rom%C3%A8tre
 [4]: http://fr.wikipedia.org/wiki/Centrale_%C3%A0_inertie
 [5]: http://fr.farnell.com/atmel/atavrsbin1/carte-inertial-capteur-9dof/dp/1972205
 [6]: http://fr.wikipedia.org/wiki/I2C
 [7]: http://fr.farnell.com/
 [8]: http://blog.skyplabs.net/wp-content/uploads/2014/10/ATAVRSBIN1_wiring.png
 [9]: http://www.farnell.com/datasheets/1509379.pdf
 [10]: http://arduino.cc/en/reference/wire
 [11]: https://github.com/jrowberg/i2cdevlib/tree/master/Arduino
 [12]: https://www.sparkfun.com/datasheets/Sensors/Gyro/PS-ITG-3200-00-01.4.pdf
 [13]: http://blog.skyplabs.net/wp-content/uploads/2014/10/ITG-3200_registers.png
 [14]: http://blog.skyplabs.net/wp-content/uploads/2014/10/ITG-3200_burst_read.png
