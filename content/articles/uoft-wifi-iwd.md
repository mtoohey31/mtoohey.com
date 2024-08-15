---
title: Connecting to UofT WiFi with iwd
description: Instructions for how to connect to UofT's WPA enterprise WiFi network using IWD.
published: 2021-08-25
modified: 2024-08-15
tags: [UofT, WiFi, iwd]
---

<!-- cspell:ignore utoronto TLDR wlan iwctl utorid peap eduroam ssid MSCHAPV2 -->

## The TLDR

```ini
# /var/lib/iwd/UofT.8021x
[Security]
EAP-Method=PEAP
EAP-Identity=anonymous
EAP-PEAP-CACert=/var/lib/iwd/radius_wireless_utoronto_ca_cert_2024.cer
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=<utorid>
EAP-PEAP-Phase2-Password=<utorid_password>

[Settings]
AutoConnect=true
```

Create this file (you'll need root access), and replace `<utorid>` and `<utorid_password>` with your credentials. Download `radius_wireless_utoronto_ca_cert_2024.cer` from the "Certificates" dropdown under the "Additional resources" heading on the [Campus Wireless website](https://wireless.utoronto.ca/connect/), and place it at the path specified above for `EAP-PEAP-CACert`. (If you're reading this in the future, the year suffix might not be 2024 any more; if so, be sure to adjust the paths so the config file matches where you've saved the certificate.) Now you should be able to connect by running `iwctl` and entering `station <wlan> connect UofT`, but with `<wlan>` replaced by the name of your adapter.

## The Explanation

UofT's WiFi network (the one with the SSID `UofT`, not the eduroam network) uses the EAP-PEAP variety of WPA enterprise authentication. When you try to connect to this network without any configuration using `iwctl`, you'll get a `Not configured` error, because WPA enterprise networks require special configuration.

The basic template for configuring a WPA enterprise EAP-PEAP network can be found [here](https://wiki.archlinux.org/title/Iwd#EAP-PEAP) on the ArchWiki. However, not all of these options are required in the case of UofT's network, and some _must_ be excluded (according to my testing) for the configuration to work. According to the university's instructions for connecting on Ubuntu (which can be found [here](https://uthrprod.service-now.com/sp?id=kb_article&sys_id=3dd84b411b4f90108d6e4118cc4bcb48)), the server domain mask can be excluded, and the remaining variables can be filled in with the values given in the university's instructions.

Those same instructions also say that the CA certificate should be excluded, but I've recently learned that the iwd docs seem to indicate that this is insecure. I've confirmed that things still work if you specify the correct certificate, so I've updated the configuration above to include the certificate.
