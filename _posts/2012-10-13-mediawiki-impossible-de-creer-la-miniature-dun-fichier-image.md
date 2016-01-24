---
layout: post
title: "[MediaWiki] Impossible de créer la miniature d'un fichier image"
categories:
    - Logiciel
tags:
    - MediaWiki
---
Lorsque j'envoyais une image sur MediaWiki (installé sur ma FreeBSD), j'avais droit à une erreur de ce type :

> Erreur lors de la création de la miniature : Impossible d'enregistrer la vignette sur la destination

Pourtant, c'était pas faute d'avoir configuré le répertoire temporaire qui va bien (avec les bons droits d'accès) dans le fichier `LocalSettings.php` grâce à la directive `$wgTmpDirectory`. Seulement le problème venait du fait que MediaWiki utilise la fonction suivante pour déterminer l'emplacement du répertoire temporaire à utiliser :

{% highlight php linenos %}
/**
 * Tries to get the system directory for temporary files. The TMPDIR, TMP, and
 * TEMP environment variables are then checked in sequence, and if none are set
 * try sys_get_temp_dir() for PHP &gt;= 5.2.1. All else fails, return /tmp for Unix
 * or C:\Windows\Temp for Windows and hope for the best.
 * It is common to call it with tempnam().
 *
 * NOTE: When possible, use instead the tmpfile() function to create
 * temporary files to avoid race conditions on file creation, etc.
 *
 * @return String
 */
function wfTempDir() {
	foreach( array( 'TMPDIR', 'TMP', 'TEMP' ) as $var ) {
		$tmp = getenv( $var );
		if( $tmp && file_exists( $tmp ) && is_dir( $tmp ) && is_writable( $tmp ) ) {
			return $tmp;
		}
	}
	if( function_exists( 'sys_get_temp_dir' ) ) {
		return sys_get_temp_dir();
	}
	# Usual defaults
	return wfIsWindows() ? 'C:\Windows\Temp' : '/tmp';
}
{% endhighlight %}

Comme vous pouvez le voir, la directive `$wgTmpDirectory` n'est pas utilisée. Au lieu de cela, la fonction recherche le répertoire temporaire par défaut du système au moyen des variables d'environnement. La solution est donc très simple à mettre en œuvre (dans `LocalSettings.php`) :

{% highlight php %}
putenv("TMP={$wgUploadDirectory}/temp");
{% endhighlight %}

D'ailleurs si quelqu'un à une explication logique à cela, je suis très curieux de l'entendre !
