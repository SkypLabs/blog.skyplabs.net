# [Fedora] Reconstruire la base de données des paquets RPM

    rm -rf /var/lib/rpm/__db*
    rpm --rebuilddb
