#!/bin/sh
set -eu

source_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
output=$(realpath -m -- "${1:?Indica el directorio de salida}")
version=${2:-0.1.0~alpha3}
dpkg --validate-version "$version"
build=$(mktemp -d)
trap 'rm -rf -- "$build"' EXIT
mkdir -p "$build/DEBIAN" "$output"

cat > "$build/DEBIAN/control" <<CONTROL
Package: majix-desktop
Version: $version
Architecture: all
Maintainer: MAJIX OS <Dirix24@users.noreply.github.com>
Depends: python3, python3-pyqt6, kdialog, qdbus-qt6, util-linux
Description: Aplicaciones y configuración base del escritorio MAJIX OS
 Incluye Studio, Control Center y el diagnóstico de persistencia.
CONTROL

dev="$source_dir/developer"
install -D -m 0755 "$source_dir/bin/majix-storage" "$build/usr/bin/majix-storage"
install -D -m 0755 "$source_dir/bin/majix-tools" "$build/usr/bin/majix-tools"
install -D -m 0755 "$source_dir/bin/majix-update" "$build/usr/bin/majix-update"
install -D -m 0755 "$source_dir/bin/majix-build-check" "$build/usr/bin/majix-build-check"
install -D -m 0755 "$source_dir/bin/majix-diagnostico" "$build/usr/bin/majix-diagnostico"
for program in majix-studio majix-session majix-control; do
    install -D -m 0755 "$dev/$program" "$build/usr/bin/$program"
done
for program in majix-studio majix-control; do
    install -D -m 0644 "$dev/$program.desktop" "$build/usr/share/applications/$program.desktop"
done
install -D -m 0644 "$dev/majix-session.desktop" "$build/etc/xdg/autostart/majix-session.desktop"
install -D -m 0644 "$dev/wallpaper.jpg" "$build/usr/share/majix/wallpaper.jpg"
install -D -m 0644 "$dev/majix-layout.js" "$build/usr/share/majix/layout.js"
install -D -m 0644 "$source_dir/branding/majix-fastfetch.txt" "$build/usr/share/majix/fastfetch-logo.txt"
install -D -m 0644 "$source_dir/config/fastfetch.jsonc" "$build/etc/xdg/fastfetch/config.jsonc"
emblem="$source_dir/branding/plymouth/watermark.png"
install -D -m 0644 "$emblem" "$build/usr/share/majix/emblem.png"
install -D -m 0644 "$emblem" "$build/usr/share/icons/hicolor/128x128/apps/majix-os.png"
install -D -m 0644 "$source_dir/LICENSE" "$build/usr/share/doc/majix-desktop/copyright"

dpkg-deb --root-owner-group --build "$build" "$output"
