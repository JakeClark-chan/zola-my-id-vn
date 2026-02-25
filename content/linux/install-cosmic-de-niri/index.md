+++
title = "Cài đặt COSMIC DE + Niri trên Ubuntu 24.04"
date = 2025-02-25
description = "Hướng dẫn chi tiết cài đặt COSMIC Desktop Environment kết hợp Niri compositor trên Ubuntu 24.04 LTS, bao gồm cả workaround cho screen recording và screencasting."
[taxonomies]
tags = ["linux", "cosmic", "niri", "wayland", "ubuntu"]
[extra]
toc = true
+++

Hướng dẫn chi tiết cài đặt **COSMIC Desktop Environment** kết hợp với **Niri** compositor trên Ubuntu 24.04 LTS. Bài viết bao gồm cả cách nâng cấp tự động bằng Topgrade và các workaround cho screen recording/screencasting.

<!-- more -->

## Yêu cầu

- **COSMIC DE** (có sẵn trong Pop!_OS 24.04 LTS hoặc các distro bleeding-edge; hướng dẫn này chạy trong Ubuntu 24.04 LTS, phần lớn component phải build từ source)
- **Rust environment**: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- **Just**: `sudo apt install just`

---

## Các bước cài đặt

### Bước 1: Cấu hình cargo-update cho việc cập nhật sau này

```bash
cargo install cargo-update
```

Để cập nhật sau này, chạy: `cargo install-update --all --git --locked`

### Bước 2: Cài đặt dependencies

Cài wlsunset để cấu hình chế độ ban đêm, và brightnessctl cho phím tắt độ sáng:

```bash
sudo apt install gcc clang libudev-dev libgbm-dev libxkbcommon-dev \
  libegl1-mesa-dev libwayland-dev libinput-dev libdbus-1-dev \
  libsystemd-dev libseat-dev libpipewire-0.3-dev libpango1.0-dev \
  libdisplay-info-dev brightnessctl wlsunset
sudo usermod -aG video $USER

# Cho fcitx5 (bộ gõ tiếng Việt)
sudo apt install fcitx5 fcitx5-bamboo fcitx5-config-qt
```

> ⚠️ Hãy đăng xuất sau bước này để áp dụng thay đổi group.

### Bước 3: Cài đặt Niri

Clone Niri và thiết lập script cập nhật:

```bash
git clone https://github.com/YaLTeR/niri.git
cd niri
```

Tạo `Justfile` để dễ cập nhật:

```just
# Lệnh mặc định
default: update-install

# Recipe chính để Topgrade gọi
update-install:
    @echo "🚀 Đang cập nhật Niri từ Git..."
    git pull

    @echo "⚙️  Đang build bản Release (Cái này hơi lâu nha)..."
    cargo build --release --locked

    @echo "📦 Đang cài đặt vào hệ thống (Cần sudo)..."
    # 1. Copy file chạy chính (Binaries)
    sudo install -m 755 target/release/niri /usr/local/bin/niri
    sudo install -m 755 resources/niri-session /usr/local/bin/niri-session

    # 2. Copy Desktop Entry (Để hiện ở màn hình đăng nhập)
    sudo mkdir -p /usr/local/share/wayland-sessions/
    sudo install -m 644 resources/niri.desktop /usr/local/share/wayland-sessions/

    # 3. Copy Portal Config (Fix lỗi quay màn hình/OBS)
    sudo mkdir -p /usr/local/share/xdg-desktop-portal/
    sudo install -m 644 resources/niri-portals.conf /usr/local/share/xdg-desktop-portal/

    # 4. Copy Systemd Service (Quản lý tiến trình)
    sudo install -m 644 resources/niri.service /etc/systemd/user/
    sudo install -m 644 resources/niri-shutdown.target /etc/systemd/user/

    # 5. Reload lại systemd để nhận service mới
    systemctl --user daemon-reload

    @echo "✅ Đã xong! Logout và Login lại để áp dụng bản mới."
```

Build & Install:

```bash
just update-install
# Bạn sẽ cần quyền root để cài binary mới
```

### Bước 4: Cài đặt xwayland-satellite

