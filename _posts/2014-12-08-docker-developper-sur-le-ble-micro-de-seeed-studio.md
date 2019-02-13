---
layout: post
title: "[Docker] Développer sur le BLE Micro de Seeed Studio"
categories:
    - Développement
tags:
    - Docker
    - BLE Micro
---
Le [BLE Micro][ble_micro] est une petite carte électronique produite par [Seeed Studio][seeed_studio] embarquant le SoC [nRF51822][nRF51822] de Nordic Semiconductor. Ce dernier est un module de communication [Bluetooth Low Energy][ble] (BLE) basé un Cortex M0.

![BLE Micro de Seeed Studio](/images/ble_micro.jpg)

<!--more-->

Pour développer un programme à destination de ce circuit, le [wiki officiel du BLE Micro][ble_micro_wiki] nous renvoie sur [une page GitHub][ble_micro_github] contenant un SDK dédié. Ce dernier est basé sur le [mbed SDK][mbed_sdk] de ARM avec son [API pour le BLE][mbed_ble_micro]. La compilation du code nécessite la toolchain [gcc-arm-embedded][gcc_arm_embedded] avec certaines dépendances comme la newlib-nano.

Afin de ne pas perdre de temps à préparer l'environnement de développement adéquat, j'ai mis en ligne un conteneur Docker disponible sur le [Docker Hub][ble_micro_docker]. Après un échange d'e-mails avec la personne s'occupant du BLE Micro chez Seeed Studio, le lien vers mon conteneur a été ajouté sur le wiki officiel :

> If you are familiar with the Docker, there is a Docker container created by Paul for you to setup toolchain quickly. You can follow the instructions on the Docker page to get started.

N'hésitez pas à me faire part de votre avis concernant l'utilisation de ce produit ou de mon conteneur Docker.

[ble]: https://en.wikipedia.org/wiki/Bluetooth_low_energy
[ble_micro]: https://www.seeedstudio.com/Seeed-Micro-BLE-Module-w-Cortex-M0-Based-nRF51822-SoC-p-1975.html
[ble_micro_docker]: https://hub.docker.com/r/skyplabs/ble-micro/
[ble_micro_github]: https://github.com/Seeed-Studio/mbed_ble/tree/softdevice_v6
[ble_micro_wiki]: http://wiki.seeedstudio.com/BLE_Micro
[gcc_arm_embedded]: https://launchpad.net/gcc-arm-embedded
[mbed_ble_micro]: http://developer.mbed.org/teams/Bluetooth-Low-Energy/
[mbed_sdk]: http://developer.mbed.org/handbook/mbed-SDK
[nRF51822]: https://www.nordicsemi.com/Products/Low-power-short-range-wireless/nRF51822/GetStarted
[seeed_studio]: http://www.seeedstudio.com/depot/
