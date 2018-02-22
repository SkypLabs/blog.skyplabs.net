---
layout: post
title: "[Scapy] Sniffing inside a thread"
categories:
    - Development
tags:
    - Python
    - Scapy
    - Thread
---
Scapy is an incredible tool when it comes to play with network. As it is written on its [official website][scapy-website], Scapy can replace a majority of network tools such as nmap, hping and tcpdump.

One of the features offered by Scapy is to sniff the network packets passing through your computer's NICs. Below is a small example:

{% gist SkypLabs/06bd7f414f51d700e04be705cb32659d sniff_main_thread.py %}

This little sniffer displays the source and the destination of all packets having an IP layer:

    $ sudo python3 sniff_main_thread.py
    [*] Start sniffing...
    [!] New Packet: 10.137.2.30 -> 10.137.2.1
    [!] New Packet: 10.137.2.30 -> 10.137.2.1
    [!] New Packet: 10.137.2.1 -> 10.137.2.30
    [!] New Packet: 10.137.2.1 -> 10.137.2.30
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    [!] New Packet: 216.58.198.68 -> 10.137.2.30
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    [!] New Packet: 216.58.198.68 -> 10.137.2.30
    [!] New Packet: 216.58.198.68 -> 10.137.2.30
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    [!] New Packet: 216.58.198.68 -> 10.137.2.30
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    ^C[*] Stop sniffing

The sniffer will continue to sniff network packets until it receives a keyboard interruption (`CTRL+C`).

Now, let's look at a new example using a thread:

{% gist SkypLabs/06bd7f414f51d700e04be705cb32659d sniff_thread_issue.py %}

This piece of code does exactly the same thing as the previous one excepting the use of a thread. Everything works well except when it comes to stop the sniffer:

    $ sudo python3 sniff_thread_issue.py
    [*] Start sniffing...
    [!] New Packet: 10.137.2.30 -> 10.137.2.1
    [!] New Packet: 10.137.2.30 -> 10.137.2.1
    [!] New Packet: 10.137.2.1 -> 10.137.2.30
    [!] New Packet: 10.137.2.1 -> 10.137.2.30
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    [!] New Packet: 216.58.198.68 -> 10.137.2.30
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    [!] New Packet: 216.58.198.68 -> 10.137.2.30
    [!] New Packet: 216.58.198.68 -> 10.137.2.30
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    [!] New Packet: 216.58.198.68 -> 10.137.2.30
    [!] New Packet: 10.137.2.30 -> 216.58.198.68
    ^C[*] Stop sniffing
    ^CTraceback (most recent call last):
      File "sniff_thread_issue.py", line 25, in <module>
        sleep(100)
    KeyboardInterrupt

    During handling of the above exception, another exception occurred:

    Traceback (most recent call last):
      File "sniff_thread_issue.py", line 28, in <module>
        sniffer.join()
      File "/usr/lib/python3.5/threading.py", line 1054, in join
        self._wait_for_tstate_lock()
      File "/usr/lib/python3.5/threading.py", line 1070, in _wait_for_tstate_lock
        elif lock.acquire(block, timeout):
    KeyboardInterrupt
    ^CException ignored in: <module 'threading' from '/usr/lib/python3.5/threading.py'>
    Traceback (most recent call last):
      File "/usr/lib/python3.5/threading.py", line 1288, in _shutdown
        t.join()
      File "/usr/lib/python3.5/threading.py", line 1054, in join
        self._wait_for_tstate_lock()
      File "/usr/lib/python3.5/threading.py", line 1070, in _wait_for_tstate_lock
        elif lock.acquire(block, timeout):
    KeyboardInterrupt

> Python signal handlers are always executed in the main Python thread, even if the signal was received in another thread.

{% gist SkypLabs/06bd7f414f51d700e04be705cb32659d sniff_thread_issue_2.py %}

> A thread can be flagged as a “daemon thread”. The significance of this flag is that the entire Python program exits when only daemon threads are left. The initial value is inherited from the creating thread. The flag can be set through the daemon property or the daemon constructor argument.

> Daemon threads are abruptly stopped at shutdown. Their resources (such as open files, database transactions, etc.) may not be released properly. If you want your threads to stop gracefully, make them non-daemonic and use a suitable signalling mechanism such as an Event.

{% gist SkypLabs/06bd7f414f51d700e04be705cb32659d sniff_thread_solution.py %}

 [python3-signal]: https://docs.python.org/3/library/signal.html
 [python3-threading]: https://docs.python.org/3/library/threading.html
 [scapy-website]: http://secdev.org/projects/scapy/
