---
layout: post
title: "[Fedora] Reconstruire la base de données des paquets RPM"
categories:
    - SysAdmin
tags:
    - RPM
---
    rm -rf /var/lib/rpm/__db*
    rpm --rebuilddb
