---
title: NixOS on the Zephyrus G14
description: A walkthrough of configuring NixOS for the Zephyrus G14.
posted: Apri 10, 2022
tags: [Asus Zephyrus G14, asusctl, supergfxctl, NixOS, Nix]
---

## Disclaimer

I've tested this on the 2021 model (the GA401), but not any other year. If you test it with a different model, let me know how it goes so I can update this message!

## Table of Contents

This article will cover the following configuration fixes:

- [Kernel Version and Patches](#kernel-version-and-patches)
- [Setting Prime Bus IDs](setting-prime-bus-ids)
- [Asusctl and Supergfxctl](asusctl-and-supergfxctl)
- [Suspend](#suspend)

## Kernel Version and Patches

The 5.17 kernel includes some modifications that previously required patches, so I'd reccommend using that version or newer. Some patches are still required though, and they can be applied with the `boot.kernelPatches` configuration option.

First, we have to fetch the patches:

```nix
let
  g14_patches = fetchGit {
    url = "https://gitlab.com/dragonn/linux-g14";
    ref = "5.17";
    rev = "ed8cf277690895c5b2aa19a0c89b397b5cd2073d";
  };
in
{ ... }
```

Then, we have to set the kernel package to the matching version, and apply them:

```nix
boot.kernelPackages = pkgs.linuxPackages_5_17;
boot.kernelPatches = map (patch: { inherit patch; }) [
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0004-5.15+--more-uarches-for-kernel.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0005-lru-multi-generational.patch"

  "${g14_patches}/sys-kernel_arch-sources-g14_files-0043-ALSA-hda-realtek-Fix-speakers-not-working-on-Asus-Fl.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0049-ALSA-hda-realtek-Add-quirk-for-ASUS-M16-GU603H.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0050-asus-flow-x13-support_sw_tablet_mode.patch"

  # mediatek mt7921 bt/wifi patches
  "${g14_patches}/sys-kernel_arch-sources-g14_files-8017-mt76-mt7921-enable-VO-tx-aggregation.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-8018-mt76-mt7921e-fix-possible-probe-failure-after-reboot.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-8026-cfg80211-dont-WARN-if-a-self-managed-device.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-8050-r8152-fix-spurious-wakeups-from-s0i3.patch"

  # squashed s0ix enablement through
  "${g14_patches}/sys-kernel_arch-sources-g14_files-9001-v5.16.11-s0ix-patch-2022-02-23.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-9004-HID-asus-Reduce-object-size-by-consolidating-calls.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-9005-acpi-battery-Always-read-fresh-battery-state-on-update.patch"

  "${g14_patches}/sys-kernel_arch-sources-g14_files-9006-amd-c3-entry.patch"

  "${g14_patches}/sys-kernel_arch-sources-g14_files-9010-ACPI-PM-s2idle-Don-t-report-missing-devices-as-faili.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-9011-cpufreq-CPPC-Fix-performance-frequency-conversion.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-9012-Improve-usability-for-amd-pstate.patch"
];
```

The call to map in that second snippet is necessary because values provided to the `boot.kernelPatches` option must be of the form `{ patch = ..., name ? "" = ... }`.

If you want to run a different version than 5.17, the following changes are necessary:

- Update the `ref` argument in the `fetchGit` call to match the name of the corresponding branch in the [patch repo](https://gitlab.com/dragonn/linux-g14). The `rev` argument will also need to be updated to the commit from that branch that you want to use.
- Update the `boot.kernelPackages` package to the right version of the kernel package.
- Update the list of patch paths in the `boot.kernelPatches` option to match the paths listed in the source attribute of the `PKGBUILD` file on the corresponding branch of the patch repo, the same branch you used above when updating the `ref` attribute.

## Setting Prime Bus IDs

In order for switching between the integrated AMD graphics and dedicated Nvidia GPU to work properly, we have to set the `hardware.nvidia.prime.*BusId` options. These configurations, along with a few other optimizations for laptops, are included in the `asus-zephyrus-ga401` profile from the [nixos-hardware repo](https://github.com/NixOS/nixos-hardware). Depending on whether you're using a flake or not the setup will be slightly different, but instructions are included in that repo's README, so refer to the instructions there for importing it. Or if you like, you can just copy the the `busId` configurations directly into your configuration, they're defined [here](https://github.com/NixOS/nixos-hardware/blob/master/asus/zephyrus/ga401/default.nix).

## Asusctl and Supergfxctl

There's currently a PR open [here](https://github.com/NixOS/nixpkgs/pull/147786) to add these to nixpkgs, but in the meantime we'll have to fetch the branch ourselves.

I set up the imports and overlays by following [@itsfarseen's comment here](https://github.com/NixOS/nixpkgs/pull/147786#issuecomment-1068804835). There may be a more elegant way to do this if you're using a flake like I am, but I haven't come up with anything yet...

Then we just need to enable the required services:

```nix
services.supergfxctl = {
  enable = true;
  gfx-mode = "Integrated";
  gfx-vfio-enable = true;
};
services.power-profiles-daemon.enable = true;
systemd.services.power-profiles-daemon = {
  enable = true;
  wantedBy = [ "multi-user.target" ];
};
services.asusctl.enable = true;
```

If you don't want to use `asusctl`'s profile subcommand, you can ommit everything related to power-profiles-daemon. Note that in the future, power-profiles-daemon may be enabled automatically (see [this comment](https://github.com/NixOS/nixpkgs/pull/147786#issuecomment-1092347132)).

## Suspend

In order for suspend to work properly with the Nvidia GPU, I found it necessary to set:

```nix
hardware.nvidia.powerManagement = {
  enable = true;
  finegrained = true;
};
```

This enables various systemd services that ensure the GPU plays nicely with suspend. Also, in order to stop the keyboard LEDs from flashing during sleep, I had to run `asusctl led-mode sleep-enable false`.

## Conclusion

These changes should get most of the G14's specialized hardware working on NixOS, though more configuration will still be necessary for the usual stuff like wifi and bluetooth. If you come across any other configuration that's specific to the G14, please let me know so I can add it. I'll do my best to keep this article updated, but if something seems out of date, [my configs on GitHub](https://github.com/mtoohey31/infra) might have something more recent.
