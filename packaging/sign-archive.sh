#!/bin/sh
set -eu

archive=$(realpath -- "${1:?Indica el directorio del repositorio APT}")
channel=${2:?Indica el canal}
key=${3:?Indica la huella completa de la clave GPG}
case "$channel" in developer|beta|stable) ;; *) exit 2 ;; esac
case "$key" in *[!0-9A-Fa-f]*) exit 2 ;; esac
test "${#key}" -eq 40 || test "${#key}" -eq 64

cd "$archive"
set -- pool/main/majix-desktop_*_all.deb
test -f "$1"
for package do
    test "$(dpkg-deb -f "$package" Package)" = majix-desktop
    test "$(dpkg-deb -f "$package" Architecture)" = all
done

index="dists/$channel/main/binary-amd64"
mkdir -p "$index"
# Remove previous signatures before generating fresh metadata in the staging tree.
rm -f "dists/$channel/InRelease" "dists/$channel/Release"
apt-ftparchive packages pool/main > "$index/Packages"
gzip -n -c "$index/Packages" > "$index/Packages.gz"
release=$(mktemp)
trap 'rm -f -- "$release"' EXIT
apt-ftparchive \
    -o APT::FTPArchive::Release::Origin=MAJIX \
    -o APT::FTPArchive::Release::Label="MAJIX OS" \
    -o APT::FTPArchive::Release::Suite="$channel" \
    -o APT::FTPArchive::Release::Codename="$channel" \
    -o APT::FTPArchive::Release::Architectures="amd64" \
    -o APT::FTPArchive::Release::Components=main \
    release "dists/$channel" > "$release"
printf 'Valid-Until: %s\n' "$(date -Ru -d '+14 days')" >> "$release"
gpg --batch --local-user "$key" --digest-algo SHA256 --clearsign \
    --output "dists/$channel/InRelease" "$release"
mv -- "$release" "dists/$channel/Release"
