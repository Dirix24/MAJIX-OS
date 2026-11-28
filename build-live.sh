#!/usr/bin/env bash
set -euo pipefail

if (( EUID != 0 )); then
    printf 'Ejecuta este script como root en un entorno Debian de compilación.\n' >&2
    exit 1
fi

if [[ $(dpkg --print-architecture) != amd64 ]]; then
    printf 'La imagen 0.1 requiere un entorno de compilación AMD64.\n' >&2
    exit 1
fi

source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
output=$(realpath -m -- "${1:-dist}")
build=$(mktemp -d "${TMPDIR:-/tmp}/majix-live.XXXXXXXX")
cd "$build"
printf 'Directorio de compilación: %s\n' "$build"

lb config \
    --ignore-system-defaults \
    --distribution trixie \
    --architecture amd64 \
    --binary-image iso-hybrid \
    --bootloaders 'syslinux grub-efi' \
    --uefi-secure-boot disable \
    --debian-installer none \
    --archive-areas 'main non-free-firmware' \
    --image-name majix-os-0.1-alpha \
    --iso-volume MAJIX_OS_01_ALPHA \
    --iso-application 'MAJIX OS 0.1 Alpha' \
    --checksums sha256 \
    --chroot-squashfs-compression-type zstd \
    --bootappend-live 'boot=live components quiet splash hostname=majix username=majix locales=es_ES.UTF-8 keyboard-model=pc105 keyboard-layouts=es keyboard-variants=winkeys nox11autologin noeject zswap.enabled=0 quickusbmodules persistence persistence-media=removable-usb persistence-storage=filesystem persistence-encryption=none persistence-label=MAJIX_DATA'

mkdir -p config/package-lists config/includes.chroot/etc/skel/.config \
    config/includes.chroot/etc/sddm.conf.d config/includes.chroot/usr/lib \
    config/includes.chroot/usr/share/plymouth/themes/majix \
    config/includes.chroot/etc/initramfs-tools/hooks \
    config/includes.chroot/etc/cryptsetup-initramfs config/hooks/live
cat > config/package-lists/majix.list.chroot <<'PACKAGES'
kde-plasma-desktop
kinfocenter
kdialog
fastfetch
qdbus-qt6
libnotify-bin
ca-certificates
systemd-zram-generator
python3-pyqt6
python3-venv
git
build-essential
cmake
ninja-build
gdb
nodejs
ripgrep
kwin-wayland
sddm
xserver-xorg
xwayland
konsole
kate
firefox-esr
network-manager
plasma-nm
pipewire-audio
plymouth-themes
cryptsetup-initramfs
plasma-pa
locales
sudo
PACKAGES

mkdir -p config/includes.chroot/etc/systemd/journald.conf.d
cat > config/includes.chroot/etc/systemd/zram-generator.conf <<'ZRAM'
[zram0]
zram-size = min(ram / 2, 4096)
swap-priority = 100
ZRAM
cat > config/includes.chroot/etc/systemd/journald.conf.d/50-majix-limits.conf <<'JOURNAL'
[Journal]
SystemMaxUse=64M
RuntimeMaxUse=32M
JOURNAL

cat > config/includes.chroot/etc/skel/.config/kdeglobals <<'KDE'
[General]
ColorScheme=BreezeDark
AccentColor=85,235,231

[KDE]
LookAndFeelPackage=org.kde.breezedark.desktop
KDE

live=config/includes.chroot
printf '%s\n' "${MAJIX_BUILD_SHA:-$(git -C "$source_dir" rev-parse HEAD 2>/dev/null || true)}" > "$live/usr/lib/majix-build"
install -D -m 0644 "$source_dir/config/keyboard" "$live/etc/default/keyboard"
install -D -m 0644 "$source_dir/config/keyboard-plasma" "$live/etc/skel/.config/kxkbrc"
cat > "$live/etc/skel/.config/baloofilerc" <<'KDE'
[Basic Settings]
Indexing-Enabled=false
KDE
cat > "$live/etc/skel/.config/ksplashrc" <<'KDE'
[KSplash]
Engine=none
Theme=None
KDE
cat > "$live/etc/skel/.config/kwinrc" <<'KDE'
[Plugins]
blurEnabled=false
KDE
sed -i '/^\[KDE\]$/a AnimationDurationFactor=0.45' "$live/etc/skel/.config/kdeglobals"

