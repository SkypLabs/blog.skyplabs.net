---
layout: page
title: "Contact"
permalink: /contact/
---
### Email

Here is my email address: [{{ site.data.author.email }}](mailto:{{ site.data.author.email }})

#### With PGP

If you have something confidential to share, please use [PGP][pgp]/[GPG][gpg] encryption to secure our communication.

My public key can be downloaded from my Keybase profile:

[![My PGP key fingerprint][my-pgp-key-badge]][my-pgp-key]

To facilitate the encryption process, you can use [this online tool][keybase-encrypt-tool]. You can also use it to verify my signatures.

#### Without PGP

If you want to email me securely but you don't know or don't want to use PGP, please follow these steps:

1. Choose or generate a strong password.
2. Encrypt the password with [this online tool][keybase-encrypt-tool]. Only me will be able to decrypt it.
3. Copy the encrypted password and send it to me at [{{ site.data.author.email }}](mailto:{{ site.data.author.email }}).
4. I will answer you with a password-encrypted email via the [Tutanota webmail][tutanota].

### Keybase

If you have a [Keybase][keybase] account, you can start chatting securely with me by going on [my profile][my-keybase-profile].

### Public conversations

You can also contact me publicly via my [Twitter account][my-twitter].

[gpg]: https://gnupg.org/
[keybase]: https://keybase.io/
[keybase-encrypt-tool]: https://keybase.io/encrypt#{{ site.data.author.keybase }}
[my-keybase-profile]: https://keybase.io/{{ site.data.author.keybase }}
[my-pgp-key]: https://keybase.io/{{ site.data.author.keybase }}/pgp_keys.asc
[my-pgp-key-badge]: https://img.shields.io/keybase/pgp/skyplabs.svg
[my-twitter]: https://twitter.com/{{ site.data.author.twitter | prepend: site.baseurl }}
[pgp]: https://en.wikipedia.org/wiki/Pretty_Good_Privacy
[tutanota]: https://www.tutanota.com/
