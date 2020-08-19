---
layout: post
title: "[Python] Sniffing inside a thread with Scapy"
categories:
    - Development
tags:
    - Python
    - Scapy
    - Signal
    - Thread
---
Scapy is an incredible tool when it comes to playing with the network. As it is written on its [official website][scapy-website], Scapy can replace a majority of network tools such as nmap, hping and tcpdump.

One of the features offered by Scapy is to sniff the network packets passing through a computer's NIC. Below is a small example:

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

It will continue to sniff network packets until it receives a keyboard interruption (`CTRL+C`).

<!--more-->

Now, let's look at a new example:

{% gist SkypLabs/06bd7f414f51d700e04be705cb32659d sniff_thread_issue.py %}

This piece of code does exactly the same thing as the previous one except that this time the `sniff` function is executed inside a dedicated thread. Everything works well with this new version except when it comes to stopping the sniffer:

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

When `CTRL+C` is pressed, a `SIGTERM` signal is sent to the process executing the Python script, triggering its exit routine. However, as said in the [official documentation about signals][python3-signal], only the main thread receives signals:

> Python signal handlers are always executed in the main Python thread, even if the signal was received in another thread.

As a result, when `CTRL+C` is pressed, only the main thread raises a `KeyboardInterrupt` exception. The sniffing thread will continue its infinite sniffing loop, blocking at the same time the call of `sniffer.join()`.

So, how can the sniffing thread be stopped if not by signals? Let's have a look at this next example:

{% gist SkypLabs/06bd7f414f51d700e04be705cb32659d sniff_thread_issue_2.py %}

As you may have noticed, we are now using the `stop_filter` parameter in the `sniff` function call. This parameter expects to receive a function which will be called after each new packet to evaluate if the sniffer should continue its job or not. An `Event` object named `stop_sniffer` is used for that purpose. It is set to `true` when the `join` method is called to stop the thread.

Is this the end of the story? Not really...

    $ sudo python3 sniff_thread_issue_2.py
    [*] Start sniffing...
    ^C[*] Stop sniffing
    [!] New Packet: 10.137.2.30 -> 10.137.2.1

One side effect remains. Because the `should_stop_sniffer` method is called only once after each new packet, if it returns `false`, the sniffer will continue its job, going back to its infinite sniffing loop. This is why the sniffer stopped one packet ahead of the keyboard interruption.

A solution would be to force the sniffing thread to stop. As explained in the [official documentation about threading][python3-threading], it is possible to flag a thread as a daemon thread for that purpose:

> A thread can be flagged as a “daemon thread”. The significance of this flag is that the entire Python program exits when only daemon threads are left. The initial value is inherited from the creating thread. The flag can be set through the daemon property or the daemon constructor argument.

However, even if this solution would work, the thread won't release the resources it might hold:

> Daemon threads are abruptly stopped at shutdown. Their resources (such as open files, database transactions, etc.) may not be released properly. If you want your threads to stop gracefully, make them non-daemonic and use a suitable signalling mechanism such as an Event.

The `sniff` function uses a socket which is released just before exiting, after the sniffing loop:

    try:
        while sniff_sockets:
            // Sniffing loop
    except KeyboardInterrupt:
        pass
    if opened_socket is None:
        for s in sniff_sockets:
            s.close()
    return plist.PacketList(lst,"Sniffed")

Therefore, the solution I suggest is to open the socket outside the `sniff` function and to give it to this last one as parameter. Consequently, it would be possible to force-stop the sniffing thread while closing its socket properly:

{% gist SkypLabs/06bd7f414f51d700e04be705cb32659d sniff_thread_solution.py %}

Et voilà! The sniffing thread now waits for 2 seconds after having received a keyboard interrupt, letting the time to the `sniff` function to terminate its job by itself, after which the sniffing thread will be force-stopped and its socket properly closed from the main thread.

 [python3-signal]: https://docs.python.org/3/library/signal.html
 [python3-threading]: https://docs.python.org/3/library/threading.html
 [scapy-website]: https://scapy.net/