cat > config/includes.chroot/etc/sddm.conf.d/50-majix-live.conf <<'SDDM'
[Autologin]
User=majix
Session=plasma.desktop
SDDM

# Install alongside Debian's release metadata to keep package detection intact.
cat > config/includes.chroot/usr/lib/majix-release <<'RELEASE'
NAME="MAJIX OS"
PRETTY_NAME="MAJIX OS 0.1 Alpha 3"
ID=majix
ID_LIKE=debian
VERSION_ID="0.1"
VERSION="0.1 Alpha Developer"
VERSION_CODENAME=trixie
HOME_URL="https://github.com/Dirix24/MAJIX-OS"
VARIANT="Developer"
VARIANT_ID=developer
LOGO=majix-os
DEBIAN_CODENAME=trixie
RELEASE

install -m 0644 "$source_dir/branding/plymouth/"{majix.plymouth,watermark.png} \
    config/includes.chroot/usr/share/plymouth/themes/majix/

python3 "$source_dir/branding/plymouth/animate-majix.py" config/includes.chroot/usr/share/plymouth/themes/majix

cat > config/includes.chroot/etc/initramfs-tools/hooks/majix-logo <<'INITRAMFS'
#!/bin/sh
set -eu

if [ "${1:-}" = prereqs ]; then
    printf '%s\n' plymouth
    exit 0
fi

# Debian's Plymouth hook substitutes its own watermark for two-step themes.
theme=/usr/share/plymouth/themes/majix
if [ -d "${DESTDIR}${theme}" ]; then
    cp -- "${theme}/watermark.png" "${DESTDIR}${theme}/watermark.png"
fi
INITRAMFS
chmod +x config/includes.chroot/etc/initramfs-tools/hooks/majix-logo

cat > config/hooks/live/9000-majix-plymouth.hook.chroot <<'PLYMOUTH'
#!/bin/sh
set -eu

themes=/usr/share/plymouth/themes
for image in "$themes/spinner/"*.png; do
    case "${image##*/}" in watermark.png|throbber-*) continue ;; esac
    cp -- "$image" "$themes/majix/"
done

# Load the virtual display drivers early enough for the graphical splash in QEMU.
printf '\nvirtio_gpu\nbochs\nusb_storage\nuas\n' >> /etc/initramfs-tools/modules
rm -f /etc/os-release
ln -s ../usr/lib/majix-release /etc/os-release
plymouth-set-default-theme majix
update-initramfs -u -k all
PLYMOUTH
chmod +x config/hooks/live/9000-majix-plymouth.hook.chroot

install -m 0755 "$source_dir/config/persistence-menu.hook.binary" \
    config/hooks/live/9010-majix-persistence.hook.binary
printf '%s\n' 'CRYPTSETUP=y' > config/includes.chroot/etc/cryptsetup-initramfs/conf-hook
mkdir -p "$live/etc/live"
printf '%s\n' 'LIVE_MEDIUM_EJECT_VERBOSE=false' > "$live/etc/live/tools.conf"

# Install the same package used by the update channel so dpkg tracks ownership.
live=config/includes.chroot
install -D -m 0644 "$source_dir/developer/kcm-about-distrorc" "$live/etc/xdg/kcm-about-distrorc"
mkdir -p "$live/usr/share/majix/build"
"$source_dir/packaging/build-components.sh" "$live/usr/share/majix/build" "${MAJIX_COMPONENT_VERSION:-0.1.0~alpha3}"
cat > config/hooks/live/8990-majix-components.hook.chroot <<'COMPONENTS'
#!/bin/sh
set -eu
dpkg --install /usr/share/majix/build/majix-desktop_*.deb
rm -- /usr/share/majix/build/majix-desktop_*.deb
COMPONENTS
chmod +x config/hooks/live/8990-majix-components.hook.chroot

lb build
image=majix-os-0.1-alpha-amd64.hybrid.iso
test -s "$image"
mkdir -p -- "$output"
install -m 0644 -- "$image" "$output/majix-os-0.1-alpha-amd64.iso"
(
    cd "$output"
    sha256sum majix-os-0.1-alpha-amd64.iso > SHA256SUMS
)
lb clean --purge
cd /
rmdir --ignore-fail-on-non-empty "$build"
