+++
title = "FydeOS kết hợp Arch Linux"
date = 2025-01-15
description = "Hướng dẫn cài đặt FydeOS kèm Arch Linux container, bao gồm lưu ý về flash USB và cấu hình multi-boot."
[taxonomies]
tags = ["linux", "fydeos", "arch-linux", "chromeos"]
[extra]
toc = true
+++

Hướng dẫn cài đặt **FydeOS** kèm **Arch Linux** container, bao gồm lưu ý về flash USB và cấu hình multi-boot.

<!-- more -->

## Download & Flash

Tải đúng phiên bản FydeOS theo hướng dẫn chính thức. Đây là phiên bản Linux kernel của từng variant:

- **Intel Legacy**: Linux 5.4.x
- **Intel Slim**: chưa test
- **Intel Modern**: Linux 6.6.x

Sau khi tải FydeOS, bạn **phải dùng Rufus hoặc balenaEtcher** để flash file `.bin.zip` vào USB. Đừng dùng Ventoy, vì nó sẽ gây lỗi GRUB khi cài đặt FydeOS multi-boot (cụ thể là tên partition trước và sau khi cắm ổ Ventoy).

## Cài đặt

Làm theo hướng dẫn trên màn hình hoặc dùng thử trước khi cài. Lưu ý cho người dùng multi-boot: nếu bạn không muốn gặp lỗi và chọn FydeOS làm OS chính, **đừng chọn rEFInd**, hãy chọn option thứ hai.

## Sau cài đặt: Arch Linux

Đảm bảo đã bật developer option, restart, và thiết lập Linux environment đầu tiên (termina:penguin).

Sau đó, đọc hướng dẫn: [https://fydeos.io/help/knowledge-base/linux-subsystem/setup/add-arch-linux-container/](https://fydeos.io/help/knowledge-base/linux-subsystem/setup/add-arch-linux-container/)

Một số chỉnh sửa:

- Lệnh `lxc launch images:archlinux/current archlinux` **không hoạt động**. Thay `images` bằng `canonical-images`:

```bash
lxc remote add canonical-images https://images.lxd.canonical.com --protocol simplestreams
lxc image list canonical-images:archlinux
# Chọn image phù hợp, ví dụ:
lxc launch canonical-images:archlinux archlinux
```

- **Neofetch** không còn trong Arch Linux repo (unmaintained). Thay bằng `fastfetch` ở bước **Configuring the Container**.
