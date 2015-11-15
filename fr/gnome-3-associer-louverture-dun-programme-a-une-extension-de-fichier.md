# [GNOME 3] Associer l'ouverture d'un programme à une extension de fichier

Sous GNOME, l'association d'une extension de fichier à un programme référencé par un fichier de configuration dans **/usr/share/applications** se fait à travers le fichier **/usr/share/applications/defaults.list** de la manière suivante :

    application/x-<extension>=<app>;

Vous devez remplacer *extension* par le nom de l'extension concernée et *app* par le nom du fichier de configuration du programme qui doit être utilisé.

Par exemple dans mon cas, pour associer **xournal** comme programme permettant d'ouvrir les fichiers **xoj**, j'ai ajouté la ligne suivante dans le fichier **/usr/share/applications/defaults.list** :

    application/x-xoj=xournal.desktop;
