Le [BLE Micro][1] est une petite carte électronique produite par [Seeed Studio][2] embarquant le SoC [nRF51822][3] de Nordic Semiconductor. Ce dernier est un module de communication Bluetooth Low Energy (BLE) basé un Cortex M0.

![BLE Micro de Seeed Studio][4]

Pour développer un programme à destination de ce circuit, le [wiki officiel du BLE Micro][5] nous renvoie sur [une page GitHub][6] contenant un SDK dédié. Ce dernier est basé sur le [mbed SDK][7] de ARM avec son [API pour le BLE][8]. La compilation du code nécessite la toolchain [gcc-arm-embedded][9] avec certaines dépendances comme la newlib-nano.

Afin de ne pas perdre de temps à préparer l'environnement de développement adéquat, j'ai mis en ligne un conteneur Docker disponible sur le [Docker Hub Registry][10]. Après un échange d'e-mails avec la personne s'occupant du BLE Micro chez Seeed Studio, le lien vers mon conteneur a été ajouté sur le wiki officiel :

> If you are familiar with the Docker, there is a Docker container created by Paul for you to setup toolchain quickly. You can follow the instructions on the Docker page to get started.

N'hésitez pas à me faire part de votre avis concernant l'utilisation de ce produit ou de mon conteneur Docker.

 [1]: http://www.seeedstudio.com/depot/Seeed-Micro-BLE-Module-w-CortexM0-Based-nRF51822-SoC-p-1975.html
 [2]: http://www.seeedstudio.com/depot/
 [3]: http://www.nordicsemi.com/eng/Products/Bluetooth-R-low-energy/nRF51822
 [4]: http://www.seeedstudio.com/depot/images/product/BLE%20Micro_01.jpg
 [5]: http://www.seeedstudio.com/wiki/BLE_Micro
 [6]: https://github.com/Seeed-Studio/mbed_ble/tree/softdevice_v6
 [7]: http://developer.mbed.org/handbook/mbed-SDK
 [8]: http://developer.mbed.org/teams/Bluetooth-Low-Energy/
 [9]: https://launchpad.net/gcc-arm-embedded
 [10]: https://registry.hub.docker.com/u/skyplabs/ble-micro/
