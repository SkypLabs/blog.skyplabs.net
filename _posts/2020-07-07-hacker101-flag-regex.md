---
layout: post
title: "Hacker 101 - Capture the Flags with a Regex"
categories:
    - Hacking and Security
    - Offensive Security
    - Web Security
tags:
    - CTF
    - ZAP
---
Enjoying [HackerOne's CTF][h1-ctf]?

If you want to make sure not to inadvertently miss any single flag while skimming through web pages, you can ask [ZAP][zap] to catch them for you with this regex: `\^FLAG\^[\w\d]{64}\$FLAG\$`


![ZAP settings to capture Hacker 101 flags automatically][hacker101-zap-flag-regex-settings]

A "Flag" tag will appear next the requests containing a flag in their response:

![HTTP request captured with ZAP containing a Hacker 101 flag][hacker101-zap-flag-regex-captured]

This technique is particularly useful when a flag appears in a non-obvious location such as an HTML comment.

 [hacker101-zap-flag-regex-settings]: /assets/images/hacker101_zap_flag_regex_settings.jpg
 [hacker101-zap-flag-regex-captured]: /assets/images/hacker101_zap_flag_regex_captured.jpg
 [h1-ctf]: https://ctf.hacker101.com
 [zap]: https://zaproxy.org
