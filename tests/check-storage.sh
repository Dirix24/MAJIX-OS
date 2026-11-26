#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
fixture=$(mktemp -d)
trap 'rm -rf -- "$fixture"' EXIT
cat > "$fixture/findmnt" <<'MOCK'
#!/bin/sh
case "$1:$2" in
    --mountpoint:/run/live/overlay)
        case "$MODE" in
            full) echo 'ext4 rw,noatime' ;;
            readonly) echo 'ext4 ro' ;;
            outside) exit 1 ;;
            *) echo 'tmpfs rw,noatime' ;;
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

MODE=full sh "$root/bin/majix-storage" | grep -F 'Persistencia completa activa'
MODE=personal sh "$root/bin/majix-storage" | grep -F 'Persistencia personal activa'
MODE=temporary sh "$root/bin/majix-storage" | grep -F 'Sesión temporal'
for example in unrelated readonly outside; do
    if MODE="$example" sh "$root/bin/majix-storage"; then
        printf 'Se confirmó erróneamente el modo %s\n' "$example" >&2
        exit 1
    fi
done
