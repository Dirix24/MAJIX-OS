#!/bin/sh
set -eu

source_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
fixture=$(mktemp -d)
export GNUPGHOME="$fixture/gnupg"
trap 'gpgconf --kill gpg-agent; rm -rf -- "$fixture"' EXIT
mkdir -m 0700 "$GNUPGHOME"
gpg --batch --passphrase '' --quick-generate-key 'MAJIX CI test' ed25519 sign 1d
key=$(gpg --batch --with-colons --list-secret-keys | awk -F: '$1 == "fpr" {print $10; exit}')
gpg --batch --export "$key" > "$fixture/keyring.gpg"

archive="$fixture/archive"
"$source_dir/packaging/build-components.sh" "$archive/pool/main" 0.1.0~alpha2
"$source_dir/packaging/sign-archive.sh" "$archive" developer "$key"
gpgv --keyring "$fixture/keyring.gpg" "$archive/dists/developer/InRelease"
mkdir -p "$fixture/empty-config" "$fixture/lists/partial" "$fixture/cache/archives/partial" "$fixture/download"
touch "$fixture/status"
printf 'Dir::Etc::Parts "-";
Dir::Etc::Main "-";
' > "$fixture/apt.conf"
printf 'deb [arch=amd64 signed-by=%s] file:%s developer main\n' "$fixture/keyring.gpg" "$archive" > "$fixture/majix.list"

apt_local() {
    APT_CONFIG="$fixture/apt.conf" apt-get -o APT::Architecture=amd64 -o APT::Sandbox::User="$(id -un)" \
        -o Dir::Etc::sourcelist="$fixture/majix.list" -o Dir::Etc::sourceparts=- \
        -o Dir::State::status="$fixture/status" -o Dir::State::lists="$fixture/lists" \
        -o Dir::Cache="$fixture/cache" -o Debug::NoLocking=true -o APT::Update::Error-Mode=any "$@"
}
apt_local update
cd "$fixture/download"
apt_local download majix-desktop=0.1.0~alpha2
cmp ./*.deb "$archive"/pool/main/*.deb
dpkg-deb -x ./*.deb extracted
test -x extracted/usr/bin/majix-storage
test -x extracted/usr/bin/majix-update
test -x extracted/usr/bin/majix-control
test -x extracted/usr/bin/majix-studio
grep -Fx 'Exec=majix-session' extracted/etc/xdg/autostart/majix-session.desktop

rm -- ./*.deb
printf 'alterado\n' > "$archive/pool/main/majix-desktop_0.1.0~alpha2_all.deb"
if apt_local download majix-desktop=0.1.0~alpha2; then
    printf '%s\n' 'APT aceptó un paquete manipulado' >&2
    exit 1
fi

sed -i 's/Origin: MAJIX/Origin: Alterado/' "$archive/dists/developer/InRelease"
if gpgv --keyring "$fixture/keyring.gpg" "$archive/dists/developer/InRelease"; then
    printf '%s\n' 'GPG aceptó metadatos manipulados' >&2
    exit 1
fi
