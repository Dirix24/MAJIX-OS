#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
fixture=$(mktemp -d)
trap 'rm -rf -- "$fixture"' EXIT
cat > "$fixture/findmnt" <<'MOCK'
#!/bin/sh
case "$1:$2" in
    --target:/)
        case "$MODE" in
        union|union-readonly|union-missing)
            echo 'rw,relatime rw,lowerdir=/run/live/rootfs/filesystem.squashfs,upperdir=/run/live/persistence/sdb2/rw,workdir=/run/live/persistence/sdb2/work'
            ;;
        unrelated-root) echo 'rw,relatime rw,upperdir=/other/rw' ;;
        root-readonly) echo 'ro,relatime rw,upperdir=/run/live/overlay/rw' ;;
        *) echo 'rw,relatime rw,upperdir=/run/live/overlay/rw' ;;
        esac
        ;;
    --mountpoint:/run/live/persistence/sdb2)
        case "$MODE" in
            union) echo '8:18 ext4 rw,relatime' ;;
            union-readonly) echo '8:18 ext4 ro,relatime' ;;
            *) exit 1 ;;
        esac
        ;;
    --mountpoint:/run/live/overlay)
        case "$MODE" in
            full|root-readonly|unrelated-root) echo '8:18 ext4 rw,noatime' ;;
            readonly) echo '8:18 ext4 ro' ;;
            outside) exit 1 ;;
            *) echo '0:38 tmpfs rw,noatime' ;;
        esac
        ;;
    --mountpoint:/home/majix)
        case "$MODE" in
            personal|unrelated) echo '253:0 ext4 rw,noatime' ;;
            *) exit 1 ;;
        esac
        ;;
    --list:--noheadings)
        if [ "$MODE" = personal ]; then
            echo '253:0 /run/live/persistence/sdb1'
        else
            echo '253:1 /run/live/persistence/sdb1'
        fi
        ;;
esac
MOCK
chmod +x "$fixture/findmnt"
export PATH="$fixture:$PATH"

MODE=union sh "$root/bin/majix-storage" | grep -F 'Persistencia completa activa'
MODE=full sh "$root/bin/majix-storage" | grep -F 'Persistencia completa activa'
MODE=personal sh "$root/bin/majix-storage" | grep -F 'Persistencia personal activa'
MODE=temporary sh "$root/bin/majix-storage" | grep -F 'Sesión temporal'
MODE=union sh "$root/bin/majix-storage" --require-full
for example in personal temporary; do
    if MODE="$example" sh "$root/bin/majix-storage" --require-full; then
        exit 1
    fi
done
for example in unrelated readonly outside union-readonly union-missing root-readonly unrelated-root; do
    if MODE="$example" sh "$root/bin/majix-storage"; then
        printf 'Se confirmó erróneamente el modo %s\n' "$example" >&2
        exit 1
    fi
done
