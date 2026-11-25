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

output=$(realpath -m -- "${1:-dist}")
build=$(mktemp -d "${TMPDIR:-/tmp}/majix-live.XXXXXXXX")
cd "$build"
printf 'Directorio de compilación: %s\n' "$build"

lb config \
    --ignore-system-defaults \
    --distribution trixie \
    --architectures amd64 \
    --binary-images iso-hybrid \
    --bootloaders 'syslinux grub-efi' \
    --uefi-secure-boot disable \
    --debian-installer none \
    --archive-areas 'main non-free-firmware' \
    --image-name majix-os-0.1-alpha \
    --iso-volume MAJIX_OS_01_ALPHA \
    --iso-application 'MAJIX OS 0.1 Alpha' \
    --checksums sha256 \
    --chroot-squashfs-compression-type zstd \
    --bootappend-live 'boot=live components hostname=majix username=majix locales=es_ES.UTF-8'

mkdir -p config/package-lists config/includes.chroot/etc/skel/.config \
    config/includes.chroot/usr/lib
cat > config/package-lists/majix.list.chroot <<'PACKAGES'
kde-plasma-desktop
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
plasma-pa
locales
sudo
PACKAGES

cat > config/includes.chroot/etc/skel/.config/kdeglobals <<'KDE'
[General]
ColorScheme=BreezeDark

[KDE]
LookAndFeelPackage=org.kde.breezedark.desktop
KDE

# Install alongside Debian's release metadata to keep package detection intact.
cat > config/includes.chroot/usr/lib/majix-release <<'RELEASE'
NAME="MAJIX OS"
PRETTY_NAME="MAJIX OS 0.1 Alpha"
ID=majix
ID_LIKE=debian
VERSION_ID="0.1"
VERSION="0.1 Alpha"
VERSION_CODENAME=alpha
DEBIAN_CODENAME=trixie
RELEASE

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