Thêm hỗ trợ X11 cho các ứng dụng legacy:

```bash
cargo install --locked --git https://github.com/Supreeeme/xwayland-satellite.git
```

### Bước 5: Cài đặt COSMIC Extension Extra Sessions

Kết nối COSMIC với Niri như một compositor:

```bash
git clone https://github.com/Drakulix/cosmic-ext-extra-sessions.git
cd cosmic-ext-extra-sessions
just build
sudo just install-niri
```

### Bước 6: Cấu hình Niri

Copy cài đặt vào `~/.config/niri/config.kdl`. Cấu hình của mình khá đầy đủ cho hệ thống; bạn có thể tuỳ chỉnh theo nhu cầu.

Cấu hình bên dưới đảm bảo fcitx5 chạy tốt. Nếu bạn không dùng fcitx5, có thể bỏ block `environments` và lệnh spawn fcitx5.

**Dependency**: `fcitx5`

<details>
<summary>Xem toàn bộ config.kdl (nhấn để mở)</summary>

```kdl
input {
    keyboard {
        xkb { }
    }
    touchpad {
        tap
        natural-scroll
    }
    mouse {
        accel-speed -0.55
        accel-profile "flat"
    }
}

output "eDP-1" {
    mode "1920x1080@144"
    scale 1.25
    transform "normal"
    position x=0 y=0
    variable-refresh-rate on-demand=true
}

layout {
    gaps 8
    center-focused-column "never"
    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
        proportion 1.0
    }
    default-column-width { proportion 0.5; }

    focus-ring {
        width 4
        active-color "#E08FAC"
        inactive-color "#252538"
    }
    border {
        off
        width 4
        active-color "#E08FAC"
        inactive-color "#36364F"
        urgent-color "#9b0000"
    }
}

environment {
    MOZ_ENABLE_WAYLAND "1"
    GDK_BACKEND "wayland,x11"
    QT_QPA_PLATFORM "wayland;xcb"
    SDL_VIDEODRIVER "wayland"
    CLUTTER_BACKEND "wayland"
    XDG_CURRENT_DESKTOP "Niri"
    XDG_SESSION_TYPE "wayland"
    XDG_SESSION_DESKTOP "Niri"
    GTK_IM_MODULE "wayland"
    QT_IM_MODULE "wayland"
    XMODIFIERS "@im=fcitx"
    SDL_IM_MODULE "wayland"
}

spawn-at-startup "cosmic-ext-alternative-startup"
spawn-at-startup "fcitx5" "-d" "-r"
spawn-at-startup "wlsunset" "-t" "3600" "-l" "10.8" "-L" "106.6"
spawn-at-startup "xwayland-satellite"

hotkey-overlay {
    skip-at-startup
}

screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

window-rule {
    geometry-corner-radius 12
    clip-to-geometry true
}

cursor {
    hide-when-typing
    hide-after-inactive-ms 2000
    xcursor-size 24
}

binds {
    Mod+Shift+Slash { show-hotkey-overlay; }
    Mod+Return { spawn "cosmic-term"; }
    Mod+D { spawn "cosmic-launcher"; }
    Mod+E { spawn "cosmic-files" "~"; }
    Mod+A { spawn "cosmic-app-library"; }
    Mod+L { spawn "loginctl" "lock-session"; }
    Mod+Shift+Q { close-window; }
    Mod+W repeat=false { toggle-overview; }

    // Âm lượng
    XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01+ -l 1.5"; }
    XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01-"; }
    XF86AudioMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }

    // Độ sáng
    XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+5%"; }
    XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "5%-"; }

    // Di chuyển focus
    Mod+Left { focus-column-left; }
    Mod+Down { focus-window-down; }
    Mod+Up { focus-window-up; }
    Mod+Right { focus-column-right; }

    // Di chuyển cửa sổ
    Mod+Ctrl+Left { move-column-left; }
    Mod+Ctrl+Down { move-window-down; }
    Mod+Ctrl+Up { move-window-up; }
    Mod+Ctrl+Right { move-column-right; }

    // Workspace
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }

    Mod+R { switch-preset-column-width; }
    Mod+M { maximize-column; }
    Mod+F { fullscreen-window; }
    Mod+C { center-column; }

    Print { screenshot; }
    Ctrl+Print { screenshot-screen; }

    Mod+Shift+E { quit; }
}
```

