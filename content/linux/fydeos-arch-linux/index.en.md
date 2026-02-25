+++
title = "FydeOS with Arch Linux"
date = 2025-01-15
description = "Guide to installing FydeOS with an Arch Linux container, including USB flash tips and multi-boot configuration."
[taxonomies]
tags = ["linux", "fydeos", "arch-linux", "chromeos"]
[extra]
toc = true
+++

A guide to installing **FydeOS** with an **Arch Linux** container, including USB flash tips and multi-boot configuration.

<!-- more -->

## Download & Flash

Follow the official FydeOS instructions to download the correct variant. Here's the Linux kernel version for each:

- **Intel Legacy**: Linux 5.4.x
- **Intel Slim**: didn't test
- **Intel Modern**: Linux 6.6.x

After downloading FydeOS, you **must use Rufus or balenaEtcher** to flash the `.bin.zip` onto a USB stick. Don't use Ventoy — it will break GRUB when installing FydeOS multi-boot (specifically, partition names change before and after plugging in your Ventoy drive).

## Install

Follow the on-screen instructions, or just try before installing. For multi-boot users: if you don't want errors and you choose FydeOS as the main OS, **don't choose rEFInd** — choose the second option.

## Post-install: Arch Linux

Ensure you've enabled developer options, restart, and set up your first Linux environment (termina:penguin).

Then read this guide: [https://fydeos.io/help/knowledge-base/linux-subsystem/setup/add-arch-linux-container/](https://fydeos.io/help/knowledge-base/linux-subsystem/setup/add-arch-linux-container/)

Some modifications:

- The command `lxc launch images:archlinux/current archlinux` **doesn't work**. Replace `images` with `canonical-images`:

```bash
lxc remote add canonical-images https://images.lxd.canonical.com --protocol simplestreams
lxc image list canonical-images:archlinux
# Choose the appropriate image, e.g.:
lxc launch canonical-images:archlinux archlinux
```

- **Neofetch** is no longer in the Arch Linux repo (unmaintained). Replace it with `fastfetch` at the **Configuring the Container** step.
