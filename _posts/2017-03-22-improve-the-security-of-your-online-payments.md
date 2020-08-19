---
layout: post
title: "Improve the security of your online payments"
categories:
    - Hacking and Security
tags:
    - Payment
    - Credit Card
---
I think it is obvious to say that the security of your online payments is critical if you don't want to have an unpleasant surprise one day when checking your account statement. That's why most banks have added a two-step authentification security process to their online payment system. That way, you have to confirm your online payment with a one-time password sent via text message or other method by your bank. However, not every website supports this feature, leaving you defenceless if someone steals your credit card information.

<!--more-->

One way to steal your credit card information is simply to steal your credit card itself. Indeed, all the information needed to make an online payment are present on it: the credit card number, the card holder name, the expiration date and the CSC ([Card Security Code][CSC]). That's why it would be more secure to keep one of these pieces of information secret, like the pin code required to make a payment in a store. The CSC is a good candidate for that. It's a short pin code that you can easily remember by heart and/or store in a safe place (your [KeePass][keepass] file for example).

In order to keep your CSC secret, the best way is to remove it from the credit card, by scratching it out with scissors, for example. I'll let you appreciate the result on my own credit card:

![Example of a CSC which has been scratched out][credit card CSC]

This way, even if someone steals my credit card, I can ask my bank to block it, knowing that it can't be used online on most websites in the meantime. In fact, keep in mind that this solution is not perfect since the CSC is not always required to make a payment. It is the case of online stores proposing a one-click buying feature such as Amazon ([storing the CSC is prohibited by card issuers][CSC storage]).

 [credit card CSC]: /assets/images/credit_card_csc.png
 [CSC]: https://en.wikipedia.org/wiki/Card_security_code
 [CSC storage]: https://en.wikipedia.org/wiki/Card_security_code#Security_benefits
 [keepass]: https://keepass.info/