</details>

### Bước 7: Đăng xuất, chọn session "COSMIC on Niri", rồi đăng nhập

### Bước 8: Bonus — Cài COSMIC Clipboard Manager từ source

```bash
git clone https://github.com/cosmic-utils/clipboard-manager.git
cd clipboard-manager
just build-release && sudo just install
# Kiểm tra panel mới ngay
pkill cosmic-panel
```

---

## Nâng cấp tự động bằng Topgrade

### Bước 1: Tạo cấu hình Topgrade

Tạo `~/.config/topgrade.toml` và điều chỉnh đường dẫn repository theo thiết lập của bạn:

```toml
[misc]
disable = ["system", "emacs", "vim", "sheldon", "tmux", "fossil"]

[commands]
"Niri Upgrade" = "cd <path-to-niri>/niri && just update-install"
"COSMIC Clipboard Manager Update" = "cd <path-to-niri>/clipboard-manager && git pull && just build-release && sudo just install && pkill cosmic-panel"
"COSMIC Extension Extra Session Update" = "cd <path-to-niri>/cosmic-ext-extra-sessions && git pull && just build && sudo just install-niri"
```

### Bước 2: Chạy Topgrade

Một lệnh để cập nhật tất cả:

```bash
topgrade
```

---

## Điểm mạnh

- Kế thừa tất cả tính năng cốt lõi của COSMIC, bao gồm panel và extensions
- Sử dụng Niri mà không cần cài shell riêng

## Hạn chế

- cosmic-app-list và workspace indicator bị thiếu do cách Niri quản lý workspace
- Tuỳ chỉnh shell khó vì Ubuntu 24.04 yêu cầu rebuild components (Quickshell, Dank Material Shell, Noctalia, v.v.)
- Minimize hoạt động trên COSMIC nhưng chưa hỗ trợ trong Niri
- COSMIC Settings không hoạt động từ session Niri do lỗi và cách cấu hình khác nhau
- Không thể dùng portal cho screencasting (COSMIC và GNOME yêu cầu session cụ thể)

---

## Workaround

### Quay màn hình

1. Cài wl-screenrec (qua cargo hoặc phương thức khác)
2. Quay bằng Intel GPU acceleration:

```bash
LIBVA_DRIVER_NAME=iHD wl-screenrec -f ~/Videos/record.mp4
```

**Tuỳ chọn:**
- Dùng desktop audio (mặc định): thêm flag `-audio`
- Dùng nhiều nguồn audio (không khuyến nghị):

```bash
# Tạo source mới
pactl load-module module-null-sink sink_name=v_mix sink_properties=device.description="All_Audio_Mix"
# Dùng helvum để kết nối source với destination
# Quay
wl-screenrec --audio-device "v_mix.monitor" -f full_audio.mp4
```

### Screen Casting (Virtual Camera)

```bash
# Cài dependencies
sudo apt install v4l2loopback-dkms wf-recorder
sudo modprobe v4l2loopback exclusive_caps=1 card_label="Niri Screen Stream"

# Kiểm tra thiết bị video mới (ví dụ: /dev/video2)
ls /dev/video*

# Bật screencast qua virtual camera
wf-recorder --muxer=v4l2 --codec=rawvideo --file=/dev/video2 -x yuv420p

# Hoặc dùng slurp để chọn vùng cụ thể
wf-recorder -g "$(slurp)" --muxer=v4l2 --codec=rawvideo --file=/dev/video2 -x yuv420p
```

**Alias nhanh:**

```bash
alias stream-on='sudo modprobe v4l2loopback exclusive_caps=1 card_label="Niri Stream" && wf-recorder --muxer=v4l2 --codec=rawvideo --file=/dev/video2 -x yuv420p'
```

---

## Ảnh chụp màn hình

![COSMIC DE trên Niri - Desktop](image.png)

![COSMIC DE trên Niri - Overview](image1.png)
