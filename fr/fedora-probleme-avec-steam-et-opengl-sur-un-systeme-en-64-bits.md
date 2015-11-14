Si Steam vous affiche un message d'erreur lors de son lancement au sujet d'OpenGL sous Fedora en 64 bits et que vous utilisez le driver propriétaire de Nvidia, il faut seulement installer la bibliothèque Nvidia 32 bits en utilisant la commande suivante :

    yum install xorg-x11-drv-nvidia-libs.i686
