---
title: Connecting to UofT WiFi with iwd
description: WPA enterprise configuration with IWD can be a little confusing, but here's what worked for me with UofT's WiFi network.
published: 2021-08-25
modified: 2022-06-04
tags: [UofT, WiFi, iwd]
---

<!-- cspell:ignore TLDR wlan iwctl utorid peap eduroam ssid -->

## The TLDR

```toml
# /var/lib/iwd/UofT.8021x
[Security]
EAP-Method=PEAP
EAP-Identity=anonymous
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=<utorid>
EAP-PEAP-Phase2-Password=<utorid_password>

[Settings]
AutoConnect=true
```

Create this file (you'll need root access), and replace `<utorid>` and `<utorid_password>` with your credentials, then connect by running `iwctl` and entering `station <wlan> connect UofT`, but with `<wlan>` replaced by the name of your adapter.

## The Explanation

UofT's WiFi network (the one with the SSID `UofT`, not the eduroam network) uses the EAP-PEAP variety of WPA enterprise authentication. When you try to connect to this network without any configuration using `iwctl`, you'll get a `Not configured` error, because WPA enterprise networks require special configuration.

The basic template for configuring a WPA enterprise EAP-PEAP network can be found [here](https://wiki.archlinux.org/title/Iwd#EAP-PEAP) on the ArchWiki. However, not all of these options are required in the case of UofT's network, and some _must_ be excluded for the configuration to work. Based on the university's instructions for connecting on Ubuntu (which can be found [here](https://uthrprod.service-now.com/sp?id=kb_article&sys_id=3dd84b411b4f90108d6e4118cc4bcb48)), the CA certificate can be excluded, as well as the server domain mask, and the remaining variables can be filled in with the values given in the university's instructions.
