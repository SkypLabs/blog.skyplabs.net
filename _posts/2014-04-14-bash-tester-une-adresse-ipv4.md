---
layout: post
title: "[Bash] Tester une adresse IPv4"
categories:
    - Développement
tags:
    - Bash
---
La fonction ci-dessous permet de tester une adresse IPv4 pour vérifier qu'elle est bien formée :

{% highlight php linenos %}
function is_ipv4
{
	echo $1 | grep -Eq '\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b'

	return $?
}
{% endhighlight %}

Et voici un exemple d'utilisation :

{% highlight php linenos %}
is_ipv4 $ip

if [ "$?" -ne 0 ]
then
	echo "[x] $ip is not an IPv4"
	exit 1
fi
{% endhighlight %}
